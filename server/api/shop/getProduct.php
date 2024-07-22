<?php

$page = $_GET['page'] ?? 1;
$items_per_page = $_GET['nElem'] ?? 16;
$searchedElem = $_GET['k'] ?? '';
$uuid = isset($_SESSION['uuid']) && $_SESSION['uuid'] == id($_GET['uuid']) ? $_SESSION['uuid'] : null;


// check if the user is logged in and get the user id
/* if (isset($_SESSION['uuid'])) {
  $uuid = $_SESSION['uuid'];
} else {
  $uuid = 1;
} */

$data = getElem(
  "SELECT sdv.*, COALESCE(sc.quantity, 1) AS quantity
    FROM spaceships_detail_view sdv
    LEFT JOIN shopping_cart sc 
    ON sdv.product_id = sc.product_id AND sc.user_id = :uuid
    WHERE sdv.product_name LIKE :searchElem",
  [
    'searchElem' => "%$searchedElem%",
    'uuid' => $uuid,
  ]
);

if (empty($data)) {
  echo json_encode(['message' => 'No items found'], JSON_PRETTY_PRINT);
  http_response_code(204);
  exit;
} else if ($data === false) {
  echo json_encode(['message' => 'An error occurred'], JSON_PRETTY_PRINT);
  http_response_code(500);
  exit;
}

$result = array_values($data);

// Paginate result array
$offset = ($page - 1) * $items_per_page;
$result = array_slice($result, $offset, $items_per_page);

if (empty($result)) {
  echo json_encode(['message' => 'No more items'], JSON_PRETTY_PRINT);
  http_response_code(204);
} else {
  echo json_encode($result, JSON_PRETTY_PRINT);
  http_response_code(200);
}
