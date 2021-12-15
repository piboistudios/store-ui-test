class AppConfig {
    public static var data(get, never):AppConfigData;
    public static function get_data() return _inst;
    static var _inst:AppConfigData;
    public static function init() {
        _inst = tink.Json.parse(sys.io.File.getContent('./app.config.json'));
    }
    
}
typedef AppConfigData = {
    public var connectionStrings:Map<String,String>;
}