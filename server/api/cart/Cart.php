<?php

include __DIR__ . "/../libs/helper.inc.php";

if(!isLogged()) {
  echo json_encode(['message' => 'Must be logged in'], JSON_PRETTY_PRINT);
  http_response_code(401);
  exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  require __DIR__ . "/addToCart.php";
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  require __DIR__ . "/getCartElem.php";
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
  http_response_code(405);
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
  require __DIR__ . "/deleteFromCart.php";
} else {
  echo "Invalid request";
}
