<?php


include __DIR__ . '/../libs/helper.inc.php';


$latest_add = $_GET['x'] ?? 0;

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  if ($latest_add) {
    $data = getElem('SELECT sdv.*, COALESCE(sc.quantity, 1) AS quantity
    FROM spaceships_detail_view sdv
    LEFT JOIN shopping_cart sc 
    ON sdv.product_id = sc.product_id AND sc.user_id = :uuid
    ORDER BY product_updated_at DESC LIMIT 16', [
      'uuid' => $_SESSION['uuid'] ?? null,
    ]);

    if (empty($data)) {
      http_response_code(204); // No content
      echo json_encode(['message' => 'No items found']);
      exit;
    } else if ($data === false) {
      http_response_code(500); // Internal server error
      echo json_encode(['message' => 'An error occurred']);
      exit;
    }
    echo json_encode($data, JSON_PRETTY_PRINT);
    http_response_code(200);
    exit;
  } else {
    http_response_code(400); // Bad request (invalid request)
    echo "Invalid request";
  }
} else {
  http_response_code(400);
  echo "Invalid request";
}
