const path = require('path');

module.exports = {
  entry: path.resolve('./src/index'),
  dist: path.resolve('./docs'),
  template: path.resolve('./src/index.html'),
  favicon: path.resolve('./src/favicon.ico'),
  assets: path.resolve('./src/assets'),
  json: path.resolve('./src/json'),
  ownModules: path.resolve(__dirname, '../node_modules'),
  scripts: path.resolve(__dirname, '../scripts'),
  elmMake: path.resolve(__dirname, '../node_modules/.bin/elm-make')
};
