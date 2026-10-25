const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Drizzle's migration files.
config.resolver.sourceExts.push('sql');
// expo-sqlite on the web runs SQLite compiled to WebAssembly...
config.resolver.assetExts.push('wasm');
// ...which needs a cross-origin-isolated page (SharedArrayBuffer).
config.server.enhanceMiddleware = (middleware) => (req, res, next) => {
  res.setHeader('Cross-Origin-Embedder-Policy', 'credentialless');
  res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  return middleware(req, res, next);
};

module.exports = config;