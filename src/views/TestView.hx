package views;

class TestView {
    public var name:String;
    public var friends:Array<String>;
    public function new(name) {
        this.name = name;
        this.friends = new Array();
    }
    @:template('Test.gabrihtml') public function renderTest();
}