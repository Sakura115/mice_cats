extends Button

class_name choice_Button

signal choice(button)

var flag

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed",self,"_on_choice_Button_pressed")
	pass # Replace with function body.


func _on_choice_Button_pressed():
	emit_signal("choice",flag)
	pass # Replace with function body.

func set_jump_flag(flag=""):
	self.flag=flag
	pass
