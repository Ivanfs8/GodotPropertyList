tool
extends Node2D

class ExRef extends Reference:
	export var health: int = 10
	export var mana: int = 6
	export var skill: String = "High"

var ex_int: int = 1
var ex_str: String = "Hello"

var ex_ref: ExRef = ExRef.new()

var ex_float: float = 2.0
var ex_arr: Array = []

var _cam: NodePath = ""
onready var cam: Camera2D = get_node(_cam)

func _get_property_list() -> Array:
	var pl := PropertyList.new()
	
	pl.add_prop("ex_int", TYPE_INT, 1)
	pl.add_prop("ex_str", TYPE_STRING, "Hello")
	
	pl.add_node_path("_cam")
	
	pl.add_group("Ref Example", "ref_")
	pl.add_class_variables(ex_ref, "ref_")
	
	pl.add_group("Group Example")
	pl.add_prop("ex_float", TYPE_REAL, 2.0).usage(PROPERTY_USAGE_DEFAULT+PROPERTY_USAGE_CHECKABLE)
	
	pl.add_array("ex_arr", TYPE_BOOL)
	
	
	return pl.props

func _get(property: String):
	var _ref := PropertyList.get_property_from_class(ex_ref, property, "ref_")
	if _ref != null: return _ref
	
	return null

func _set(property: String, value) -> bool:
	if PropertyList.set_property_from_class(ex_ref, property, value, "ref_"):
		return true
	
	return false
