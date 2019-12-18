module.exports = {
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "jquery": true,
    "node": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 10,
    "sourceType": "module"
  },
  "rules": {
    "indent": [
      "error",
      2,
      {
        "SwitchCase": 1
      }
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "error",
      "double"
    ],
    "semi": [
      "error",
      "always"
    ]
  }
};
