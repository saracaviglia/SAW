<?php

// Read raw POST data
$postData = file_get_contents("php://input");
// Decode JSON data
$data = json_decode($postData, true);

if (!isset($data['uuid']) || !isset($data['prod_id'])) {
  echo json_encode(['message' => 'Invalid data'], JSON_PRETTY_PRINT);
  exit;
} else {
  $uuid = id(htmlspecialchars(strip_tags($data['uuid']))) == $_SESSION['uuid'] && isLogged() ? $_SESSION['uuid'] : null;
  $prod_id = htmlspecialchars(strip_tags($data['prod_id'])) ?? null;
}

if (isset($data['deleteAll']) && $data['deleteAll'] === true) {
  insertValue("DELETE FROM shopping_cart WHERE user_id = :uuid", [
    'uuid' => $uuid,
  ]);

  // echo json_encode(['message' => 'All items deleted'], JSON_PRETTY_PRINT);
  http_response_code(204);
  exit;
} else {
  if (!insertValue("DELETE FROM shopping_cart WHERE user_id = :uuid AND product_id = :prod_id", [
    'uuid' => $uuid,
    'prod_id' => $prod_id,
  ])) {
    http_response_code(500);
    exit;
  }

  http_response_code(204);
  exit;
}
