<?php
function getElem($query_code, $data = [])
{
  require __DIR__ . '/connect.inc.php';
  $result = [];
  try {
    $query = $query_code;
    $stmt = $pdo->prepare($query);

    foreach ($data as $key => &$value)
      $stmt->bindParam(':' . $key, $value);

    $stmt->execute();

    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $pdo = null;
    $stmt = null;

    return $result;
  } catch (PDOException $e) {
    echo ("Query failed: " . $e->getMessage() . '<br/>' . $query_code);
    return false;
  }
}

function insertValue($query_code, $data = [], $needIndex = false)
{
  require __DIR__ . '/connect.inc.php';

  try {
    $query = $query_code;
    $stmt = $pdo->prepare($query);

    foreach ($data as $key => &$value)
      $stmt->bindParam(':' . $key, $value);
    $stmt->execute();

    if ($needIndex)
      $lastIndex = $pdo->lastInsertId();

    $pdo = null;
    $stmt = null;

    return $needIndex === false ? true : $lastIndex;
  } catch (PDOException $e) {
    echo ("Query failed: " . $e->getMessage() . '<br/>' . $query_code);
    return false;
  }
}

