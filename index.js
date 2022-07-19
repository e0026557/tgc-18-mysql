// Require dependencies
const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
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

  app.get('/actors/create', async function(req, res) {
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

}
main();

app.listen(3000, function () {
  console.log('Server has started.');
})