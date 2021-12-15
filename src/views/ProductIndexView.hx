package views;

class ProductIndexView {
	public var page:Int;
	public var pageStart:Int;
	public var pageEnd:Int;
	public var numPages:Int;

	public function new(?data:{
		?page:Int,
		?pageStart:Int,
		?pageEnd:Int,
		?numPages:Int
	}) {
		if (data != null) {
			this.page = data.page;
			this.pageStart = data.pageStart;
			this.pageEnd = data.pageEnd;
			this.numPages = data.numPages;
		}
	}

	@:template("ProductIndexView.gabrihtml") public function render();
}
