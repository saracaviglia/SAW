<main class="homepage">
  <section id="">
    <div class="last-added">
      <h3 class="">Last Added</h3>
      <span id="last-added-row" class="elems-seq">
        <span id="loader-last-added-row" class="loader"></span>
        <script>
          const lap = new ProductAPI(10, "last_added");
          lap.renderProductCards("last-added-row");
        </script>
      </span>
    </div>

  </section>

  <!-- 
    //? 1. Most sold
    //? 2. Last Added
    //? 3. From your wish list
    //? 4. Aggiungere controllo su elementi che visuallizza solo, ma che non ha nel carrello o nella lista dei desideri
   -->


</main>