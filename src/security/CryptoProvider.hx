package security;
import haxe.crypto.Sha256;
using StringTools;
import haxe.io.Bytes;
import haxe.crypto.ChaCha;

class CryptoProvider {
	static function mkChaCha(key:String, nonce:String)
		return {
            var key = Sha256.make(Bytes.ofString(key));
            nonce = nonce.substr(0, 16);
            trace(nonce.length);
            var nonce = Bytes.ofHex(nonce);
			var chaCha = new ChaCha();
			chaCha.init(key, nonce);
			chaCha;
		}

    public static function getNonce() return Std.string(Std.random(100000000)).lpad('0',8);
	public static function encrypt(data:Bytes, key:String, nonce:String)
		return mkChaCha(key, nonce).encrypt(data);

	public static function decrypt(data:Bytes, key:String, nonce:String)
		return mkChaCha(key, nonce).decrypt(data);
}
