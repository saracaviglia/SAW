<main class="checkout-page">

  <div id="checkout" class="checkout">
    <span id="loader-checkout" class="checkout loader"></span>

  </div>
  <script>
    const C = new Checkout();
    C.renderCheckout("checkout");
  </script>

  <div class="total-price">
    <p id="checkout-total"></p>
    <button onclick="C.completeCheckout()" class="btn checkout-btn">
      <p>Complete Purchase</p>
    </button>
  </div>

  <!-- <div id="cart-checkout"></div> -->


</main>