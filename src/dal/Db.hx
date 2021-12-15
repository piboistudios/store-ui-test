package dal;

import dal.models.Product;
import security.CryptoProvider;
import sys.io.File;
import haxe.io.Bytes;

typedef Db<T> = {
	collections:Array<Collection<T>>,
}

typedef Collection<T> = {
	var name:String;
	var _data:Array<T>;
}

abstract ProductDatabase(Db<Product>) from Db<Product> to Db<Product> {
	function new(file) {
		this = tink.Json.parse(File.getContent(file));
	}

	public function collection(collectionName)
		return {
			var matchedCollection = this.collections.find(c -> c.name == collectionName);
			if (matchedCollection != null)
				matchedCollection._data;
			else
				null;
		};

	public static function connect(cnxStr:ConnectionString):Promise<ProductDatabase> {
		return {
			authenticate(cnxStr["uid"], cnxStr["pwd"]);
			new ProductDatabase(cnxStr["server"]);
		}
	}

	static function authenticate(username, password) {
		if (username != "gabe4haxelang")
			throw 'user not found';
        trace(Server.KEY);
        trace(Server.NONCE);
		var decrypted = CryptoProvider.decrypt(Server.SECRET, Server.KEY, Server.NONCE).toString();
        trace(decrypted);
        trace(password);
		if (decrypted != password)
			throw 'password invalid';
	}
}

abstract ConnectionString(String) from String to String {
	public var props(get, never):Map<String, String>;

	public function get_props() {
		var kvpList:Array<Pair<String, String>> = this.split(';').map(section -> section.split('=')).map(pair -> new Pair(pair[0], pair[1]));
		var map:Map<String, String> = [];
		for (kvp in kvpList) {
			map.set(kvp.a, kvp.b);
		}
		return map;
	}

	@:op([]) public function mapAccess(key:String)
		return props[key];
}
