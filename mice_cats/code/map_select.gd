extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var set=false
signal Destination_set(posi)
var map_size

# Called when the node enters the scene tree for the first time.
func _ready():
	$pin.global_position=get_global_mouse_position()
	map_size=$CollisionShape2D.shape.get("extents")
	map_size*=2
	#print(map_size)
	set=false
	pass # Replace with function body.

func _process(delta):
	if !set:
		var mouse_posi = get_global_mouse_position()
		$pin.global_position=mouse_posi
		$pin.position.x=clamp($pin.position.x,0,map_size.x)
		$pin.position.y=clamp($pin.position.y,0,map_size.y)
		
		if Input.is_action_just_pressed("text_next"):
			set=true
			var posi=Vector2($pin.position.x/map_size.x,$pin.position.y/map_size.y)
			print(posi)
			emit_signal("Destination_set",posi)
	pass
