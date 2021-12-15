import haxe.crypto.Base64;
import haxe.io.Bytes;
import security.CryptoProvider.encrypt;
import security.CryptoProvider.decrypt;
import security.CryptoProvider.getNonce;
class CryptoTool {
    public static function main() {
        var args = Sys.args();
        var mode:Mode = args[0];
        var data = args[1];
        var key = args[2];
        var nonce = if(args.length > 3) args[3] else getNonce();
        trace(mode);
        var output = switch mode {
            case Encrypt: 
                Base64.encode(encrypt(Bytes.ofString(data), key, nonce));
            case Decrypt: 
                var data = Base64.decode(data);
                trace(data);
                decrypt(data, key, nonce).toString();
            default: throw 'invalid command';
        }
        
        trace('Output: $output, nonce: $nonce');
    }
}

enum abstract Mode(String) from String to String {
    var Encrypt = 'encrypt';
    var Decrypt = 'decrypt';
}