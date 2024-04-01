extends Spatial

export var face_material:Material
export var body_material:Material
#export var face_id:int=0

var now_face:int=0

# Called when the node enters the scene tree for the first time.
func _ready():
	if face_material!=null:
		face_material_set(face_material)
	if body_material!=null:
		body_material_set(body_material)
	#face_set(face_id) #複製したすべてのモデルの表情が変わるため除外
	pass # Replace with function body.

func _process(delta):
	#face_id=0 
	#face_set(face_id)
	pass

func face_material_set(material:Material):
	$mouse/Skeleton/face.material_override=material
	pass

func body_material_set(material:Material):
	$mouse/Skeleton/mouse_body.material_override=material
	pass

func face_set(id:int=0):
	print(id)
	if now_face!=id:
		now_face=id
		var fmesh=$mouse/Skeleton/face
		fmesh.set("blend_shapes/- -_eye",0)
		fmesh.set("blend_shapes/><_eye",0)
		fmesh.set("blend_shapes/×_eye",0)
		match id:
			1:
				fmesh.set("blend_shapes/- -_eye",1)
			2:
				fmesh.set("blend_shapes/><_eye",1)
			3:
				fmesh.set("blend_shapes/×_eye",1)
	#print($mouse/Skeleton/face.get("blend_shapes/><_eye"))
	pass
