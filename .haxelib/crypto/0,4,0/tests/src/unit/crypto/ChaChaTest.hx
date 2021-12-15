package unit.crypto;

import unit.Test;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.crypto.ChaCha;

class ChaChaTest extends Test
{
	var keys = [
		"00112233445566778899AABBCCDDEEFF",
		"00112233445566778899AABBCCDDEEFFFFEEDDCCBBAA99887766554433221100",
		"C46EC1B18CE8A878725A37E780DFB735"
	];

	var nonces = [
		"0F1E2D3C4B596877",
		"0F1E2D3C4B596877",
		"1ADA31D5CF688221"
	];

	var plainText = [
		"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
		"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	];

	var ciphers = [
		"F967649634E03569C6A79B7487B4D0DB59A9341E31E0F03900CA52479C3FFD083B4D58FAEDA6606DA8984C4C1B3097573308C5F4905C16B9E6B0586B4B3F0D25",
		"87FA92061043CA5E631FEDD88E8BFB84AD6B213BDEE4BC806E2764935FB89097218A897B7AEAD10E1B17F6802B2ABDD95594903083735613D6B3531B9E0D1B67",
		"826ABDD84460E2E9349F0EF4AF5B179B426E4B2D109A9C5BB44000AE51BEA90A496BEEEF62A76850FF3F0402C4DDC99F6DB07F151C1C0DFAC2E56565D6289625"
	];

	public function test_chacha():Void
	{
		trace("ChaCha for "+keys.length+" keys");
		var time = Timer.stamp();
		for(i in 0...keys.length)
		{
			var key = Bytes.ofHex(keys[i]);
			var nonce = Bytes.ofHex(nonces[i]);
			var text = Bytes.ofHex(plainText[i]);
			var chaCha = new ChaCha();
			chaCha.init(key,nonce);
			var enc = chaCha.encrypt(text);
			eq( enc.toHex().toUpperCase(), ciphers[i] );
			chaCha.reset();
			var decr = chaCha.decrypt(enc);
			eq( decr.toHex().toUpperCase(), plainText[i] );
			}
		time = Timer.stamp()-time;
		trace("Finished : "+time+" seconds");
	}
}