<?php
$serverName = "localhost";
$dbName = "sawproject";

$db = "mysql:host=$serverName;dbname=$dbName";
$userName = "root";
$password = "";

try {
    $pdo = new PDO($db, $userName, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}