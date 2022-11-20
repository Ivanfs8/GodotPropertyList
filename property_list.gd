class_name PropertyList

enum HINTS { #last_update godot 3.3.3
	PROPERTY_HINT_NONE, # no hint provided.
	PROPERTY_HINT_RANGE, # hint_text = "min,max,step,slider; //slider is optional"
	PROPERTY_HINT_EXP_RANGE, # hint_text = "min,max,step", exponential edit
	PROPERTY_HINT_ENUM, # hint_text= "val1,val2,val3,etc"
	PROPERTY_HINT_EXP_EASING, # exponential easing function (Math::ease) use "attenuation" hint string to revert (flip h), "full" to also include in/out. (ie: "attenuation,inout")
	PROPERTY_HINT_LENGTH, # hint_text= "length" (as integer)
	PROPERTY_HINT_SPRITE_FRAME, # Obsolete: drop whenever we can break compat. Keeping now for GDNative compat.
	PROPERTY_HINT_KEY_ACCEL, # hint_text= "length" (as integer)
	PROPERTY_HINT_FLAGS, # hint_text= "flag1,flag2,etc" (as bit flags)
	PROPERTY_HINT_LAYERS_2D_RENDER,
	PROPERTY_HINT_LAYERS_2D_PHYSICS,
	PROPERTY_HINT_LAYERS_3D_RENDER,
	PROPERTY_HINT_LAYERS_3D_PHYSICS,
	PROPERTY_HINT_FILE, # a file path must be passed, hint_text (optionally) is a filter "*.png,*.wav,*.doc,"
	PROPERTY_HINT_DIR, # a directory path must be passed
	PROPERTY_HINT_GLOBAL_FILE, # a file path must be passed, hint_text (optionally) is a filter "*.png,*.wav,*.doc,"
	PROPERTY_HINT_GLOBAL_DIR, # a directory path must be passed
	PROPERTY_HINT_RESOURCE_TYPE, # a resource object type
	PROPERTY_HINT_MULTILINE_TEXT, # used for string properties that can contain multiple lines
	PROPERTY_HINT_PLACEHOLDER_TEXT, # used to set a placeholder text for string properties
	PROPERTY_HINT_COLOR_NO_ALPHA, # used for ignoring alpha component when editing a color
	PROPERTY_HINT_IMAGE_COMPRESS_LOSSY,
	PROPERTY_HINT_IMAGE_COMPRESS_LOSSLESS,
	PROPERTY_HINT_OBJECT_ID,
	PROPERTY_HINT_TYPE_STRING, # a type string, the hint is the base type to choose
	PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE, # so something else can provide this (used in scripts)
	PROPERTY_HINT_METHOD_OF_VARIANT_TYPE, # a method of a type
	PROPERTY_HINT_METHOD_OF_BASE_TYPE, # a method of a base type
	PROPERTY_HINT_METHOD_OF_INSTANCE, # a method of an instance
	PROPERTY_HINT_METHOD_OF_SCRIPT, # a method of a script & base
	PROPERTY_HINT_PROPERTY_OF_VARIANT_TYPE, # a property of a type
	PROPERTY_HINT_PROPERTY_OF_BASE_TYPE, # a property of a base type
	PROPERTY_HINT_PROPERTY_OF_INSTANCE, # a property of an instance
	PROPERTY_HINT_PROPERTY_OF_SCRIPT, # a property of a script & base
	PROPERTY_HINT_OBJECT_TOO_BIG, # object is too big to send
	PROPERTY_HINT_NODE_PATH_VALID_TYPES,
	PROPERTY_HINT_SAVE_FILE, # a file path must be passed, hint_text (optionally) is a filter "*.png,*.wav,*.doc,". This opens a save dialog
	PROPERTY_HINT_MAX,
}

var props: Array = [] setget set_prop_list, get_prop_list
func set_prop_list(_value) -> void: return
func get_prop_list() -> Array: return props

class MethodBind:
	var dict: Dictionary
	
	func _init(edit: Dictionary) -> void:
		dict = edit
	
	func usage(p_usage: int):
		dict["usage"] = p_usage
		
	func hint(p_hint: int, p_hint_string: String = ""):
		dict["hint"] = p_hint
		dict["hint_string"] = p_hint_string

func _init():
	props = []

func add_group(p_name: String, gru_hint_string: String = "") -> void:
	props.push_back({
		name = p_name,
		type = TYPE_NIL,
		hint = PROPERTY_HINT_NONE,
		hint_string = gru_hint_string,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		}
	)

func add_category(p_name: String, cat_hint_string: String = "") -> void:
	props.push_back({
		name = p_name,
		type = TYPE_NIL,
		hint = PROPERTY_HINT_NONE,
		hint_string = cat_hint_string,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})

