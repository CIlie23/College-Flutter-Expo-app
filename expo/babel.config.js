module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    // Drizzle's migrations are .sql files: inline them into the bundle as strings.
    plugins: [['inline-import', { extensions: ['.sql'] }]],
  };
};