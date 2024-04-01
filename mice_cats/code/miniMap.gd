extends Area2D

var map_size

# Called when the node enters the scene tree for the first time.
func _ready():
	map_size=$CollisionShape2D.shape.get("extents")
	map_size*=2
	goal_posi_set(GameManager.destination_point)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#渡されたゴールの位置に画像を移動する(位置は縦横0~1の比率で考える)
func goal_posi_set(goalPosi:Vector2=Vector2.ZERO):
	goalPosi=(goalPosi-Vector2(0.5,0.5))*map_size
	$goal.position=goalPosi
	pass

#渡された猫とネズミの位置に画像を移動する(位置は縦横0~1の比率で考える)
func mouse_cat_posi_set(mousePosi:Vector2=Vector2.ZERO,catPosi:Vector2=Vector2.ZERO):
	mousePosi=(mousePosi-Vector2(0.5,0.5))*map_size
	$mouse.position=mousePosi
	catPosi=(catPosi-Vector2(0.5,0.5))*map_size
	$cat.position=catPosi
	pass
