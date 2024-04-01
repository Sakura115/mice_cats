extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var in_ob:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	var p=get_parent()
	self.collision_layer=p.collision_layer
	self.collision_mask=p.collision_mask
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func area_in_ob()->bool:
	var i=0
	for t in range(in_ob.size()):
		if(in_ob[i]==null):
			#配列の中身がなかったら配列から消す
			#print(i)
			in_ob.remove(i)
			i-=1
		i+=1
	
	if in_ob.size()>0:
		return true
	else:
		return false
	pass

func _on_Collision_range_body_entered(body):
	in_ob.append(body)
	#print("in:"+str(body))
	pass # Replace with function body.


func _on_Collision_range_body_exited(body):
	for i in range(in_ob.size()):
		if(body==in_ob[i]):
			in_ob.remove(i)
			return
	print(str(body)+"が配列にありません")
	pass # Replace with function body.
