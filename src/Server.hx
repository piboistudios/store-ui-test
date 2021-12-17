import tink.core.Error;
import mime.Mime;
import haxe.crypto.Base64;

using haxe.io.Path;
using StringTools;

import tink.http.containers.*;
import views.*;
import tink.http.Response;
import tink.web.routing.*;
import dal.Db;
import haxe.io.Bytes;

class Server {
	public static var SECRET(default, null):Bytes;
	public static var NONCE(default, null):String;
	public static var KEY(default, null):String;

	static function main() {
		{
			NONCE = sys.io.File.getContent('./secrets/nonce');
			KEY = sys.io.File.getContent('./secrets/privKey');
			SECRET = Base64.decode(sys.io.File.getContent('./secrets/dbPass'));
			AppConfig.init();
		}
		var container = new NodeContainer(Sys.args()[0]);
		trace(AppConfig.data.connectionStrings.keys());
		ProductDatabase.connect(AppConfig.data.connectionStrings["product"])
			.next(db -> {
				var router = new Router<ProductsRouterBase>(new ProductsRouterBase(db));
				container.run(function(req) {
					return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
				}).eager();
			})
			.tryRecover(e -> {
				trace('Error connecting to database: $e');
				e;
			})
			.eager();
	}
}

class ProductsRouterBase {
	var db:dal.Db.ProductDatabase;

	public function new(db) {
		this.db = db;
	}
    @:get('/')
    public function index() return get_content("index.html");
	@:get('/test')
	public function test_template() {
		var test = new TestView('Gabriel');
		test.friends = ['Chris', 'Shawn', 'Dalvin', 'Alejandro'];
		return test.renderTest();
	}
    @:sub('/views')
	public function crappy_server_pages_sub()
		return new CrappyServerPagesRouter(db);

	@:sub('/api')
	public function beautiful_rest_api()
		return new BeautifulRestApi(db);
    
	@:get('/$content')
	public function get_content(content:String) {
		var path = './dist/${content.urlEncode()}';
		if (!sys.FileSystem.exists(path))
			return tink.web.routing.Response.textual(NotFound, "text/plain", "Not Found");
		var fileStream = asys.io.File.readStream(path);
		var mimeType = Mime.lookup(content);
		return tink.web.routing.Response.ofRealSource(fileStream, mimeType);
	}

	
}

class BeautifulRestApi extends ProductsRouterBase {
    @:get('/products')
    @:params(skip in query)
    @:params(limit in query)
    public function getProducts(skip, limit) {
        return db.collection('products').slice(skip, skip+limit);
    }
}

class CrappyServerPagesRouter extends ProductsRouterBase {
	var numPages(get, never):Int;

	static var PRODUCTS_PER_PAGE = 20;

	function get_numPages() {
		return Math.ceil(db.collection('products').length / PRODUCTS_PER_PAGE);
	}

	var pageStart(get, never):Int;

	function get_pageStart()
		return 1;

	var pageEnd(get, never):Int;

	function get_pageEnd()
		return 5;

	@:get('/products')
	@:params(page in query)
	public function products_view(page:Int) {
		var productIndex = new ProductIndexView({
			page: page,
			pageStart: pageStart,
			pageEnd: pageEnd,
			numPages: numPages
		});

		return productIndex.render();
	}

	@:get('/products/list')
	@:params(page in query)
	public function products_list_view(page:Int) {
		var productDataSource = db.collection('products').slice((page - 1) * PRODUCTS_PER_PAGE, page * PRODUCTS_PER_PAGE);
		var productsListView = new ProductListView(productDataSource);
		return productsListView.render();
	}
}
