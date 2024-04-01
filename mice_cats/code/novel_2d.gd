extends Node2D

signal story_end()
signal flag_change(flag)
signal Destination(posi)

var end = true
var lines=0
var msg:Array
var msg_name:Array
var msg_flag:Array #ジャンプする先の判断のため
var can_go_next:bool=true
var nowFlag=""
export var speed=0.05 #文字の表示スピード
var buttons:Array
var text
var tween
var text_font
var choice
var story_end=false
var triangle=false
var select=false
var map
var start=false

func _ready():
	visible = true
	start=false
	text=$ColorRect/text
	tween=$ColorRect/text/Tween
	text.clear()
	text.percent_visible = 0
	lines=0
	text_font=text.get_font("normal_font")
	load_text("res://data/story.txt")
	nowFlag=""
	pass

func _process(delta):
	
	if !GameManager.scene_changing:
		if !start:
			start=true
			flag_signal()
			novel()
		#入力
		if Input.is_action_just_pressed("text_next"):
			if end == true:
				novel()
			else:
				#表示が終わっていなかったら表示スピードを速くする
				$ColorRect/text/Tween.playback_speed=10
			
		
		if end&&can_go_next&&!triangle:
			text.bbcode_text+=" [wave amp=25 freq=25]v[/wave]"
			triangle=true

func novel():
	if msg.size()>lines:
		if can_go_next:
			flag_signal()
			if msg_name[lines]=="選択肢":#名前が選択肢の時,選択肢を表示する
				if !select:
					$choices_posi/choices.rect_position=Vector2(0,0)
					$choices_posi/choices.rect_size=Vector2(0,0)
					var tmp=msg[lines].split("	")
					var choices = tmp[0].split("/")
					var route:Array
					if tmp.size()>=2:
						route=tmp[1].split("/")
						#print(route)
						if route.size()<choices.size():
							for i in range(choices.size()-route.size()):
								route.append("")
					else:
						for i in range(choices.size()):
							route.append("")
					
					for i in range(choices.size()):
						var b=choice_Button.new()
						b.name="選択肢"+str(i+1)
						b.add_font_override("font",text_font)
						b.text=choices[i]
						b.set_jump_flag(route[i])
						b.connect("choice",self,"choice_Button_pressed")
						$choices_posi/choices.add_child(b)
						buttons.append(b)
					$choices_posi/choices.rect_position.y=0
					$choices_posi/choices.rect_position-=$choices_posi/choices.rect_size
					can_go_next=false
					select=true
					#vを消す
					var v="[wave amp=25 freq=25]v[/wave]"
					var t=text.bbcode_text
					#var Index = t.find(v)
					text.bbcode_text = t.replace(v,"")
			elif msg_name[lines]=="ジャンプ":#名前がジャンプの時,メッセージ部分に書かれたフラグのとこまでジャンプする
				jump_line(msg[lines])
			elif msg_name[lines]=="エンド":#名前がエンドの時,終わる
				emit_signal("story_end")
				story_end=true
				print("story_end")
			elif msg_flag[lines]=="地点決め":#flagが地点決めの時,マップを表示する
				for c in $map.get_children():#mapの下にすでに別のものがあれば削除する
					c.queue_free()
				var map_scene=preload("res://Scene/map_select.tscn")
				map=map_scene.instance()
				$map.add_child(map)
				map.connect("Destination_set",self,"map_Destination_set")
				show_text()
				can_go_next=false
			else:
				GameManager.SE()
				show_text()
			
	else:
		emit_signal("story_end")
		story_end=true
		print("story_end")
	pass

func flag_signal():
	if msg_flag.size()>lines:
		if msg_flag[lines]!=""&&nowFlag!=msg_flag[lines]:
			nowFlag=msg_flag[lines]
			emit_signal("flag_change",nowFlag)

#一文字ずつテキストを表示する
func show_text():
	if lines < msg.size():
		$textSE.play()
		triangle=false
		end = false
		text.clear()
		tween.playback_speed=1
		text.percent_visible = 0
		text.bbcode_text = msg[lines]
		#print(msg[lines])
		$ColorRect/ColorRect/name.text=msg_name[lines]
		#Tweenの「interpolate_property」を使用して、1行の表示文字のパーセンテージを徐々に上昇させることで一文字ずつ表示させる。
		tween.interpolate_property(text, "percent_visible", 0, 1,text.text.length()*speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	lines += 1
	

func load_text(fname):
	msg.clear()
	lines = 0
	var file = File.new()
	if file.open(fname, File.READ) == 0: #エラーがなければfnameのファイルパスを「読み取り専用(READ)」で開く
		var i=0
		while !file.eof_reached(): #「ファイルの終端」が来るまで以下の処理を繰り返す
			
			match i%3:
				0:msg_flag.append(file.get_line())
				1:msg_name.append(file.get_line())
				2:msg.append(file.get_line())
			i+=1
	file.close()
	#if msg_flag.size()>msg_name.size():
	#	for i in range(msg_flag.size()-msg_name.size()):
	#		msg_name.append("")
	#if msg_name.size()>msg.size():
	#	for i in range(msg_name.size()-msg.size()):
	#		msg.append("")

func button_clear():
	for i in range(buttons.size()):
		buttons[0].visible=false
		buttons[0].queue_free()
		buttons.remove(0)
	pass

func choice_Button_pressed(choice_flag):
	GameManager.SE()
	#print(choice_flag)
	button_clear()
	jump_line(choice_flag)
	select=false
	pass

func jump_line(flag=""):
	if flag=="":
		lines+=1
		can_go_next=true
		novel()
		return
	else:
		for i in range(msg_flag.size()):
			var jump_lines=(lines+i+1)%msg_flag.size()
			if flag==msg_flag[jump_lines]:
				lines=jump_lines
				#print("jump:"+str(jump_lines))
				#print(msg[jump_lines])
				can_go_next=true
				novel()
				break
	pass
#Tweenが終了したら実行されるシグナル
func _on_Tween_tween_completed(object, key):
	#print("text_end")
	$textSE.stop()
	end = true

func map_Destination_set(posi):
	emit_signal("Destination",posi)
	can_go_next=true
	pass # Replace with function body.
