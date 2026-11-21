// Séance 7 — étape « Serveur simulé » : ajoute seulement POST /login
// (sans protéger les autres routes, pour pouvoir ouvrir /taches dans le navigateur).
const { handleLogin } = require('./auth-common');

module.exports = (req, res, next) => {
  if (handleLogin(req, res)) return;
  next();
};
