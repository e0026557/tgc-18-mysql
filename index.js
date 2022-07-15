// Require dependencies
const express = require('express');
const hbs = require('hbs');
const wax = require('wax-on');
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
    'host': 'localhost', // 'host' -> IP address of the database server
    'user': 'root',
    'database': 'sakila',
    'password': ''
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
  
}
main();

app.listen(3000, function () {
  console.log('Server has started.');
})