<main class="cart-page">

  <div id="cart-list" class="cart-list">
    <span id="loader-cart-list" class="loader"></span>
    <script>
      c.renderCart("cart-list");
    </script>
  </div>

  <div class="total-price">
    <p id="cart-list-total"></p>
    <button id="btn-checkout" onclick="c.redirectToCheckOut(this)" class="btn">Checkout</button>
  </div>

  <!-- <div id="cart-checkout"></div> -->

</main>