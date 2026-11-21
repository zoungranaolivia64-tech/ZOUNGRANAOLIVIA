const TOKEN = 'campusflow-demo-token-2026';
const EMAIL = 'etudiant@campusflow.bf';
const PASSWORD = 'campusflow';

/** Traite POST /login. Renvoie true si la requête a été prise en charge. */
function handleLogin(req, res) {
  if (req.method !== 'POST' || req.path !== '/login') return false;
  const { email, password } = req.body || {};
  if (email === EMAIL && password === PASSWORD) {
    res.json({ token: TOKEN, user: { id: 1, name: 'Awa Sawadogo', email: EMAIL } });
  } else {
    res.status(401).json({ error: 'Identifiants incorrects' });
  }
  return true;
}

module.exports = { handleLogin, TOKEN };
