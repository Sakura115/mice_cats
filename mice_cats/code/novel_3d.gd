extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var novel2d
var ani
var set_can_next=false
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.replay()
	novel2d=$cameraPivot/Camera/novel_2d
	#ani=$AnimationPlayer.get_animation_list()
	
	pass # Replace with function body.

func _process(delta):
	if !GameManager.scene_changing:
		if !set_can_next:
			novel2d.can_go_next=!$AnimationPlayer.is_playing()
	pass

func can_go_next(can:bool=true):
	novel2d.can_go_next=can
	set_can_next=true

func _on_novel_2d_flag_change(flag):
	if ani==null:
		ani=$AnimationPlayer.get_animation_list()
	for i in range(ani.size()):
		if ani[i]==flag:
			$AnimationPlayer.play(flag)
			set_can_next=false
			print(flag)
			return
	pass # Replace with function body.


func _on_novel_2d_story_end():
	GameManager.changeScene("res://Scene/main.tscn")
	pass # Replace with function body.


func _on_novel_2d_Destination(posi):
	GameManager.destination_point=posi
	pass # Replace with function body.
