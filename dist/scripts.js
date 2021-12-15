const app = (() => {

    const productContainer = document.getElementById("products");
    // const productPagination = document.getElementById("products-pagination");

    const urlSearchParams = new URLSearchParams(window.location.search);
    const params = Object.fromEntries(urlSearchParams.entries());

    const renderProducts = (products) => {
        axios.get(`/products/list?page=${params.page}`)
            .then(res => {
                if (res.headers["content-type"] === "text/html") {

                    productContainer.insertAdjacentHTML('beforeend', res.data);
                    Array.prototype.slice.call(productContainer.querySelectorAll('script')).forEach(scriptTag => eval(scriptTag.innerHTML));
                } else {
                    alert(`Oops! Somnething went wrong! Please contact the site admin! (invalid content type '${res.headers["content-type"]} returned)`);
                }
            })
            .catch(err => {
                console.log({ err });
                alert('Oops! Something went wrong! Please contact the site admin!');
            });
    }



    const init = () => {
        renderProducts();
    }

    init();

})();