func add_prop(p_name: String, p_type: int, p_value, p_hint: int = PROPERTY_HINT_NONE, p_hint_string: String = "", p_usage = PROPERTY_USAGE_DEFAULT):
	props.push_back({
		name = p_name,
		type = p_type,
		value = p_value,
		hint = p_hint,
		hint_string = p_hint_string, 
		usage = p_usage
	})
	
	return MethodBind.new(props[props.size()-1])

func add_prop_enum(p_name: String, r_enum: Dictionary, p_type: int = TYPE_INT):
	var p_hint_string: String = ""
	for r in r_enum:
		p_hint_string += r+","
	p_hint_string[p_hint_string.length()-1] = ""
	
	props.push_back({
		name = p_name,
		type = p_type,
		# warning-ignore:incompatible_ternary
		# warning-ignore:incompatible_ternary
		value = 0 if p_type == TYPE_INT else "",
		hint = PROPERTY_HINT_ENUM,
		hint_string = p_hint_string, 
		usage = PROPERTY_USAGE_DEFAULT
	})
	
	return MethodBind.new(props[props.size()-1])

func add_array(p_name: String, v_type: int = -1, v_hint:int = 0, v_hint_string: String = "", p_usage: int = PROPERTY_USAGE_DEFAULT):
	var hint_str: String = ""
	if v_type > -1: 
		hint_str += str(v_type)
		hint_str += str("/", v_hint)
		#if !v_hint_string.empty():
		hint_str+=str(":", v_hint_string)
	
	props.push_back({
		name = p_name,
		type = TYPE_ARRAY,
		#value = [],
		hint = HINTS.PROPERTY_HINT_TYPE_STRING,
		hint_string = hint_str, 
		usage = p_usage
	})
	
	return MethodBind.new(props[props.size()-1])

func add_array_arg(p_name: String, args: Array, p_usage: int = PROPERTY_USAGE_DEFAULT):
	var hint_str: String = ""
	for i in args.size():
		if i == args.size() -1: hint_str += ":"
		
		hint_str+= str(args[i])
		
		if typeof(args[i]) == TYPE_INT && args[i] == TYPE_ARRAY: hint_str += ":"
		elif i != args.size()-1: hint_str += "/"
	
	props.push_back({
		name = p_name,
		type = TYPE_ARRAY,
		#value = [],
		hint = HINTS.PROPERTY_HINT_TYPE_STRING,
		hint_string = hint_str, 
		usage = p_usage
	})
	
	return MethodBind.new(props[props.size()-1])

func add_node_path(p_name: String, valid_type: String = "", p_usage = PROPERTY_USAGE_DEFAULT):
	var hint: int = PROPERTY_HINT_NONE
	if !valid_type.empty(): hint = HINTS.PROPERTY_HINT_NODE_PATH_VALID_TYPES
	
	props.push_back({
		name = p_name,
		type = TYPE_NODE_PATH,
		value = NodePath(""),
		hint = hint,
		hint_string = valid_type, 
		usage = p_usage
	})
	
	return MethodBind.new(props[props.size()-1])

func add_class_variables(instance: Object, prefix: String = "",p_hint : int = PROPERTY_HINT_NONE, hint: String = ""):
	#var instance = instance_from_id(instance_id)
	#if instance == null: instance = base
	for p in instance.get_property_list(): 
		var exclude: bool = false
		match p.name:
			"Reference", "reference", "script", "Script Variables", "Script", "Resource", "resource", "resource_path", "resource_name", "resource_local_to_scene": 
				exclude = true
		if exclude: continue
		else:
			var type: int = typeof(instance.get(p.name))
			add_prop(prefix+p.name, type, instance.get(p.name), p_hint, hint, PROPERTY_USAGE_EDITOR)
	
	return MethodBind.new(props[props.size()-1])

static func set_property_from_class(instance: Object, property: String, value, prefix: String = "") -> bool:
	match property:
		"Reference", "reference", "script", "Script Variables", "Script", "Resource", "resource", "resource_path", "resource_name", "resource_local_to_scene": 
			return false
	
	var prop: String = property
	
	if prefix != "":
		if property.begins_with(prefix):
			prop = property.trim_prefix(prefix)
		else:
			return false
	
	for p in instance.get_property_list(): 
		if prop == p.name:
			#if instance == null: instance = base
			instance.set(p.name, value)
			return true
	
	return false

static func get_property_from_class(instance: Object, property: String, prefix: String = "") -> Object:
	match property:
		"Reference", "reference", "script", "Script Variables", "Script", "Resource", "resource", "resource_path", "resource_name", "resource_local_to_scene": 
			return null
	
	var prop: String = property
	
	if prefix != "":
		if property.begins_with(prefix):
			prop = property.trim_prefix(prefix)
		else:
			return null
			
	for p in instance.get_property_list(): 
		if prop == p.name:
			return instance.get(p.name)
	
	return null
