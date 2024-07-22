<?php

if(!isLogged()){
  echo json_encode(["Error" => "must be logged in"]);
  http_response_code(401);
  exit;
}

if (!empty($_POST)) {
  // Access the data
  $eid = strip_tags($_POST['elem_id']) ?? null;
  $uuid = id(htmlspecialchars(strip_tags($_POST['uuid']))) == $_SESSION['uuid'] ? $_SESSION['uuid'] : null;
  $n_elem = $_POST['n_elem'] ?? 0;
} else {
  echo "Error decoding JSON data";
}

if ($eid === null || $n_elem === 0) {
  echo json_encode(["Error" => "missing data"]);
  http_response_code(400);
  exit;
}

$alr_in = getElem("SELECT quantity FROM shopping_cart WHERE user_id = :uuid AND product_id = :eid", [
  'uuid' => $uuid,
  'eid' => $eid,
]);

if (empty($alr_in)) {
  if (!insertValue("INSERT INTO shopping_cart (user_id, product_id, quantity) VALUES (:uuid, :eid, :quantity)", [
    'uuid' => $uuid,
    'eid' => $eid,
    'quantity' => $n_elem,
  ])) {
    echo json_encode(["Error" => "database error"]);
    http_response_code(500);
    exit;
  }
} else {
  if(!insertValue("UPDATE shopping_cart SET quantity = :quantity WHERE user_id = :uuid AND product_id = :eid", [
    'uuid' => $uuid,
    'eid' => $eid,
    'quantity' => $alr_in['quantity'] + $n_elem,
  ])){
    echo json_encode(["Error" => "database error"]);
    http_response_code(500);
    exit;
  }
}
