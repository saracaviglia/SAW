<?php
include __DIR__ . "/../libs/helper.inc.php";

$requestURL = explode('/', $_SERVER['REQUEST_URI']);

$URL_lenght = $requestURL[count($requestURL) - 1];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  //require __DIR__ . "/add.php";
} else if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  require __DIR__ . "/getProduct.php";
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
  http_response_code(405);
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
  http_response_code(405);
} else {
  echo "Invalid request";
}
