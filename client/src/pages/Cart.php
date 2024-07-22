<?php


/* if (!isLogged()) {
  header('Location: login.php');
  exit;
} */

display('Head', false, [
  'title' => 'Shopping Cart',
  'css' => ['generic', 'navbar', 'cart', 'footer'],
  'js' => ['config', 'Loaders', 'cart', 'Product']
]);

display('Navbar');
display('CartList', true);
display('Footer');
