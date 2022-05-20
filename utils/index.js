const _ = require('lodash');

module.exports.mapUsers = users => {
  return users
    .map(user => {
      const {
        name: { first, last },
        gender,
        email,
        dob: { date }
      } = user;
      return `(
            '${first}', '${last}', '${email}', '${gender}', '${date}', '${(
        Math.random() + 1
      ).toFixed(2)}', false
        )`;
    })
    .join(',');
};

const PHONES_BRANDS = [
  'Samsung',
  'Siemens',
  'Nokia',
  'Motorolla',
  'IPhone',
  'Xiaomi',
  'Huawei',
  'Sony',
  'Alcatel'
];

const generateOnePhone = key => ({
  brand: PHONES_BRANDS[_.random(0, PHONES_BRANDS.length - 1, false)],
  model: `${key} model ${_.random(0, 100, false)}`,
  quantity: _.random(10, 1500, false),
  price: _.random(100, 10000, false)
});

module.exports.generatePhones = (length = 50) =>
  new Array(length).fill(null).map((el, i) => generateOnePhone(i));
