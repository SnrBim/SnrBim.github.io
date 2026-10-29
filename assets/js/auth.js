const allowedDomains = new Set(['bW9iaWxpdHkuc2VuZXI=', 'c2VuZXIuZXM='].map(value => atob(value)));
const emailStorageKey = 'bimtools-site-email';
const spanish = /^\/es(?:\/|$)/.test(window.location.pathname);
const messages = spanish ? {
  title: 'Inicio de sesión',
  label: 'Introduce tu correo corporativo:',
  signIn: 'Iniciar sesión',
  signingIn: 'Iniciando sesión…',
  signedIn: 'Inicio de sesión completado, redirigiendo…',
  invalid: 'Error: usa una dirección corporativa',
  signOut: 'Cerrar sesión',
} : {
  title: 'Sign-in',
  label: 'Enter corporate email:',
  signIn: 'Sign in',
  signingIn: 'Signing in…',
  signedIn: 'Sign-in complete, redirecting…',
  invalid: 'Error: Use a corporate address',
  signOut: 'Sign out',
};

const gate = document.createElement('main');
gate.id = 'auth-gate';
gate.innerHTML = `
  <div class="auth-card">
    <div class="auth-heading">
      <img class="auth-logo" src="/assets/images/logo.png" alt="Sener BIMTools">
      <h1></h1>
    </div>
    <form>
      <label for="auth-email"></label>
      <input id="auth-email" type="email" autocomplete="email" required>
      <button type="submit"></button>
    </form>
    <p class="auth-message" role="status" aria-live="polite"></p>
    <div class="auth-progress" role="status" hidden>
      <span class="auth-spinner" aria-hidden="true"></span>
      <span class="auth-check" aria-hidden="true" hidden>✓</span>
      <span class="auth-progress-text"></span>
    </div>
  </div>`;
document.body.prepend(gate);
document.body.classList.add('auth-gate-ready');

gate.querySelector('h1').textContent = messages.title;
gate.querySelector('label').textContent = messages.label;
gate.querySelector('button').textContent = messages.signIn;
const emailInput = gate.querySelector('input');
const submitButton = gate.querySelector('button');
const message = gate.querySelector('.auth-message');
const progress = gate.querySelector('.auth-progress');
const spinner = progress.querySelector('.auth-spinner');
const check = progress.querySelector('.auth-check');
const progressText = progress.querySelector('.auth-progress-text');

const userInfo = document.createElement('div');
userInfo.id = 'auth-user';
userInfo.hidden = true;
const userEmail = document.createElement('span');
const signOutButton = document.createElement('button');
signOutButton.id = 'auth-sign-out';
signOutButton.type = 'button';
signOutButton.textContent = messages.signOut;
userInfo.append(userEmail, document.createTextNode(' · '), signOutButton);
const footer = document.querySelector('.site-footer') || document.body;
footer.prepend(userInfo);

function normalizedEmail(value) {
  return value.trim().toLowerCase();
}

function isAllowedEmail(value) {
  const email = normalizedEmail(value);
  const parts = email.split('@');
  if (parts.length !== 2 || !allowedDomains.has(parts[1])) return false;

  const validationInput = document.createElement('input');
  validationInput.type = 'email';
  validationInput.required = true;
  validationInput.value = email;
  return validationInput.validity.valid;
}

function showSite(email) {
  userEmail.textContent = email.split('@')[0].split('.')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
  userInfo.hidden = false;
  gate.hidden = true;
  document.documentElement.setAttribute('data-authenticated', '');
}

function showGate() {
  userInfo.hidden = true;
  userEmail.textContent = '';
  document.documentElement.removeAttribute('data-authenticated');
  gate.hidden = false;
}

gate.querySelector('form').addEventListener('submit', event => {
  event.preventDefault();
  const email = normalizedEmail(emailInput.value);
  if (!isAllowedEmail(email)) {
    message.textContent = messages.invalid;
    return;
  }
  message.textContent = '';
  emailInput.disabled = true;
  submitButton.disabled = true;
  progressText.textContent = messages.signingIn;
  spinner.hidden = false;
  check.hidden = true;
  progress.hidden = false;
  window.setTimeout(() => {
    spinner.hidden = true;
    check.hidden = false;
    progressText.textContent = messages.signedIn;
    window.setTimeout(() => {
      try { localStorage.setItem(emailStorageKey, email); }
      catch { /* The site stays open until the page is reloaded. */ }
      progress.hidden = true;
      emailInput.disabled = false;
      submitButton.disabled = false;
      showSite(email);
    }, 1500);
  }, 3000);
});

signOutButton.addEventListener('click', () => {
  try { localStorage.removeItem(emailStorageKey); }
  catch { /* Storage is optional. */ }
  emailInput.value = '';
  message.textContent = '';
  showGate();
});

try {
  const email = normalizedEmail(localStorage.getItem(emailStorageKey) || '');
  if (isAllowedEmail(email)) showSite(email);
} catch { /* Storage is optional. */ }
