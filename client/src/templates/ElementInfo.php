<?php $eid = $_GET['eid'] ?>

<main class="element-page">
  <script>
    window.onload = function() {
      const elem = new ProductAPI();
      elem.fillElemPage();
    }
  </script>
  <section class="elem" id=<?php echo $eid ?>>
    <!-- Immagini del prodotto | titolo, descrizione, prezzo, recensione | area per comprare/aggiungere al carello -->
    <div id="elem-images">
      <img src="" alt="" id="elem-image">
      <div class="elem-gallery"></div>
    </div>

    <div class="elem-info">
      <h1 id="elem-title"></h1>
      <div class="elem-mark">
        <div id="elem-rating"></div>
        <div id="rating-stars" class="rating-star rate">

          <span class="half" for="rating1" title="1/2 star"></span>
          <span for="rating2" title="1 star"></span>
          <span class="half" for="rating3" title="1 1/2 stars"></span>
          <span for="rating4" title="2 stars"></span>
          <span class="half" for="rating5" title="2 1/2 stars"></span>
          <span for="rating6" title="3 stars"></span>
          <span class="half" for="rating7" title="3 1/2 stars"></span>
          <span for="rating8" title="4 stars"></span>
          <span class="half" for="rating9" title="4 1/2 stars"></span>
          <span for="rating10" title="5 stars" class=""></span>

        </div>
      </div>
      <h4 id="elem-description"></h4>
    </div>

    <div class="box-outer">
      <span id="elem-price"></span>
      <p>Delivery without fees
        <?php
        $currentTimestamp = time();
        $targetTimestamp = mktime(21, 0, 0);
        $remainingSeconds = $targetTimestamp - $currentTimestamp;
        $remainingHours = floor($remainingSeconds / 3600);
        $remainingMinutes = floor(($remainingSeconds % 3600) / 60);

        if ($remainingHours > 0) {
          echo "<b>tomorrow</b>. Order before ";
          echo $remainingHours . " hours and " . $remainingMinutes . " min.";
        } else {
          echo "<b>the day afetr tomorrow</b>. order before ";
          echo -$remainingHours + 21 . " hours and " . -$remainingMinutes . " min.";
        }
        ?>

        <a href="">More informations</a>
      </p>
      <div>Send to Address</div>
      <h3>Immediate availability</h3>
      <div class="select-quantity">
        <button id="" onclick="c.decrement_value(this)">
          <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
            <path d="M200-440v-80h560v80H200Z" />
          </svg>
        </button>
        <p id=<?php echo "add-" . $eid ?> class="q-btn">Quantity: 1</p>
        <button onclick="c.increment_value(this)">
          <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
            <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
          </svg>
        </button>


      </div>

      <button onclick="c.addToCart(this)" class="add-to-cart">Add to cart</button>
    </div>
  </section>
  <section>
    <!-- Spesso comprati assieme -->
  </section>
  <section>
    <!-- Prodotti correlati a questo articolo -->
  </section>
  <section class="review">
    <!-- Recensioni -->

    <div class="review-form">
      <h2>Make a Review</h2>
      <form id="review-form" onsubmit="r.addReview(event)">
        <div class="title">
          <label for="review-title">Title</label>
          <input type="text" id="review-title" name="review-title" class="rev-title" required>
        </div>

        <!-- Star rating inputs -->

        <fieldset class="rate">
          <input type="radio" id="rating10" name="rating" value="10" class="star" /><label for="rating10" title="5 stars"></label>
          <input type="radio" id="rating9" name="rating" value="9" class="star" /><label class="half" for="rating9" title="4 1/2 stars"></label>
          <input type="radio" id="rating8" name="rating" value="8" class="star" /><label for="rating8" title="4 stars"></label>
          <input type="radio" id="rating7" name="rating" value="7" class="star" /><label class="half" for="rating7" title="3 1/2 stars"></label>
          <input type="radio" id="rating6" name="rating" value="6" class="star" /><label for="rating6" title="3 stars"></label>
          <input type="radio" id="rating5" name="rating" value="5" class="star" /><label class="half" for="rating5" title="2 1/2 stars"></label>
          <input type="radio" id="rating4" name="rating" value="4" class="star" /><label for="rating4" title="2 stars"></label>
          <input type="radio" id="rating3" name="rating" value="3" class="star" /><label class="half" for="rating3" title="1 1/2 stars"></label>
          <input type="radio" id="rating2" name="rating" value="2" class="star" /><label for="rating2" title="1 star"></label>
          <input type="radio" id="rating1" name="rating" value="1" class="star" /><label class="half" for="rating1" title="1/2 star"></label>
        </fieldset>
        <span id="star-err" class="invalid"></span>

        <div class="rev-box">
          <textarea id="review-text" class="review" cols="30" rows="5" name="review" placeholder="Brief Review"></textarea>
        </div>

        <span id="err-review" class="invalid"></span>

        <button type="submit" class="btn loader" id="post-rev-btn">Submit</button>
      </form>
    </div>


    <div class="review-list">
      <h2>Reviews</h2>
      <div id="reviews"></div>
    </div>

  </section>
</main>