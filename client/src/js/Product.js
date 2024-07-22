class ProductAPI {
  constructor(numItems = 8, toRender = ""
  ) {
    this.currentPage = 1;
    this.numItems = numItems;
    this.searchElem = new URLSearchParams(window.location.search).get('k') === null ?
      ""
      :
      new URLSearchParams(window.location.search).get('k');

    this.toRender = toRender; // toRender is used to render the product cards in the homepage
  }

  async renderProductCards(id_div, currentPage) {
    this.currentPage = currentPage;
    loaders.show("loader-" + id_div, 'search');

    document.getElementById(id_div).style.display = "none";

    const timeout = new Promise((resolve, reject) => {
      setTimeout(reject, 10000, 'Request timed out');
    });

    let data;

    try {
      data = await Promise.race([this.downloadProduct(), timeout]);
    } catch (error) {
      console.error(error);
      loaders.hide("loader-" + id_div);
      document.getElementById(id_div).innerHTML = `<h1>${error}</h1>`;
      document.getElementById(id_div).style.display = "flex";
      return;
    }

    if (Array.isArray(data) && data.length === 0) {
      loaders.hide("loader-" + id_div);
      document.getElementById(id_div).innerHTML = "<h1>No products found</h1>";
      document.getElementById(id_div).style.display = "flex";
    } else if (data === -1) {
      loaders.hide("loader-" + id_div);
      return -1;
    } else {
      var productHTML = data
        .map(function (product) {

          console.log(product.product_images);

          return `
            <div class="product-card elem" id="${product.product_id}">
              <div class="image">
                <img src="././client/public/img/${product.product_images}" alt="${product.product_name}" class="product-image">
              </div>
              <div class="details">
                  <h1 class="product-title"><a href="${product.product_id}/${product.product_name.replace(/ /g, "-")}?eid=${product.product_id}">${product.product_name}</a></h1>
                  <div class="product-rating">Rating: ${product.product_rating === null ? "no rating" : Math.floor((product.product_rating / 2) * 10) / 10}</div>
                  <span class="edit-quantity-elem" >
                    <button onclick="c.decrement_value(this)">
                      <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
                        <path d="M200-440v-80h560v80H200Z" />
                      </svg>
                    </button>
                    <p id="add-${product.product_id}" >Quantity: ${product.quantity}</p>
                    <button onclick="c.increment_value(this)">
                      <svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#5f6368">
                        <path d="M440-440H200v-80h240v-240h80v240h240v80H520v240h-80v-240Z" />
                      </svg>
                    </button>
                    <button id="${product.product_id}saveNQ" class="saveNQ" onclick="c.addToCart(this)" >OK</button>

                    ${product.product_quantity <= 0 ? "<p style='color: red'> no product</p>" : product.product_quantity < 10 ?
              `<p style='color: orange'>Remaining products: ${product.product_quantity}</p>` : ""
            } 
                  </span>
                  <p class="error" id="${product.product_id}-error"></p>
                  <div class="product-tags">Tags: ${product.tag_names}</div>
                  <p class="latest-comment">Latest Comment: ${product.latest_comment !== null ? product.latest_comment : "No comment available for this product"}</p>
              </div>
            </div>
        `;
        })
        .join("");

      loaders.hide("loader-" + id_div);
      document.getElementById(id_div).innerHTML = productHTML;
      document.getElementById(id_div).style.display = "flex";
    }
  }

  // Download product JSON
  async downloadProduct() {

    let response = null;

    if (this.toRender === "") {

       response = await fetch(
        `${backendUrl.development}s?k=${this.searchElem}&page=${this.currentPage}&nElem=${this.numItems}&uuid=${sessionStorage.getItem("email") || null}&x=${this.toRender || null}`,
        {
          method: "GET",
        }
      );
    } else {
      response = await fetch(
        `${backendUrl.development}h?x=${this.toRender || null}`,
        {
          method: "GET",
        }
      );
    }

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    } else {
      if (response.status === 204 && this.currentPage !== 1) {
        return -1;
      } else if (response.status === 204 && this.currentPage === 1) {
        return [];
      }
      else
        return await response.json();
    }
  }

  // Edit product JSON
  async editProduct(productId, updatedProduct) {
    const response = await fetch(`${this.baseURL}/products/${productId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(updatedProduct),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    } else {
      return await response.json();
    }
  }

  async fillElemPage() {

    const url = new URL(window.location.href);
    const eid = url.pathname.split('/')[2];
    const name = url.pathname.split('/')[3].replace(/-/g, " ");
    const response = await fetch(`${backendUrl.development}e?eid=${eid}&en=${name}`, {
      method: "GET",
    });

    if (!response.ok) {
      if (response.status === 404) {
        console.log("first");
        window.location.href = "notfound";
      }
    } else {
      const data = (await response.json())[0];
      document.title = data['product_name'];
      document.getElementById("elem-image").alt = data['product_name'];
      document.getElementById("elem-price").innerHTML = data['product_price'] + "$";
      document.getElementById("elem-title").innerHTML = data['product_name'];
      document.getElementById("elem-description").innerHTML = data['product_description'];
      document.getElementById("add-" + data['product_id']).innerHTML = "Quantity: " + data['quantity'];
      document.getElementById("elem-rating").innerHTML = "" + data['product_rating'] === null ? "no rating" : Math.floor((data['product_rating'] / 2) * 10) / 10;


      const productRating = data['product_rating'] / 2;
      const ratingContainer = document.getElementById('rating-stars');
      const stars = ratingContainer.querySelectorAll('span');
      const fullStars = Math.floor(productRating);
      const halfStars = productRating % 1 !== 0 ? 1 : 0;

      // Add 'rev-star-on' class to full stars
      for (let i = 0; i < fullStars * 2; i++) {
        stars[i].classList.add('rev-star-on');
      }

      // Add 'rev-star-on' class to half star if applicable
      if (halfStars) {
        stars[fullStars * 2].classList.add('rev-star-on');
      }



      // console.log(data['product_rating'] === null ? "no rating" : Math.floor((data['product_rating'] / 2) * 10) / 10);

      // render images of the product in the carousel
    }
  }
}

class searchProduct extends ProductAPI {
  constructor() {
    super();
  }

  changeSearch = (e) => {
    const search_input = document.querySelector("input").value;
  }

  search = () => {
    const search_input = encodeURIComponent(document.querySelector("input").value);

    search_input === "" ?
      null : window.location.href = `search?k=${search_input}`;
  }
}

const p = new ProductAPI();