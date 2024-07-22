<main class="page">
  <aside class="products-filter"></aside>
  <section class="elem-section">
    <span id="loader-searched-elem" class="loader"></span>
    <div id="searched-elem" class="show-row-4">
      <script>
        let params = new URLSearchParams(window.location.search);
        const page = new Pagination('searched-elem');
        page.loadItems();
      </script>
    </div>
    <?php
      display("Pagination");
    ?>
  </section>

</main>