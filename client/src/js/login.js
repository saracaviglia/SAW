document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('login');
  const emailInput = document.getElementById('email');
  const passwordInput = document.getElementById('password');
  const rememberInput = document.getElementById('remember');
  const errorMsg_email = document.getElementById('err-email');
  const errorMsg_pwd = document.getElementById('err-pwd');

  form.addEventListener('submit', async function (event) {
    event.preventDefault();

    // Sanitize inputs using DOMPurify
    const email = DOMPurify.sanitize(emailInput.value);
    const password = DOMPurify.sanitize(passwordInput.value);
    let valid = true;

    if (email === '' || email === null) {
      valid = false;
      // console.log("email empty"); 
      errorMsg_email.style.display = "block";
    } else {
      errorMsg_email.style.display = "none";
    }

    if (password === '' || password === null) {
      valid = false;
      // console.log("pwd empty"); 
      errorMsg_pwd.style.display = "block";
    } else {
      errorMsg_pwd.style.display = "none";
    }

    const remember = rememberInput.checked;

    console.log(remember);

    const bodyMessage = new URLSearchParams();
    bodyMessage.append('email', email);
    bodyMessage.append('pass', password);
    bodyMessage.append('remember', remember ? 1 : 0);

    // console.log(bodyMessage.toString());

    if (valid) {
      const response = await fetch(`${backendUrl.development}l`, {
        method: "POST",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: bodyMessage.toString(),
      });

      if (!response.ok) {
        const error = document.createElement('div');
        const errorDiv = document.getElementById('errors');
        error.textContent = response.statusText;
        errorDiv.appendChild(error);
        throw new Error(`HTTP error! status: ${response.status}`);
      } else {
        sessionStorage.setItem('email', email);
        window.location.href = "";
      }
    }
  });
});
