<?php

include __DIR__ . "/../libs/helper.inc.php";

$response = [
  'isLogged' => false,
  'isAdmin' => false
];

$response['isLogged'] = isLogged();
$response['isAdmin'] = isAdmin();

echo json_encode(['user_status' => $response], JSON_PRETTY_PRINT);
