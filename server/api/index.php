<?php
// process-data.php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

session_start();

$requestURL = "http://{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";


$base_url = "http://" . $_SERVER['HTTP_HOST'] . "/" . explode("/", $_SERVER['REQUEST_URI'])[1] . "/server/api/";

$requestURL = str_replace($base_url, "", $requestURL);

// TODO: send request to form.php file 
if ($requestURL[0] == "r") {
  require __DIR__ . "/forms/Registration.php";
} else if ($requestURL == "logout.php" or $requestURL == "logout") {
  require __DIR__ . "/forms/logout.php";
} else if ($requestURL[0] == "l") {
  require __DIR__ . "/forms/Login.php";
} else if ($requestURL[0] == "p" or $requestURL == "show_profile.php" or $requestURL == "update_profile.php") {
  if (strpos($requestURL, "details"))
    require __DIR__ . "/user/details.php";
  else
    require __DIR__ . "/forms/update_profile.php";
} else if ($requestURL[0] == "s") {
  require __DIR__ . "/shop/Shop.php";
} else if ($requestURL[0] == "h") {
  require __DIR__ . "/home/home.php";
} else if ($requestURL[0] == "e") {
  if (strpos($requestURL, "review")) {
    require __DIR__ . "/review/Review.php";
  } else {
    require __DIR__ . "/shop/GetElem.php";
  }
} else if ($requestURL[0] == "c") {
  if (strpos($requestURL, "checkout")) {
    require __DIR__ . "/cart/checkout/Checkout.php";
  } else {
    require __DIR__ . "/cart/Cart.php";
  }
} else if (preg_match("#^user/status(\?.*)?$#", $requestURL)) {
  require __DIR__ . "/user/status.php";
} else {
  echo "wtf are u doing here?! <br>";
  echo $requestURL;
}
