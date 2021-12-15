package dal.models;

typedef Product = {
	var id:Int;
	var name:String;
	var desc:String;
	var image:String;
	var price:Float;
    
	@:json("supplierName") 
    var vendor:String;
}
