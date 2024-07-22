<?php

require __DIR__ . "/../libs/functions.php";

/* if(!isAdmin()) {
  header("Location: " . BASE_URL . "/");
  exit();
} */



switch (ROUTING_URL) {
  case '/admin':
    require __DIR__ . "/../templates/admin/Dashboard.php";
    break;
  case '/admin/':
    echo "default";
    break;
  case '/admin/tables':
    echo "monitor";
    break;
  default:
    header("Location: " . BASE_URL . "/notfound");
    break;
}

display('Footer');