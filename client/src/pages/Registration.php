<?php


display('Head', false, [
  'title' => 'SAW: Registration',
  'css' => ['generic', 'navbar', 'forms', 'footer'],
  'js' => ['config', 'Loaders', 'Product', 'registration']
]);
display('Navbar');
if (!isset($_COOKIE["email"])) : ?>
  <main>
    <div class="form">
      <h1>SAW: Sign up</h1><br>
      <p>Already have an account? <a class="linkform" href="login">Login now!</a></p><br>
      <!-- action="Registration.php" method="post" -->
      <form id="registration" class="registration" action="">
        <fieldset>
          <label for="firstname">First name*</label>
          <input id="firstname" type="text" name="firstname" placeholder="First name">
          <br><span id="err-firstname" class="error">Firstname not valid</span><br>

          <label for="lastname">Last name*</label>
          <input id="lastname" type="text" name="lastname" placeholder="Last name">
          <br><span id="err-lastname" class="error">Lastname not valid</span><br>

          <label for="email">Email*</label>
          <input id="email" type="email" name="email" placeholder="Email">
          <br><span id="err-email" class="error">Username not valid or available</span><br>

          <label for="pass">Password*</label>
          <input id="password" type="password" name="pass" placeholder="Password">
          <br><span id="err-password" class="error">Password not valid</span><br>

          <label for="confirm">Confirm password*</label>
          <input id="confirm" type="password" name="confirm" placeholder="Confirm password">
          <br><span id="err-confirm" class="error">Confirm password not valid</span><br>

          <div class="password-info">Password must be at least 8 characters long and can only contain the following characters: 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@&%$*#</div><br>
          <p class="required">* = Required fields</p>
          <div id="errors" class="errors"></div>
          <input type="submit" name="submit" value="Sign up">
        </fieldset>
      </form>
    </div>
  <?php else :
  //header("Location: Home.php");

endif;
  ?>
  </main>

  <?php
  display('Footer');
