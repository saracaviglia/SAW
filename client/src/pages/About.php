<?php

display('Head', false, [
  'title' => 'SAW: Login',
  'css' => ['generic', 'navbar', 'about', 'footer'],
  'js' => ['config', 'Loaders', 'cart']
]);
display('Navbar');
?>
<main>
    <div class="container">
        <h1>About SAW</h1>
        <div class="text">
            <p class="about">Hello! SAW is an e-commerce for your extra-terrastrial travels! 
                It is only a startup, founded by Sara Caviglia and Matteo Fazzeri:
                they are two students from the University of Genoa, Italy. This is a
                project for the course of Web Applications, held by Prof. Ribaudo.
                The concept is based on the mutual interest for the Star Wars Universe,
                one of the main topics that led them to become friends. 
                Thank you for choosing StartSaw! May the Force be with you!
            </p>
        </div>
    </div>
</main>

<?php
display('Footer');