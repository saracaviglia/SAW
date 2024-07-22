<?php

$eid = htmlspecialchars(strip_tags($_GET['eid']));

if ($eid === null) {
  echo json_encode(['message' => 'Invalid data'], JSON_PRETTY_PRINT);
  http_response_code(400);
  exit;
}

$review = getElem(
  "SELECT ud.username, r.title, r.rating, r.comment, r.id FROM reviews AS r JOIN users AS u ON r.user_id = u.id JOIN user_details AS ud ON u.id = ud.user_id WHERE r.product_id = :eid;",
  [
    'eid' => $eid,
  ]
);

if (count($review) == 0) {
  echo json_encode(['message' => 'No reviews for this product'], JSON_PRETTY_PRINT);
  http_response_code(204);
  exit;
}

if (!$review) {
  echo json_encode(['message' => 'Error getting reviews'], JSON_PRETTY_PRINT);
  http_response_code(500);
  exit;
}

echo json_encode($review, JSON_PRETTY_PRINT);
http_response_code(200);
exit;
