const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('❌ Connection failed:', err.stack);
  } else {
    console.log('✅ Connected to DB at:', res.rows[0].now);
  }
});

module.exports = pool; // exports the pool