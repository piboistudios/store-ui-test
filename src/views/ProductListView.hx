package views;

class ProductListView {
	public var products:Array<Product>;

	public function new(products) {
		this.products = products;
	}

	@:template("ProductListView.gabrihtml") public function render();
}
