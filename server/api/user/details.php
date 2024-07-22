<?php

include __DIR__ . "/../libs/helper.inc.php";


if (!isLogged()) {
  echo json_encode(['message' => 'Must be logged in'], JSON_PRETTY_PRINT);
  http_response_code(401);
  exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  $res = getElem("SELECT * FROM user_details WHERE user_id = :id", ['id' => $_SESSION['uuid']]);

  if (!$res) {
    echo json_encode(['message' => 'User not found'], JSON_PRETTY_PRINT);
    http_response_code(404);
    exit;
  } else {
    echo json_encode($res, JSON_PRETTY_PRINT);
    http_response_code(200);
    exit;
  }
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
  $data = json_decode(file_get_contents('php://input'), true);

  $res = getElem("SELECT * FROM user_details WHERE user_id = :id", ['id' => $_SESSION['uuid']]);

  if (empty($res)) {
    $value = insertValue("INSERT INTO user_details (user_id, username, phone_number, bio, birthdate) VALUES (:id, :username, :phone, :bio, :bd)", [
      'id' => $_SESSION['uuid'],
      'username' => $data['username'] ?? null,
      'phone' => $data['phone_number'] ?? null,
      'bio' => $data['bio'] ?? null,
      'bd' => !empty($data['birthdate']) ? date('Y-m-d', strtotime($data['birthdate'])) : null,
    ]);
  } else {
    $value = insertValue("UPDATE user_details SET username = :username, phone_number = :phone, bio = :bio, birthdate = :bd WHERE user_id = :id", [
      'username' => $data['username'] ?? null,
      'phone' => $data['phone_number'] ?? null,
      'bio' => $data['bio'] ?? null,
      'bd' => !empty($data['birthdate']) ? date('Y-m-d', strtotime($data['birthdate'])) : null,
      'id' => $_SESSION['uuid']
    ]);
  }

  if (!$value) {
    echo json_encode(['message' => 'Failed to update user details'], JSON_PRETTY_PRINT);
    http_response_code(500);
    exit;
  } else {
    echo json_encode(['message' => 'User details updated'], JSON_PRETTY_PRINT);
    http_response_code(200);
    exit;
  }
} else {
  echo json_encode(['message' => 'Method not allowed'], JSON_PRETTY_PRINT);
  http_response_code(405);
  exit;
}
