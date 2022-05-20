const path = require('path');
const fs = require('fs').promises;
const { User, client, Phone, Order } = require('./models');
const { loadUsers } = require('./api/');
const { generatePhones } = require('./utils');

start();

async function start () {
  await client.connect();

  const resetDBQuery = await fs.readFile(
    path.join(__dirname, '/reset-db-query.sql'),
    'utf8'
  );
  await client.query(resetDBQuery);

  // const users = await User.bulkCreate(await loadUsers());
  const { rows: users } = await User.findAll();
  const phones = await Phone.bulkCreate(generatePhones());
  const orders = await Order.bulkCreate(users, phones);

  await client.end();
}
