extends KinematicBody

signal player_hit

export var speed = 14
export var run_add_speed=10
export var fall_acc = 75
export var jump_imp = 30
export var bounce_imp = 15
export var squat_size=0.7

var cam
var myCollision:CollisionShape
var c_height

var player_Ani

var velocity = Vector3.ZERO

var jump=false
var squatting=false

var second_jump=false

var on_floor=true

var mob

func _ready():
	var tmp=load("res://data/ねずみの鳴き声_(2個)_2.mp3")
	tmp.set("loop",false)
	$mouseSE.stream=tmp
	
	if has_node("camera"):
		cam=get_node("camera")
		
	else:
		cam=null
	#print("camera")
	#print(cam)
	
	if get_parent().has_node("Mob"):
		mob=get_parent().get_node("Mob")
	else:
		mob=null
	#print(mob)
	
	myCollision=$CollisionShape
	c_height=myCollision.shape.height
	
	player_Ani=$Position3D/mouse/AnimationPlayer
	
	pass # Replace with function body.



func _process(delta):
	if !GameManager.scene_changing:
		if !GameManager.result:
			var direction = Vector3.ZERO
			
			if Input.is_action_pressed("ui_right"):
				direction.x+=1
			if Input.is_action_pressed("ui_left"):
				direction.x-=1
			if Input.is_action_pressed("ui_down"):
				direction.z+=1
			if Input.is_action_pressed("ui_up"):
				direction.z-=1
			
			if direction!=Vector3.ZERO:
				direction = direction.normalized()
				
				if cam!=null:
					var camera_D:Vector3=cam.camera_direction()
					camera_D.y=0
					camera_D=camera_D.normalized()
					var direct2=Vector2(direction.x,direction.z).normalized()
					var camera_D2=Vector2(camera_D.x,camera_D.z).normalized()
					var r = direct2.angle()+(camera_D2.angle()+1/2.0*PI)
					direction=Vector3(cos(r),direction.y,sin(r)).normalized()
				
				$Position3D.look_at(translation-direction,Vector3.UP)
			
			if (is_on_floor()||!second_jump) and Input.is_action_just_pressed("jump"):#ジャンプはじめ
				if !is_on_floor():
					second_jump=true
				velocity.y=jump_imp
				jump=true
				player_Ani.play("jump_start")
				squat(false)
				
			elif is_on_floor()&&(jump || !on_floor):#ジャンプ終わり または着地
				if squatting:
					if jump:
						player_Ani.play("squat_start")
				else:
					player_Ani.play("jump_end")
				jump=false
				second_jump=false
			
			on_floor=is_on_floor()
			
			if !squatting&&Input.is_action_pressed("squat")&&!jump:
				squat()
			elif squatting&&!Input.is_action_pressed("squat"):
				squat()
			
			
			
			if Input.is_action_just_pressed("speed_up"):
				speed+=run_add_speed
			elif Input.is_action_just_released("speed_up"):
				speed-=run_add_speed
			
			if Input.is_action_just_pressed("provoke"):
				$mouseSE.play()
				mob.provoke()
			
			#if is_on_floor():
				#velocity.y+=1 #コリジョンめり込みによる揺れの防止
			
			if !is_on_floor():
				velocity.y-=fall_acc*delta
			
			velocity.x=direction.x*speed
			velocity.z=direction.z*speed
			
			move_and_slide(velocity,Vector3.UP)
			
			if self.translation.y<-5:
				self.translation.y=10
			
			for i in range(get_slide_count()):
				var collision=get_slide_collision(i)
				if(collision.collider.collision_layer==2):
					emit_signal("player_hit")
					#print(collision.collider.name)
					break

func squat(start:bool=!squatting):
	
	if myCollision!=null&&start&&!squatting:
		myCollision.shape.height=c_height*squat_size
		myCollision.translation.y-=c_height/2.0*(1-squat_size)
		squatting=true
		player_Ani.play("squat_start")
		return
	
	var canUp=true
	
	#var space_state = get_world().direct_space_state
	#var ray_start=self.global_translation
	#ray_start.y +=c_height*squat_size
	#var ray_end=self.global_translation
	#ray_end.y+=c_height
	#var result = space_state.intersect_ray(ray_start, ray_end,[self])
	#if result:
	#	canUp=false
	#	print(str(ray_start)+","+str(ray_end))
	#	print(result.position)
	
	canUp=$Collision_range.area_in_ob()
	
	if myCollision!=null&&!start&&squatting&&!canUp:
		myCollision.shape.height=c_height
		myCollision.translation.y+=c_height/2.0*(1-squat_size)
		squatting=false
		player_Ani.play("squat_end")
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
