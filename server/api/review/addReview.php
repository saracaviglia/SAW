<?php

if (!isLogged()) {
  echo json_encode(['message' => 'Must be logged in'], JSON_PRETTY_PRINT);
  http_response_code(401);
  exit;
}

if (!isset($_POST['eid']) || !isset($_POST['title']) || !isset($_POST['rating'])) {
  echo json_encode(array("error" => "Missing parameters" . json_encode($_POST)));
  http_response_code(400);
  exit;
}

$username = getElem("SELECT username FROM user_details WHERE user_id = :uuid", [
  "uuid" => $_SESSION['uuid']
]);

if (count($username) == 0) {
  echo json_encode(array("error" => "U need to have a public name <a href='profile'>here</a>"));
  http_response_code(404);
  exit;
}

if (!$username) {
  echo json_encode(array("error" => "An error occurred while getting user details"));
  http_response_code(500);
  exit;
}



$eid = htmlspecialchars(strip_tags($_POST['eid']));
$title = htmlspecialchars(strip_tags($_POST['title']));
$rating = htmlspecialchars(strip_tags($_POST['rating']));
$description = htmlspecialchars(strip_tags($_POST['review'] ?? null));

if (!is_numeric($eid) || !is_numeric($rating)) {
  echo json_encode(array("error" => "Invalid parameters"));
  http_response_code(400);
  exit;
}

if ($rating < 1 || $rating > 10) {
  echo json_encode(array("error" => "Rating must be between 1 and 5"));
  http_response_code(400);
  exit;
}

$uuid = $_SESSION['uuid'];

// check if user purchased the element 

$item = getElem("SELECT id FROM order_items AS oi WHERE oi.product_id = :eid AND oi.order_id IN 
                (SELECT id FROM `orders` AS o WHERE o.user_id = :uuid);", [
  "eid" => $eid,
  "uuid" => $uuid
]);

if (!$item) {
  echo json_encode(array("error" => "You must have purchased the item to review it."));
  http_response_code(500);
  exit;
} else if (count($item) == 0) {
  echo json_encode(array("error" => "You must purchase the item to review it"));
  http_response_code(403);
  exit;
}

// check if user already reviewed the element

if (count(getElem("SELECT id FROM reviews WHERE product_id = :eid AND user_id = :uuid", [
  "eid" => $eid,
  "uuid" => $uuid
])) > 0) {
  echo json_encode(array("error" => "You already reviewed this item"));
  http_response_code(403);
  exit;
}

// insert review

if (insertValue("INSERT INTO reviews (product_id, user_id, title, rating, comment) VALUES (:eid, :uuid, :title, :rating, :description)", [
  "eid" => $eid,
  "uuid" => $uuid,
  "title" => $title,
  "rating" => $rating,
  "description" => $description
])) {
  echo json_encode(array("success" => "Review added successfully"));
  http_response_code(200);
  exit;
} else {
  echo json_encode(array("error" => "An error occurred while adding the review"));
  http_response_code(500);
  exit;
}
