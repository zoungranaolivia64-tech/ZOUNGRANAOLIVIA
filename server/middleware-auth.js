// Séance 7 — étape « Connexion » : POST /login + jeton obligatoire partout ailleurs (401 sinon).
const { handleLogin, TOKEN } = require('./auth-common');

module.exports = (req, res, next) => {
  if (handleLogin(req, res)) return;
  if (req.method === 'OPTIONS') return next();
  if (req.headers.authorization !== `Bearer ${TOKEN}`) {
    return res.status(401).json({ error: 'Jeton manquant ou invalide' });
  }
  next();
};
