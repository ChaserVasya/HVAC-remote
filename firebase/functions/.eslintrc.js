module.exports = {
  root: true,
  env: {
    es2021: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "linebreak-style": ["error", "windows"],
    "quotes": ["error", "double"],
    "require-jsdoc": "off",
  },
};
