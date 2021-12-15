package asys.io;

#if nodejs
import js.node.Fs;
import js.node.fs.Stats;
import #if haxe4 js.lib.Error #else js.Error #end as JsError;
#end
import asys.io.FileInput;
import asys.io.FileOutput;
import tink.io.Sink;

using tink.io.Source;
using tink.CoreApi;

@:access(sys.io.FileInput)
@:access(sys.io.FileOutput)
class File {

	public static function readStream(path: String, binary = true): RealSource {
		#if nodejs
		return Source.ofNodeStream('asys read stream', Fs.createReadStream(path));
		#else
		return Source.ofInput('asys read stream', sys.io.File.read(path));
		#end
	}

	public static function writeStream(path : String, binary: Bool = true): RealSink {
		#if nodejs
		return Sink.ofNodeStream('asys write stream', Fs.createWriteStream(path));
		#else
		return Sink.ofOutput('asys write stream', sys.io.File.write(path));
		#end
	}
	
	#if nodejs

	public static function getContent(path: String): Promise<String> {
		var trigger = Future.trigger();
		Fs.readFile(path, 'utf8', function(err: JsError, data: String)
			trigger.trigger(switch err {
				case null: Success(data);
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function saveContent(path: String, content: String): Promise<Noise> {
		var trigger = Future.trigger();
		Fs.writeFile(path, untyped content, 'utf8', function(err: JsError)
			trigger.trigger(switch err {
				case null: Success(Noise);
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function getBytes(path: String): Promise<haxe.io.Bytes> {
		var trigger = Future.trigger();
		Fs.readFile(path, function(err: JsError, buffer: js.node.Buffer)
			trigger.trigger(switch err {
				case null: Success(buffer.hxToBytes());
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function saveBytes(path: String, bytes: haxe.io.Bytes): Promise<Noise> {
		var trigger = Future.trigger();
		Fs.writeFile(path, js.node.Buffer.hxFromBytes(bytes), function(err: JsError)
			trigger.trigger(switch err {
				case null: Success(Noise);
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function read(path: String, binary = true): Promise<FileInput> {
		var trigger = Future.trigger();
		Fs.open(path, 'r', function(err: JsError, fd: Int)
			trigger.trigger(switch err {
				case null: Success(new FileInput(fd));
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function write(path : String, binary: Bool = true): Promise<FileOutput> {
		var trigger = Future.trigger();
		Fs.open(path, 'w', function(err: JsError, fd: Int)
			trigger.trigger(switch err {
				case null: Success(new FileOutput(fd));
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function append(path : String, binary : Bool = true): Promise<FileOutput> {
		var trigger = Future.trigger();
		Fs.open(path, 'a', function(err: JsError, fd: Int)
			trigger.trigger(switch err {
				case null: Success(new FileOutput(fd));
				default: Failure(Error.withData(err.message, err));
			})
		);
		return trigger.asFuture();
	}

	public static function copy(srcPath: String, dstPath: String): Promise<Noise> {
		var trigger = Future.trigger();
		var called = false;
		function done(?err: JsError) {
			if (called) return;
			trigger.trigger(switch err {
				case null: Success(Noise);
				default: Failure(Error.withData(err.message, err));
			});
			called = true;
		}
		var rd = Fs.createReadStream(srcPath);
		rd.on('error', done);
		var wr = Fs.createWriteStream(dstPath);
		wr.on('error', done);
		wr.on('close', function(ex) {
			done();
		});
		rd.pipe(wr);

		return trigger.asFuture();
	}
	
	#elseif (tink_runloop && concurrent)
	
	public static function getContent(path: String): Promise<String>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try Success(sys.io.File.getContent(path))
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function saveContent(path: String, content: String): Promise<Noise>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try {
					sys.io.File.saveContent(path, content);
					Success(Noise);
				}
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function getBytes(path: String): Promise<haxe.io.Bytes>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try Success(sys.io.File.getBytes(path))
				catch(e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function saveBytes(path: String, bytes: haxe.io.Bytes): Promise<Noise>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try {
					sys.io.File.saveBytes(path, bytes);
					Success(Noise);
				}
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function read(path: String, binary = true): Promise<FileInput>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try Success(sys.io.File.read(path, binary))
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function write(path : String, binary: Bool = true): Promise<FileOutput>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try Success(sys.io.File.write(path, binary))
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function append(path : String, binary : Bool = true): Promise<FileOutput>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try Success(sys.io.File.append(path, binary))
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);

	public static function copy(srcPath: String, dstPath: String): Promise<Noise>
		return Future.async(function(done)
			tink.RunLoop.current.work(function () done(
				try {
					sys.io.File.copy(srcPath, dstPath);
					Success(Noise);
				}
				catch (e: Dynamic) Failure(new Error('$e'))
			))
		);
	
	#else
	
	public static function getContent(path: String): Promise<String>
		return Future.sync(
			try Success(sys.io.File.getContent(path))
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function saveContent(path: String, content: String): Promise<Noise>
		return Future.sync(
			try {
				sys.io.File.saveContent(path, content);
				Success(Noise);
			}
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function getBytes(path: String): Promise<haxe.io.Bytes>
		return Future.sync(
			try Success(sys.io.File.getBytes(path))
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function saveBytes(path: String, bytes: haxe.io.Bytes): Promise<Noise>
		return Future.sync(
			try {
				sys.io.File.saveBytes(path, bytes);
				Success(Noise);
			}
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function read(path: String, binary = true): Promise<FileInput>
		return Future.sync(
			try Success(sys.io.File.read(path, binary))
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function write(path : String, binary: Bool = true): Promise<FileOutput>
		return Future.sync(
			try Success(sys.io.File.write(path, binary))
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function append(path : String, binary : Bool = true): Promise<FileOutput>
		return Future.sync(
			try Success(sys.io.File.append(path, binary))
			catch(e: Dynamic) Failure(new Error('$e'))
		);

	public static function copy(srcPath: String, dstPath: String): Promise<Noise>
		return Future.sync(
			try {
				sys.io.File.copy(srcPath, dstPath);
				Success(Noise);
			}
			catch(e: Dynamic) Failure(new Error('$e'))
		);
	
	#end
}