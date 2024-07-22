<?php

include __DIR__ . "/../libs/helper.inc.php";

if (!isLogged()) {
  echo json_encode(["message" => "You are not logged in"]);
  http_response_code(401);
  exit;
}

if (isset($_SESSION['session_token'])) {
  insertValue("DELETE FROM sessions WHERE session_token = :token", [
    'token' => $_SESSION["session_token"]
  ]);

  // Cancella il cookie di sessione
  if (isset($_COOKIE['rmbme'])) {
    setcookie("rmbme", "", time() - 3600, "/");
  }
}

session_unset();
session_destroy();

echo json_encode(["message" => "Logout successful"]);
http_response_code(200);

header("Location: home");
exit;
