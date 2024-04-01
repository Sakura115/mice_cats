extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var mouse_N=25 #味方のネズミの数
export var decreases_time=20.0
var timer=0.0
var speed_Up:float=0
var city_size

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.replay()
	city_size=$Ground/city/floor.mesh.get("size")
	city_size*=1
	var point=(GameManager.destination_point-Vector2(0.5,0.5))*city_size
	$Ground/city/goal.translation=Vector3(point.x,$Ground/city/goal.translation.y,point.y)
	var dist=$Ground/city/goal.translation.distance_to($Ground/city/mura.translation)
	var Maxd=city_size.length()
	speed_Up=float(dist)/Maxd
	speed_Up=1-speed_Up
	#print(speed_Up)
	pass # Replace with function body.


func _process(delta):
	var playerPosi=Vector2($Player.translation.x,$Player.translation.z)
	playerPosi=playerPosi/city_size+Vector2(0.5,0.5)
	var mobPosi=Vector2($Mob.translation.x,$Mob.translation.z)
	mobPosi=mobPosi/city_size+Vector2(0.5,0.5)
	$Player/camera/CamPivot/Camera/Node2D/miniMap.mouse_cat_posi_set(playerPosi,mobPosi)
	if !GameManager.scene_changing:
		if !GameManager.result:
			timer+=delta
			var tmp=(decreases_time-decreases_time/2*speed_Up)
			if timer>tmp:
				mouse_N-=1
				timer-=int(timer/tmp)*tmp
			
			$Player/camera/CamPivot/Camera/Node2D/Label/mouse_N.text=str(mouse_N)
			
			if mouse_N<=0:
				print("gameclear")
				GameManager.score=0
				GameManager.msg="村は滅びてしまった..."
				result()
	pass


func _on_Player_player_hit():
	print("gameover")
	GameManager.score=0
	GameManager.msg="あなたは猫に食べられてしまった..."
	result()
	pass # Replace with function body.


func _on_goal_body_entered(body):
	if(body.collision_layer==2):
		print("gameclear")
		GameManager.score=mouse_N
		GameManager.msg="あなたは村の危機を救った！！"
		result()
	pass # Replace with function body.


func _on_mura_body_entered(body):
	if(body.collision_layer==2):
		print("gameover")
		GameManager.score=mouse_N
		GameManager.msg="村に猫が襲来！！\n村は滅びてしまった..."
		result()
	pass # Replace with function body.

func result():
	var r=preload("res://Scene/result.tscn")
	var rm=r.instance()
	add_child(rm)
	GameManager.result=true
	pass
