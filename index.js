// Require dependencies
const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
require('handlebars-helpers')({
  'handlebars': hbs.handlebars
});
require('dotenv').config();
const mysql2 = require('mysql2/promise'); // To use await/async, must use the promise version of mysql2

const app = express();
app.set('view engine', 'hbs');
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

// Enable form processing
app.use(express.urlencoded({
  extended: false
}));

async function main() {
  const connection = await mysql2.createConnection({
    'host': process.env.DB_HOST, // 'host' -> IP address of the database server
    'user': process.env.DB_USER,
    'database': process.env.DB_DATABASE,
    'password': process.env.DB_PASSWORD
  })

  app.get('/error', async function(req, res) {
    res.status(500);
    res.send('An error has occurred')
  })

  app.get('/actors', async function(req, res) {
    // connection.execute returns an array of results
    // the first element is the table that we selected
    // the other elements are some housekeeping data
    const [actors] = await connection.execute('SELECT * FROM actor');

    // alternatively
    // const results = await connection.execute('SELECT * FROM actor');
    // const actors = results[0];

    res.render('actors.hbs', {
      'actors': actors
    });
  })

  app.get('/staffs', async function(req, res) {
    const [staffs] = await connection.execute('SELECT staff_id, first_name, last_name, email FROM staff');

    res.render('staffs.hbs', {
      staffs
    })
  })

  // Create a search engine
  // USE BINDING TO PREVENT SQL INJECTION
  // '?' is a placeholder
  // -> the replacement is only done on the SQL server
  app.get('/search', async function(req, res) {
    // Define the 'get all results query'
    let query = 'SELECT * FROM actor WHERE 1';
    
    let bindings = []

    // If req.query.name is not falsy
    if (req.query.first_name) {
      query += ` AND first_name LIKE ?`
      bindings.push('%' + req.query.first_name + '%');
    }

    if (req.query.last_name) {
      query += ` AND last_name LIKE ?`
      bindings.push('%' + req.query.last_name + '%');
    }
    
    // connection.execute returns an array
    let [actors] = await connection.execute(query, bindings);

    res.render('search', {
      'actors': actors
    })
  })

  app.get('/actors/create', function(req, res) {
    res.render('create_actor');
  })
  
  app.post('/actors/create', async function(req, res) {
    // sample query
    // insert into actor (first_name, last_name) values ('fann', 'wong')
    const query = `insert into actor (first_name, last_name) values (? , ?)`;
    const bindings = [req.body.first_name, req.body.last_name];
    await connection.execute(query, bindings);
    res.redirect('/actors');
  })

  app.get('/actors/:actor_id/update', async function(req, res) {
    // select * from actors where actor_id = 1
    const actorId = parseInt(req.params.actor_id);
    const query = 'SELECT * FROM actor where actor_id = ?';
    const [actors] = await connection.execute(query, [actorId]);
    const actorToUpdate = actors[0]; // since we are only expecting one result, we just take the first index

    res.render('update_actor', {
      'actor': actorToUpdate
    })

  })

  app.post('/actors/:actor_id/update', async function(req, res) {
    if (req.body.first_name.length > 45 || req.body.last_name.length > 45) {
      res.status(400);
      res.send("Invalid request");
      return;
    }

    // sample query
    // UPDATE actors SET first_name=?, last_name=? WHERE actor_id = ?;
    const query = `UPDATE actor SET first_name=?, last_name=? WHERE actor_id = ?`;
    const bindings = [req.body.first_name, req.body.last_name, parseInt(req.params.actor_id)];

    await connection.execute(query, bindings);
    res.redirect('/actors');
  })

  app.post('/actors/:actor_id/delete', async function(req, res) {
    const query = `DELETE FROM actor WHERE actor_id = ?`;
    const bindings = [parseInt(req.params.actor_id)];

    await connection.execute(query, bindings);
    res.redirect('/actors');
  })

  // HANDS ON 1
  // CRUD for category table
  app.get('/categories', async function(req, res) {
    // Get all categories
    const query = `SELECT * FROM category ORDER BY name ASC`
    let [categories] = await connection.execute(query);

    res.render('categories', {
      categories: categories
    })
  })

  app.get('/categories/create', function(req, res) {
    res.render('create_category');
  })

  app.post('/categories/create', async function(req, res) {
    if (req.body.name.length > 25) {
      res.status(400);
      res.send('Invalid category name');
      return;
    }
    const query = `INSERT INTO category (name) VALUES (?)`;
    await connection.execute(query, [req.body.name]);

    res.redirect('/categories');
  })

  app.get('/categories/:category_id/update', async function(req, res) {
    // Get category detail
    const query = `SELECT * FROM category WHERE category_id = ?`;

    try {
      const [categories] = await connection.execute(query, [parseInt(req.params.category_id)]);
  
      res.render('update_category', {
        category: categories[0]
      })
    }
    catch(err) {
      console.log(err);
      res.redirect('/error')
    }
  })

  app.post('/categories/:category_id/update', async function(req, res) {
    const query = `UPDATE category SET name = ? WHERE category_id = ?`;
    const bindings = [req.body.name, parseInt(req.params.category_id)];

    await connection.execute(query, bindings);

    res.redirect('/categories');
  })

  app.get('/categories/:category_id/delete', async function(req, res) {
    // Get category to be deleted
    const query = `SELECT * FROM category WHERE category_id = ?`;
    const [categories] = await connection.execute(query, [parseInt(req.params.category_id)]);

    res.render('delete_category', {
      category: categories[0]
    })
  })

  app.post('/categories/:category_id/delete', async function(req, res) {
    // Remove all the films which have category_id equal to the one that we are trying to delete
    const deleteQuery = `DELETE FROM film_category WHERE category_id =?`;
    await connection.execute(deleteQuery, [parseInt(req.params.category_id)]);

    const query = `DELETE FROM category WHERE category_id = ?`
    await connection.execute(query, [parseInt(req.params.category_id)]);

    res.redirect('/categories');
  })


  app.get('/films', async function(req, res) {
    const [films] = await connection.execute(`SELECT film_id, title, description, language.name AS 'language' FROM film JOIN language ON film.language_id = language.language_id`);
    res.render('films', {
      films: films
    })
  })

  app.get('/films/create', async function(req, res) {
    const [languages] = await connection.execute(
      'SELECT * FROM language'
    );
    res.render('create_film', {
      languages: languages
    })
  })

  app.post('/films/create', async function(req, res) {
    const query = `INSERT INTO film (title, description, language_id) VALUES (?, ?, ?)`;
    const bindings = [req.body.title, req.body.description, parseInt(req.body.language_id)];

    await connection.execute(query, bindings);

    res.redirect('/films');
  })

  app.get('/films/:film_id/update', async function(req,res) {
    const [languages] = await connection.execute('SELECT * FROM language');
    const [films] = await connection.execute('SELECT * FROM film WHERE film_id = ?', [req.params.film_id])
    const filmToUpdate = films[0];
    res.render('update_film', {
      film: filmToUpdate,
      languages: languages
    })
  })

  app.post('/films/:film_id/update', async function(req, res) {
    // Note: Need to validate form fields first (not shown here)
    const query = `UPDATE film SET title = ?, description = ?, language_id = ? WHERE film_id = ?`;
    const bindings = [req.body.title, req.body.description, parseInt(req.body.language_id), parseInt(req.params.film_id)];

    await connection.execute(query, bindings);
    res.redirect('/films');
  })

}
main();

app.listen(3000, function () {
  console.log('Server has started.');
})