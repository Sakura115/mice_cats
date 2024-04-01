extends Label



# Called when the node enters the scene tree for the first time.
func _ready():
	$score.text=str(GameManager.score)
	$msg.text=str(GameManager.msg)
	
	pass # Replace with function body.


func _on_Button_pressed():
	GameManager.SE()
	GameManager.result=false
	GameManager.changeScene("res://Scene/Title.tscn")
	pass # Replace with function body.
