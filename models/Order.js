const _ = require('lodash');

class Order {
  static _client;
  static _tableName;

  static async bulkCreate (users, phones) {
    const ordersValuesString = users
      .map(u =>
        new Array(_.random(1, 4, false))
          .fill(null)
          .map(() => `(${u.id})`)
          .join(',')
      )
      .join(',');

    const { rows: orders } = await this._client.query(`
        INSERT INTO "orders" ("user_id")
        VALUES ${ordersValuesString}
        RETURNING id;
        `);

    const phonesToOrdersValuesString = orders
      .map(o => {
        const arr = new Array(_.random(1, phones.length))
          .fill(null)
          .map(() => phones[_.random(1, phones.length - 1)]);
        return [...new Set(arr)]
          .map(p => `(${o.id}, ${p.id}, ${_.random(1, 4, false)})`)
          .join(',');
      })
      .join(',');

    return this._client.query(`
            INSERT INTO "orders_to_phones"
            ("order_id", "phone_id", "quantity")
            VALUES ${phonesToOrdersValuesString};
            `);
  }
}

module.exports = Order;
