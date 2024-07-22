<?php


display(
  'Head',
  false,
  [
    'title' => 'Home',
    'css' => ['generic', 'navbar', 'homepage', 'productCard', 'footer', 'cart'],
    'js' => ['Product', 'config', 'Loaders', 'cart']
  ]
);

display('Navbar');
display('Homepage', true);
display('Footer');
