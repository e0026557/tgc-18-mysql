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

  await connection.execute('SELECT * FROM actor');
}
main();

app.listen(3000, function () {
  console.log('Server has started.');
})