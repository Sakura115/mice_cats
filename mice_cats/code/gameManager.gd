extends CanvasLayer
var destination_point=Vector2(0.706024, 0.636145)
var score=0
var msg=""
var result=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sound:AudioStreamPlayer2D
var SE:AudioStreamPlayer2D

var scene_changeMode=0
var scene_changePath

var scene_changing=false
var stimer=0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.hide()
	#var wSize=get_viewport_rect().size
	var wSize=Vector2(1024,600)
	$ColorRect.margin_top=-5
	$ColorRect.margin_bottom=wSize.y+5
	$ColorRect.margin_left=-5
	$ColorRect.margin_right=wSize.x+5
	sound=AudioStreamPlayer2D.new()
	add_child(sound)
	sound.stream=load("res://data/v5.mp3")
	sound.play()
	
	SE=AudioStreamPlayer2D.new()
	add_child(SE)
	var tmp=load("res://data/決定17.mp3")
	tmp.set("loop",false)
	SE.stream=tmp
	pass # Replace with function body.

func _process(delta):
	if !sound.playing:
		sound.play()
	
	if scene_changeMode==1:
		if !$AnimationPlayer.is_playing():
			get_tree().change_scene(scene_changePath)
			scene_changeMode=2
	elif scene_changeMode==2:
		stimer+=delta
		if stimer>0.5:
			$AnimationPlayer.play_backwards("fadeIN")
			yield($AnimationPlayer, "animation_finished")
			$ColorRect.hide()
			scene_changeMode=0
			scene_changing=false
	pass

func replay():
	if sound.playing:
		sound.stop()
	sound.play()
	pass

func SE():
	SE.play()
	pass

func changeScene(path:String):
	scene_changing=true
	scene_changePath=path
	$ColorRect.show()
	sound.stop()
	scene_changeMode=1
	$AnimationPlayer.play("fadeIN")
	#yield($AnimationPlayer, "animation_finished")
	
	pass
