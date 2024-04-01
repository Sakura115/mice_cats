extends KinematicBody

export var speed = 4
export var fall_acc = 75
export var inertia=0.7

export var forgetT:float=8
var Ftimer:float=0
var Aim=null
var FtimerOn=false

export var provoke_r=2
export var provoke_T=2
var Ptimer:float=0
var col_size
var Pon=false

var velocity = Vector3.ZERO

func _ready():
	col_size=$Area/CollisionShape.shape.get("radius")
	#randomize()
	#while(1):
	#	translation.x = rand_range(-10.0,10.0)
	#	translation.z = rand_range(0.0,20.0)
	#	if p_posi!=null:
	#		var dist=translation.distance_to(p_posi.get_translation())
	#		if(dist>8.0):
	#			break
	pass

func _process(delta):
	if !GameManager.scene_changing:
		if Aim!=null:
			var direction = Aim.get_translation()-translation
			#var direction = translation.distance_to(p_posi.get_translation())
			#print(direction)
			direction.y=0
			
			if direction!=Vector3.ZERO:
				direction = direction.normalized()
				#look_at(-direction,Vector3(0,1,0))
				$Position3D.look_at(translation-direction,Vector3.UP)
				$Position3D/neko/AnimationPlayer.play("run")
			else:
				$Position3D/neko/AnimationPlayer.stop()
			
			var tmp=velocity
			velocity.x=direction.x*speed + tmp.x*inertia
			velocity.z=direction.z*speed + tmp.z*inertia
			velocity.y-=fall_acc*delta
			move_and_slide(velocity,Vector3.UP)
		
		if FtimerOn:
			Ftimer+=delta
		
		if Ftimer>forgetT:
			Aim=null
			face_set(1)
		
		if Pon:
			Ptimer+=delta
		
		if Ptimer>provoke_T:
			Pon=false
			$Area/CollisionShape.shape.set("radius",col_size)

func _on_Area_body_exited(body):
	#print(body)
	#print(body.collision_layer)
	if body==Aim:
		FtimerOn=true
		Ftimer=0
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if Aim==null:
		if(body.collision_layer==1):
			Aim=body
			FtimerOn=false
			Ftimer=0
			print("aim")
			print(Aim)
			face_set(3)
	pass # Replace with function body.
	

func provoke():
	$Area/CollisionShape.shape.set("radius",col_size*provoke_r)
	Ptimer=0
	Pon=true
	pass

func face_set(id:int=0):
	var fmesh=$Position3D/neko/cat/Skeleton/hyouzyou1
	fmesh.set("blend_shapes/まったり",0)
	fmesh.set("blend_shapes/やる気",0)
	fmesh.set("blend_shapes/キラーン",0)
	match id:
		1:
			fmesh.set("blend_shapes/まったり",1)
		2:
			fmesh.set("blend_shapes/やる気",1)
		3:
			fmesh.set("blend_shapes/キラーン",1)
	pass
