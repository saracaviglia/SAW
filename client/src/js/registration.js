document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('registration');
  const firstnameInput = document.getElementById('firstname');
  const lastnameInput = document.getElementById('lastname');
  const emailInput = document.getElementById('email');
  const passwordInput = document.getElementById('password');
  const confirmInput = document.getElementById('confirm');
  const errorMsg_firstname = document.getElementById('err-firstname');
  const errorMsg_lastname = document.getElementById('err-lastname');
  const errorMsg_email = document.getElementById('err-email');
  const errorMsg_pwd = document.getElementById('err-password');
  const errorMsg_confirm = document.getElementById('err-confirm');

  // Clear previous error messages
  // errorMsg = errorMsg.textContent.replace('Error: ', '');

  form.addEventListener('submit', async function (event) {
    event.preventDefault(); // Prevent form from submitting by default

    // Validate inputs
    const firstname = firstnameInput.value;
    const lastname = lastnameInput.value;
    const email = emailInput.value;
    const password = passwordInput.value;
    const confirm = confirmInput.value;
    let valid = true;

    if (firstname === '' || firstname === null) {
      valid = false;
      errorMsg_firstname.style.display = "block";
    } else {
      errorMsg_firstname.style.display = "none";
    }

    if (lastname === '' || lastname === null) {
      valid = false;
      errorMsg_lastname.style.display = "block";
    } else {
      errorMsg_lastname.style.display = "none";
    }

    if (email === '' || email === null) {
      valid = false;
      errorMsg_email.style.display = "block";
    } else {
      errorMsg_email.style.display = "none";
    }

    if (password === '' || password === null) {
      valid = false;
      errorMsg_pwd.style.display = "block";
    } else {
      errorMsg_pwd.style.display = "none";
    }

    if (confirm === '' || confirm === null) {
      valid = false;
      errorMsg_pwd.style.display = "block";
    } else {
      errorMsg_pwd.style.display = "none";
    }

    if (password !== confirm) {
      valid = false;
      errorMsg_confirm.style.display = "block";
    } else {
      errorMsg_confirm.style.display = "none";
    }

    const bodyMessage = new URLSearchParams();
    bodyMessage.append('firstname', firstname);
    bodyMessage.append('lastname', lastname);
    bodyMessage.append('email', email);
    bodyMessage.append('pass', password);
    bodyMessage.append('confirm', confirm);

    // If valid, allow form submission (or handle login logic here)
    if (valid) {
      const response = await fetch(`${backendUrl.development}r`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: bodyMessage.toString(),
      });
      const contentType = response.headers.get("content-type");
      let responseBody;

      if (contentType && contentType.includes("application/json")) {
        responseBody = await response.json(); // Read the response body once
      } else {
        responseBody = await response.text(); // Fallback to text if not JSON
      }
      if (!response.ok) {

        const error = document.createElement('div');
        const errorDiv = document.getElementById('errors');
        error.textContent = responseBody.error || responseBody;
        errorDiv.appendChild(error);
        throw new Error(`HTTP error! status: ${response.status}`);

      } else
        window.location.href = "";
    } else {
      alert('Please fix the errors before submitting.');
    }

  });
});
