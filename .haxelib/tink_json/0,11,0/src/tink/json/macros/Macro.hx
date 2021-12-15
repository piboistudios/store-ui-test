package tink.json.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.ds.Option;
import tink.macro.BuildCache;

import tink.typecrawler.*;

using haxe.macro.Tools;
using StringTools;
using tink.MacroApi;

class Macro {

  static function compact(?prefix:String = '', ?fields:Array<Field>) {
    #if tink_json_compact_code
    if (fields == null)
      fields = Context.getBuildFields();
    for (i in 0...fields.length) {
      var f = fields[i];

      if(f.name == 'new') continue;

      var meta = {
        name: ':native',
        params: [macro $v{prefix + i.shortIdent()}],
        pos: f.pos,
      }
      switch f.meta {
        case null: f.meta = [meta];
        case v: v.push(meta);
      }
    }
    return fields;
    #else
    return null;
    #end
  }

  static public function nativeName(f:FieldInfo)
    return
      switch f.meta.filter(function (m) return m.name == ':json') {
        case []: f.name;
        case [{ params: [name] }]: name.getName().sure();
        case [v]: v.pos.error('@:json must have exactly one parameter');
        case v: v[1].pos.error('duplicate @:json metadata not allowed on a single field');
      }

  static function getType(name)
    return
      switch Context.getLocalType() {
        case TInst(_.toString() == name => true, [v]):
          v;
        default:
          throw 'assert';
      }

  static public function buildParser(?type, ?pos):Type
    return BuildCache.getType('tink.json.Parser', type, pos, parser, normalize);

  static public function nameNiladic(c:EnumField)
    return
      switch c.meta.extract(':json') {
        case []: c.name;
        case [{ params:[{ expr: EConst(CString(v)) }]}]: v;
        case v: c.pos.error('invalid use of @:json');
      }


  static function parser(ctx:BuildContext):TypeDefinition {
    var name = ctx.name,
        ct = ctx.type.toComplex();

    var cl = macro class $name extends tink.json.Parser.BasicParser {
      public function new() super();
    }

    function add(t:TypeDefinition)
      cl.fields = cl.fields.concat(t.fields);

    var ret = Crawler.crawl(ctx.type, ctx.pos, GenReader.new);

    cl.fields = cl.fields.concat(ret.fields);

    var catcher = macro tink.core.Error.catchExceptions;

    if (Context.defined('cs')) // https://github.com/HaxeFoundation/haxe/issues/9351
      catcher = macro ($catcher:(Void->$ct)->?Dynamic->?Dynamic->tink.core.Outcome<$ct, tink.core.Error>);

    add(macro class {
      public function parse(source):$ct @:pos(ret.expr.pos) {
        inline function clear()
          if (afterParsing.length > 0)
            afterParsing = [];// TODO: use resize and what not
        clear();
        this.init(source);
        var ret = ${ret.expr};
        for (f in afterParsing)
          f();
        clear();
        return ret;
      }
      public function tryParse(source)
        return $catcher(function ():$ct {
          var ret = parse(source);
          skipIgnored();
          if (pos < max)
            die('Invalid data after JSON document');
          return ret;
        });

    });

    compact('p', cl.fields);
    return cl;
  }

  static function normalize(t:Type):Type
    return switch t {
      case TAbstract(_.get() => { name: 'Null', pack: [] }, [t])
        #if !haxe4 | TType(_.get() => { name: 'Null', pack: []}, [t]) #end
        :
        var ct = normalize(t).toComplex({ direct: true });
        (macro : Null<$ct>).toType().sure();

      case TLazy(f): normalize(f());
      case TType(_.get() => { module: 'tink.json.Cached' }, [t]):

        var ct = normalize(t).toComplex({ direct: true });
        (macro : tink.json.Cached<$ct>).toType().sure();

      case TType(_, _): normalize(Context.follow(t, true));
      default: t;
    }

  static public function buildWriter(?type, ?pos):Type
    return BuildCache.getType('tink.json.Writer', type, pos, writer, normalize);

  static function writer(ctx:BuildContext):TypeDefinition {
    var name = ctx.name,
        ct = ctx.type.toComplex();

    var cl = macro class $name extends tink.json.Writer.BasicWriter {
      public function new() super();
    }

    var ret = Crawler.crawl(ctx.type, ctx.pos, GenWriter.new);

    cl.fields = cl.fields.concat(ret.fields);

    function add(t:TypeDefinition)
      cl.fields = cl.fields.concat(t.fields);

    add(macro class {
      public function write(value:$ct):tink.json.Serialized<$ct> {
        this.init();
        ${ret.expr};
        return cast this.buf.toString();
      }
    });
    compact('w', cl.fields);
    // trace(ComplexType.TAnonymous(cl.fields).toString());
    return cl;
  }

  static public function getRepresentation(t:Type, pos:Position) {

    switch t.reduce() {
      case TDynamic(null) | TMono(_) | TAbstract(_.get() => {name: 'Any', pack: []}, _): return None;
      default:
    }

    var ct = t.toComplex({ direct: true });

    return
      if (Context.unify(t, Context.getType('tink.json.Representation'))) {

        var rep = (macro tink.json.Representation.of((null : $ct)).get()).typeof().sure();
        var rt = rep.toComplex();

        if (!(macro ((null : tink.json.Representation<$rt>) : $ct)).typeof().isSuccess())
          pos.error('Cannot represent ${t.toString()} in JSON because ${(macro : tink.json.Representation<$rt>).toString()} cannot be converted to ${t.toString()}');

        Some(rep);
      }
      else None;
  }

  static public function shouldSerialize(f:ClassField)
    return
      !f.meta.has(':transient')
      && switch f.kind {
        case FVar(AccNever | AccCall, AccNever | AccCall):
          f.meta.has(':isVar');
        case FVar(_, _): true;
        default: false;
      }
}
#end