var path = require('path');
module.exports = {
  entry: {
    app: './js/app.js'
  },
  output: {
    path: path.join(__dirname, '../priv/static'),
    filename: 'js/[name].js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react']
          }
        }
      }
    ]
  }
};
