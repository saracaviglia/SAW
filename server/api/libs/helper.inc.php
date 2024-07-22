<?php
include __DIR__ . "/../connection/inc.php";

/* input checker */

/* function checkPwd($p, $cpass)
{ */
//$lowercase = preg_match("/.*[a-zàèéìòù]+.*/", $p);
//$uppercase = preg_match("/.*[A-Z]+.*/", $p);
//$numbers = preg_match("/.*[0-9]+.*/", $p);
//$character = preg_match("/.*[!|£\$%&=?\^\+-\.,:;_|\*].*/", $p);
/* 
  if (strlen($p) < 8) {
    http_response_code(400);
    echo "Password must be at least 8 characters long.";
    exit;
  }
  if ($lowercase || $uppercase || $numbers || $character) {
    if (
      ($lowercase && $uppercase) || ($lowercase && $numbers) || ($lowercase && $character) ||
      ($uppercase && $numbers) || ($uppercase && $character) || ($numbers) || ($character)
    ) {
      if (
        ($lowercase && $uppercase && $numbers) || ($lowercase && $uppercase && $character) ||
        ($lowercase && $numbers && $character) || ($uppercase && $numbers && $character)
      ) {
        if ($lowercase && $uppercase && $numbers && $character) {
          // se pass e cpass non sono uguali, impossible registrarsi nel sito
          if ($p != $cpass) {
            http_response_code(400);
            echo "Passwords do not match.";
            exit;
          }
          return true;
        }
      }
    }
  }
  http_response_code(400);
  echo "Invalid password format.";
  exit;
} */

function checkPwd($p, $cpass)
{
  // Regex pattern to match allowed characters
  $pattern = '/^[0-9A-Za-z!@&%$*#]{1,25}$/';

  // Check if password matches pattern
  if (preg_match($pattern, $p)) {
    // Check if passwords match
    if ($p !== $cpass) {
      http_response_code(400);
      echo "Passwords do not match.";
      exit;
    }
    return true;
  } else {
    http_response_code(400);
    echo json_encode(['error' => '"Password must only contain the following characters: 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@&%$*#"']);
    exit;
  }
}


function nameCheck($data): bool
{
  if (preg_match("/^(([a-zA-Z]+[àèéìòù]*\s+)+([a-zA-Z]+[àèéìòù]*\s*)|\b\d{4,}\b)$/", $data)) {
    return true;
  } else {
    http_response_code(400);
    echo "Invalid name format.";
    exit;
  }
}

function checkEmail($data): bool
{
  if (preg_match("/^[a-zA-Z\d\.]+@[a-zA-Z\d]+\.[a-z]{1,3}$/", $data)) {
    return true;
  } else {
    http_response_code(400);
    echo "Invalid email format.";
    exit;
  }
}

function checkUsername($data): bool
{
  if (preg_match("/^[a-zA-Z0-9_]*$/", $data) || empty($data) || $data == "") {
    return true;
  } else {
    http_response_code(400);
    echo "Invalid username format.";
    exit;
  }
}

function userExists($email): bool
{
  $res = getElem(
    "SELECT * FROM users WHERE email = :email ;",
    [
      'email' => $email,
    ]
  );

  if (!empty($res)) {
    http_response_code(400);
    echo "User already exists.";
    exit;
  }
  return false;
}

function checkAll($fullname, $email, $pwd, $cpwd): bool
{
  return namecheck($fullname) and checkEmail($email) and checkPwd($pwd, $cpwd) and !userExists($email);
}

function isLogged(): bool
{

  if (isset($_SESSION["uuid"])) {
    return true;
  }
  if (isset($_COOKIE['rmbme'])) {
    //! connect to the database and check if the user is registered
    $result = getElem(
      "SELECT remember_me, expiration_date, user_id FROM sessions WHERE session_token = :token_cookie;",
      ['token_cookie' => $_COOKIE['rmbme'] ?? null]
    );

    if (!empty($result)) {
      /* check if the keep_logged flag is 1 (true) */
      if ($result[0]['remember_me'] === 1) {
        /* check if is expired */
        if ($result[0]['expiration_date'] > date('Y-m-d H:i:s', time())) {
          // Regenerate session ID to prevent session fixation attacks
          session_regenerate_id(true);
          $_SESSION['uuid'] = $result[0]['user_id'];
          $_SESSION['session_token'] = $_COOKIE['rmbme'];
          return isLogged();
        }
      }
    }
  }
  return false;
}

// check if the user is an Admin
function isAdmin(): bool
{
  if (isLogged() && isset($_SESSION["admin"]) && $_SESSION['admin']) {
    return true;
  }

  //! connect to the database and check if the user is registered
  //? we don't have an admin table in the database, don't need that know
  /* $result = getElem(
    "SELECT is_admin FROM admin WHERE users_id = :id;",
    ['id' => $_SESSION['id'] ?? 'null']
  ); */

  // check if the user is logged

  if (!empty($result) && $result[0]['is_admin'] == 1) {
    $_SESSION['admin'] = true;
    return isAdmin();
  }
  return false;
}

function id($data): string
{
  $query = "SELECT id FROM users WHERE email = :email";
  $data = ['email' => $data];
  $res = getElem($query, $data);

  if (!empty($res))  return $res[0]['id'];
  return 'Unknown';
}

function dbInfo($id, $toFind): string
{
  $query = "SELECT $toFind FROM users WHERE id = :id;";
  $data = ['id' => $id];
  $res = getElem($query, $data);

  if (!empty($res))  return $res[0][$toFind];
  return 'Unknown';
}

function generateSessionToken($length = 32)
{
  return bin2hex(random_bytes($length / 2));
}
