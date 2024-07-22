const backendUrl = {
  development: 'http://localhost/sawProject/server/api/',
  production: 'https://saw21.dibris.unige.it/~S5163676/server/api/'
};

async function get_user_status() {
  const response = await fetch(`${backendUrl.development}user/status`, {
    method: 'GET',
  });
  const data = await response.json();

  return data['user_status'];
}

function logout() {
  // delete session and local storage
  sessionStorage.clear();
  localStorage.clear();

  // redirect to login page
  window.location.href = 'logout';
}

document.addEventListener('DOMContentLoaded', function () {
  const profileBtn = document.getElementById('profile');

  profileBtn.addEventListener('click', function (event) {
    event.stopPropagation(); // Prevent the click event from bubbling up to the document
    profileBtn.classList.toggle('active');
  });

  document.addEventListener('click', function (event) {
    if (!profileBtn.contains(event.target)) {
      profileBtn.classList.remove('active');
    }
  });
});

