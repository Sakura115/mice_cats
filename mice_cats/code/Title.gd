extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.replay()
	pass # Replace with function body.




func _on_start_pressed():
	GameManager.SE()
	GameManager.changeScene("res://Scene/novel_3d.tscn")
	pass # Replace with function body.


func _on_quit_pressed():
	GameManager.SE()
	get_tree().quit()
	pass # Replace with function body.
