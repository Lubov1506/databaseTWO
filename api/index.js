const axios = require('axios');

const http = axios.create({
  baseURL: 'https://randomuser.me/api/'
});

module.exports.loadUsers = async () => {
  const {
    data: { results }
  } = await http.get('?results=500&seed=freshcode&page=9');
  return results;
};
