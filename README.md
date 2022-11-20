# PropertyList

Making custom exports in Godot with _get_property_list() is quite a mess, as each property requires 6 values, but you don't necessarily need to change all of them. Especially when you only want to make groups or categories in Godot 3, you don't need all the bloat for exporting the variables.

This script aims to simplify each property to one line, but still allow advanced exports:

![Script Example](https://i.imgur.com/aRnVZbj.png) ![Inspector Example](https://i.imgur.com/8Koy5K6.png)

You can use add all the settings in the method arguments, or use method binds (inspired by the new Tween system in Godot 4) to change other properties:

```gdscript
var ex_float: float = 2.0

func _get_property_list() -> Array:
    var pl := PropertyList.new()

    pl.add_prop("ex_float", TYPE_REAL, 2.0).usage(PROPERTY_USAGE_DEFAULT+PROPERTY_USAGE_CHECKABLE)

    return pl.props
```

![Inspector Example](https://i.imgur.com/FsEF8Ul.png)

Other common uses are already simplified:

* Export arrays with add_array(), static typing supported.

* Use Enums as exports of any supported type with add_prop_enum()

* NodePaths with add_node_path(). Filtering nodes by type doesn't work in 3.5

* All hidden Property Hints are available in the script, taken from the source code

I also added support for exporting data-only classes, it requires the use of _get() and _set(), but I simplified them with two static functions:

This works on any script or inner class, just make sure to add export to the variables you need. Highly recommend using the prefix option and putting all exported variables in a Group or Category

```gdscript
class ExRef extends Reference:
    export var health: int = 10
    export var mana: int = 6
    export var skill: String = "High"

var ex_ref: ExRef = ExRef.new()

func _get_property_list() -> Array:
    var pl := PropertyList.new()
        
    pl.add_group("Ref Example", "ref_")
    pl.add_class_variables(ex_ref, "ref_")

    return pl.props

func _get(property: String):
    var _ref := PropertyList.get_property_from_class(ex_ref, property, "ref_")
    if _ref != null: return _ref

    return null

func _set(property: String, value) -> bool:
    if PropertyList.set_property_from_class(ex_ref, property, value, "ref_"):
        return true

    return false
```

![Inspector Example](https://i.imgur.com/8WRfiAl.png)
