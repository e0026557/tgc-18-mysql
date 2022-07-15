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
    
    let [actors] = await connection.execute(query, bindings);

    res.render('search', {
      'actors': actors
    })
  })
  
}
main();

app.listen(3000, function () {
  console.log('Server has started.');
})