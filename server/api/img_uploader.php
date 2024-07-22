<?php

// Your insertValue function
function insertValue($query_code, $data = [], $needIndex = false)
{
  $serverName = "127.0.0.1"; // Changed to 127.0.0.1
  $dbName = "sawproject";

  $db = "mysql:host=$serverName;dbname=$dbName";
  $userName = "root";
  $password = "";

  try {
    $pdo = new PDO($db, $userName, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  } catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    return false;
  }

  try {
    $stmt = $pdo->prepare($query_code);

    foreach ($data as $key => &$value) {
      if ($key === 'image') {
        // Bind the image data as a blob
        $stmt->bindParam(':' . $key, $value, PDO::PARAM_LOB);
      } else {
        $stmt->bindParam(':' . $key, $value);
      }
    }

    $stmt->execute();

    if ($needIndex) {
      $lastIndex = $pdo->lastInsertId();
    }

    $pdo = null;
    $stmt = null;

    return $needIndex === false ? true : $lastIndex;
  } catch (PDOException $e) {
    echo ("Query failed: " . $e->getMessage() . '<br/>' . $query_code);
    return false;
  }
}

// Read the image file and convert it to binary data
$imagePath = 'img/falcon.jpeg';
$imageData = file_get_contents($imagePath);

if ($imageData === false) {
  die('Failed to read image file.');
}

// Insert the binary data into the database
$query = "INSERT INTO photos (image, product_id) VALUES (:image, :pid)";
$params = [
  'image' => $imageData,
  'pid' => 1  // Assuming the product ID is 1, change it as necessary
];

$result = insertValue($query, $params);

if ($result) {
  echo 'Image inserted successfully.';
} else {
  echo 'Failed to insert image.';
}
