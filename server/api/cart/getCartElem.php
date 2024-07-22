<?php

$uuid = id(htmlspecialchars(strip_tags($_GET['uuid']))) == $_SESSION['uuid'] && isLogged() ? $_SESSION['uuid'] : null;

$data = getElem("SELECT * FROM shopping_cart as c JOIN spaceships_detail_view as s on c.product_id = s.product_id WHERE c.user_id = :uuid", [
  'uuid' => $uuid,
]);

echo json_encode($data, JSON_PRETTY_PRINT);
