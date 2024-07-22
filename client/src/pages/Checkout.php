<?php

/* 
if (!isLogged()) {
  header('Location: login.php');
  exit;
} */

display('Head', false, [
    'title' => 'Checkout',
    'css' => ['generic', 'navbar', 'cart', 'footer'],
    'js' => ['config', 'Loaders', 'cart', 'Product']
]);

display('Navbar');
display('Checkout', true);
display('Footer');
