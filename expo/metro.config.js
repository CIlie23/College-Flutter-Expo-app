const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Drizzle's migration files.
config.resolver.sourceExts.push('sql');
// expo-sqlite on the web runs SQLite compiled to WebAssembly...
config.resolver.assetExts.push('wasm');
// ...which needs a cross-origin-isolated page (SharedArrayBuffer).
const enhanceMiddleware = config.server.enhanceMiddleware;
config.server.enhanceMiddleware = (middleware, metroServer) => {
  const enhancedMiddleware = enhanceMiddleware
    ? enhanceMiddleware(middleware, metroServer)
    : middleware;
  return (req, res, next) => {
    res.setHeader('Cross-Origin-Embedder-Policy', 'credentialless');
    res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
    return enhancedMiddleware(req, res, next);
  };
};

module.exports = config;