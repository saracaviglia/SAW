class Pagination {
  constructor(id_div) {
    this.itemsPerPage = 8;
    this.currentPage = new URLSearchParams(window.location.search).get('p') === null ?
      1
      :
      new URLSearchParams(window.location.search).get('p');
    this.div = id_div;
  }

  // Fetch items for the current page
  async loadItems() {
    
    if (await p.renderProductCards(this.div, this.currentPage) === -1) {
      this.previousPage();
    }

    document.getElementById("page-number").innerHTML = this.currentPage;
  }

  // Go to the next page
  nextPage() {
    // Get the current URL and its search parameters
    let url = new URL(window.location.href);
    let params = url.searchParams;
    params.set('p', ++this.currentPage);

    // Update the URL with the new search parameters using history.pushState()
    history.pushState({}, '', url.pathname + '?' + params.toString());

    window.scrollTo(0, 0);

    this.loadItems();
  }

  // Go to the previous page
  previousPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
    }
    // Get the current URL and its search parameters
    let url = new URL(window.location.href);
    let params = url.searchParams;
    params.set('p', this.currentPage);

    // Update the URL with the new search parameters using history.pushState()
    history.pushState({}, '', url.pathname + '?' + params.toString());

    window.scrollTo(0, 0);
    this.loadItems();
  }

  // Go to a specific page
  goToPage(page) {
    this.currentPage = page;
    return this.loadItems();
  }
}