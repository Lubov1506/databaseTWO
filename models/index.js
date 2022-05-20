const { Client } = require('pg');
const User = require('./User');
const Phone = require('./Phone');
const Order = require('./Order');

const config = require('../configs/db.json');

const client = new Client(config);

User._client = client;
User._tableName = 'users';

Phone._client = client;
Phone._tableName = 'phones';

Order._client = client;

module.exports = {
  client,
  User,
  Phone,
  Order
};
