tool
extends Node2D

var ex_int: int = 1
var ex_str: String = "Hello"

var ex_float: float = 2.0
var ex_arr: Array = []

func _get_property_list() -> Array:
	var pl := PropertyList.new()
	
	pl.add_prop("ex_int", TYPE_INT, 1)
	pl.add_prop("ex_str", TYPE_STRING, "Hello")
	
	pl.add_group("Example Group")
	pl.add_prop("ex_float", TYPE_REAL, 2.0)
	pl.add_array("ex_arr", TYPE_BOOL)
	
	return pl.props
