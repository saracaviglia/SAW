<?php


display('Head', false, [
  'title' => '404',
  'css' => ['generic', 'navbar', 'cart', 'footer'],
  'js' => ['config', 'Loaders', 'cart', 'Product']
]);

display('Navbar');
display('Error404', true);
display('Footer');
