module.exports = {
  env: {
    browser: true,
    es6: false,
  },
  rules: {
    'no-var': 'off',
    'max-len': ['error', {'code': 120}],
    // We have many existing variables in snake_case so we do not enforce
    // camelCase
    'camelcase': 'off',
  },
};
