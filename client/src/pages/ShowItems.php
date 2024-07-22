<?php


display('Head', false, [
    'title' => 'Item Searched',
    'css' => ['generic', 'productCard', 'searchpage', 'navbar', 'footer'],
    'js' => ['Product', 'pagination', 'config', 'Loaders', 'cart']
]);
display('Navbar');
display('SearchPage', true);
display('Footer');
