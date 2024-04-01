extends Position3D


export var speed:float =0.05

var cursor_lock:bool = true
var camera_posi:Position3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cursor_lock=true
	
	camera_posi=Position3D.new()
	add_child(camera_posi)
	camera_posi.transform=$CamPivot.transform
	pass # Replace with function body.


func _process(delta):
	#self.rotation_degrees.x=clamp(self.rotation_degrees.x,0,90)
	
	if GameManager.result&&cursor_lock:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor_lock=false
	pass

func _input(event):
	#リザルト画面じゃない時
	if !GameManager.result:
		#カーソルがロックされていてロック解除のキーが押されたら
		if cursor_lock && event.is_action_pressed("Cursor_display"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cursor_lock=false
			#print(cursor_lock)
		#カーソルがロックされておらずロック解除のキーが押されていなかったら
		elif !cursor_lock && event.is_action_released("Cursor_display"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			cursor_lock=true
			#print(cursor_lock)
		
		#カーソルがロックされていてマウスが動いたら
		if cursor_lock && event is InputEventMouseMotion:
			#マウスが動いた方向にカメラを回す
			var r = event.relative*speed
			self.rotation_degrees += Vector3(r.y,-r.x,0)
			
			#カメラの回転中心からからカメラ位置までの間に障害物があったらぶつかったところにカメラを配置する
			var space_state = get_world().direct_space_state
			var res = space_state.intersect_ray(self.global_translation, camera_posi.global_translation,[get_parent()])
			if res:
				var hit_pos=res.position
				#var hit_d=self.translation-hit_pos
				#hit_d=hit_d.normalized()
				$CamPivot.transform=camera_posi.transform
				$CamPivot.global_translation=hit_pos
				#$CamPivot.move_and_slide(Vector3.ZERO,-hit_d)
				#print("camera_hit!!")
			else:
				$CamPivot.transform=camera_posi.transform
	pass

#カメラの方向
func camera_direction()->Vector3:
	var ans:Vector3 = self.global_translation -$CamPivot.global_translation
	ans=ans.normalized()
	return ans
	pass
