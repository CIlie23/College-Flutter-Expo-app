const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

// Drizzle's migration files.
config.resolver.sourceExts.push('sql');
// expo-sqlite on the web runs SQLite compiled to WebAssembly...
config.resolver.assetExts.push('wasm');
// ...which needs a cross-origin-isolated page (SharedArrayBuffer): two headers
// on every response of the dev server. Not with enhanceMiddleware, as in week 3:
// @expo/cli 58.1.15 (expo 58.0.19) answers the page itself before Metro's
// middleware runs, so the page came without them (measured 2026-10-27).
const { ServerResponse } = require('node:http');
const writeHead = ServerResponse.prototype.writeHead;
ServerResponse.prototype.writeHead = function (...args) {
  this.setHeader('Cross-Origin-Embedder-Policy', 'credentialless');
  this.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
  return writeHead.apply(this, args);
};

module.exports = config;