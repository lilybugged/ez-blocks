extends Control

const meshRef = preload("res://grass/relevant/grass_0.obj")
const mat0Ref = preload("res://grass/relevant/grass.material")

const mat1Ref = preload("res://grass/relevant/dirt.material")
const mat2Ref = preload("res://shirt2.material")
var clear = true

onready var hitmeter = self.get_node("../hitmeter/meter")
onready var grader = self.get_node("../gradedisplay/Sprite")
onready var hitbar = self.get_node("../hitbar/ColorRect2")
onready var hitbox = self.get_node("../hitbox/Sprite")

onready var level = 0
onready var floatLevel = 0.0
onready var chain = self.get_node("../commandchain/HBoxContainer")
onready var notes = []
onready var notescene = load("res://prefabs/note.tscn")

onready var grade_blank = load("res://noteskin/grade_blank.png")

onready var grade_miss = load("res://noteskin/grade_miss.png")
onready var grade_bad = load("res://noteskin/grade_bad.png")
onready var grade_ok = load("res://noteskin/grade_ok.png")
onready var grade_cool = load("res://noteskin/grade_cool.png")
onready var grade_perfect = load("res://noteskin/grade_perfect.png")

onready var noteI = load("res://noteskin/note_I.png")
onready var noteII = load("res://noteskin/note_II.png")
onready var noteIII = load("res://noteskin/note_III.png")
onready var noteIV = load("res://noteskin/note_IV.png")

onready var noteIclear = load("res://noteskin/note_I_clear.png")
onready var noteIIclear = load("res://noteskin/note_II_clear.png")
onready var noteIIIclear = load("res://noteskin/note_III_clear.png")
onready var noteIVclear = load("res://noteskin/note_IV_clear.png")

onready var notesCleared = 0 #means the amount of notes in the chain cleared so far
onready var runningIndex = 0 #means the running number of touches
onready var runningClear = true #true means a new round of touches has started
onready var runningChainClear = false #true means that a grade has been decided
onready var sizeUpdate = false #true means there has been a change in floatLevel

onready var popplayer = self.get_node("../popplayer")
onready var kickplayer = self.get_node("../kickplayer")
onready var audioplayer = self.get_node("../AudioStreamPlayer")

onready var label = self.get_node("../exp")

onready var gradeTimer = -1

onready var canWalk = true #false means that the character is dancing, so you can't move
onready var currentTrack = 0 #the index of the current song, which changes when the last song ends

onready var songs = [load("res://audio/jrawly.ogg"), load("res://audio/weirddream.ogg"),load("res://audio/wavy.ogg")]
onready var bpms = [110.0,128.0,128.0]
onready var accumulation = 0.5 #the rate at which the player ascends levels

onready var experience = 0 #the actual exp of the user
onready var mapWidth = 5 #the width of the map
onready var mapSize = 50 #the width of the map

onready var gameMap = [] #map of blocks that can be destroyed
onready var damageMap = [] #map of damage to blocks that can be destroyed

onready var weTesting = true #true means that settings for testing on desktop are enabled

onready var step=0


# Called when the node enters the scene tree for the first time.
func _ready():
	audioplayer.stream = songs[currentTrack]
	audioplayer.play()
	
	label.text = "exp: 0"
	
	#initialize the map
	
	
	for i in range(mapSize):
		var num = randi()%10
		var newMesh = MeshInstance.new()

		if num != 0 or i<mapWidth:
			if i < mapWidth:
				if i==0 or i==mapWidth-1:
					newMesh.mesh = load("res://grass/relevant/grass_3.obj")
				else:
					newMesh.mesh = load("res://grass/relevant/grass_2.obj")
			else:
				newMesh.mesh = meshRef
			newMesh.translate(Vector3(0-(mapWidth-1)+((i%mapWidth)*2),int((i/mapWidth)*-2),0))
			if i==4:
				newMesh.set_rotation_degrees(Vector3(0,180,0))
				#newMesh.set_rotation_degrees(Vector3(0,90,0))
			newMesh.set_surface_material(0,mat0Ref)
			newMesh.set_surface_material(1,mat1Ref)
			gameMap.push_back(newMesh)
			damageMap.push_back(1000)
			add_child(gameMap[i])
		else:
			newMesh.mesh = load("res://ore/iron ore.obj")
			newMesh.translate(Vector3(0-(mapWidth-1)+((i%mapWidth)*2),int((i/mapWidth)*-2),0))
			newMesh.set_rotation_degrees(Vector3(0,270,0))
			newMesh.set_surface_material(0,mat1Ref)
			newMesh.set_surface_material(1,mat2Ref)
			gameMap.push_back(newMesh)
			damageMap.push_back(1000)
			add_child(gameMap[i])

#called to dig by moving the player and/or damaging/removing blocks
func dig(damage):
	#print(int(get_tree().get_nodes_in_group("player")[0].translation.x+(mapWidth/2.0)+((mapWidth*(get_tree().get_nodes_in_group("player")[0].translation.y-1)*-1))))
	#print("damage: "+str(damage))
	
	#TODO: fix which block gets deleted when gyroscope
	var index = int((get_tree().get_nodes_in_group("player")[0].translation.x/2)+(mapWidth/2.0)+(((mapWidth)*((get_tree().get_nodes_in_group("player")[0].translation.y-1)/2)*-1)))
	if (index>=0 && index<gameMap.size() && gameMap[index]!=null):
		damageMap[index] -= damage
		if (damageMap[index]<=0):
			gameMap[index].get_parent().remove_child(gameMap[index])
			damageMap[index] = 0
			get_tree().get_nodes_in_group("player")[0].translation.y-=2
			get_tree().get_nodes_in_group("cam")[0].translation.y-=2
			self.get_node("../auger").translation.x = get_tree().get_nodes_in_group("player")[0].translation.x
			self.get_node("../auger").translation.y = get_tree().get_nodes_in_group("player")[0].translation.y+0.1
			print(get_tree().get_nodes_in_group("player")[0].translation.y)

#called to clear the command chain early
func clearChain():
	if (notes.size()>0):
		for i in range(notes.size()):
			chain.remove_child(notes[i])
		notes = []
		notesCleared = 0
		runningIndex = 0
		runningClear = true
		
#called to change the grader sprite
func handle_grader(pos):
	#pos is relative to center of the hitbar
	if (pos>-step && pos<step):
		grader.texture = grade_perfect
		runningChainClear = true
		popplayer.play(0)
		canWalk = false
		experience+=level*400
		dig(level*400)
	elif (pos>step*-2 && pos<step*2):
		grader.texture = grade_cool
		runningChainClear = true
		popplayer.play(0)
		canWalk = false
		experience+=level*300
		dig(level*300)
	elif (pos>step*-4 && pos<step*4):
		grader.texture = grade_ok
		runningChainClear = true
		popplayer.play(0)
		canWalk = false
		experience+=level*200
		dig(level*200)
	elif (pos>step*-8 && pos<step*8):
		grader.texture = grade_bad
		runningChainClear = true
		popplayer.play(0)
		canWalk = false
		experience+=level*100
		dig(level*100)
	else:
		grader.texture = grade_miss
		runningChainClear = true
		floatLevel = 0
		canWalk = true
	gradeTimer=20
	clearChain()

func handle_touch(fingers):
	if (notesCleared<level && level > 0):
		match notes[notesCleared].texture:
				noteI:
					if (fingers == 1):
						notes[notesCleared].texture = noteIclear
						notesCleared += 1
						runningClear = true
						runningIndex = 0
						kickplayer.play(0)
				noteII:
					if (fingers == 2):
						notes[notesCleared].texture = noteIIclear
						notesCleared+=1
						runningClear = true
						runningIndex = 0
						kickplayer.play(0)
				noteIII:
					if (fingers == 3):
						notes[notesCleared].texture = noteIIIclear
						notesCleared+=1
						runningClear = true
						runningIndex = 0
						kickplayer.play(0)
				noteIV:
					if (fingers == 4):
						notes[notesCleared].texture = noteIVclear
						notesCleared += 1
						runningClear = true
						runningIndex = 0
						kickplayer.play(0)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	var line = hitbar.rect_position.y #touching below this line enters commands, touching above submits the chain
	if event is InputEventScreenTouch:
		if event.pressed:
			runningClear = false
			if event.index==0 && event.position.y>line:
				#this means a new set of touches is happening, so reset touches
				runningIndex = 1
			elif event.position.y>line:
				runningIndex+=1
			if event.position.y<line && notesCleared == level && level >0:
				#change grade depending on position
				handle_grader(hitmeter.rect_position.x-512)
			#else:
				#label.text = ""

func _process(delta):
	
	#update experience label
	label.text = "exp: "+str(experience)
	
	#handle grade
	if gradeTimer==0:
		grader.texture=grade_blank
	if gradeTimer>-1:
		gradeTimer-=1
	
	#handle notes
	if !runningClear:
		handle_touch(runningIndex)
		
	#hitmeter
	step = bpms[currentTrack]/60.0/60.0*256.0 #the number of pixels the hitmeter moves per frame
	if (fmod(hitmeter.rect_position.x,256.0)<step):
		hitmeter.rect_scale.x = 2
		hitmeter.rect_scale.y = 2
		hitbox.scale.x = 0.40
		hitbox.scale.y = 0.40
	else:
		hitmeter.rect_scale.x = 1
		hitmeter.rect_scale.y = 1
		hitbox.scale.x = 0.25
		hitbox.scale.y = 0.25
	hitmeter.rect_position.x += step
	
		#min 520
		#max 592
	if (fmod(hitmeter.rect_position.x,592)<step):
		if (!runningChainClear&&level>0):
			canWalk = true
			grader.texture = grade_miss
			gradeTimer=20
			floatLevel = 0
		floatLevel+=accumulation
		level = int(floatLevel)
		sizeUpdate = true
		runningChainClear = false
	elif (hitmeter.rect_position.x > 1024):
		hitmeter.rect_position.x = hitmeter.rect_position.x-1024
		
	#chain
	if (level == 10):
		floatLevel = 1
		level = int(floatLevel)
		sizeUpdate = true
		
	if (sizeUpdate): #if the size has been updated, we need to reinitiate the command chain
		sizeUpdate = false
		#print(floatLevel)
		for i in range(notes.size()):
			chain.remove_child(notes[i])
		notes = []
		notesCleared = 0
		runningIndex = 0
		runningClear = true
		#label.text = ""
		for i in range(level):
			var inst = notescene.instance()
			var skin;
			if (weTesting):
				skin = 1
			else:
				skin = randi()%5+1
			match skin:
				1:
					inst.texture = noteI
				2:
					inst.texture = noteII
				3:
					inst.texture = noteIII
				4:
					inst.texture = noteIV
			chain.add_child(inst)
			notes.append(inst)
		
		#player animations
#	if clear and Input.is_action_pressed("input_mine"):
#		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("walk").set_loop(false)
#		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("walk",-1,2)
#		clear = false
#	if !clear && get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").current_animation!="walk":
#		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("rest").set_loop(false)
#		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("rest")
#	if (!clear && !Input.is_action_pressed("input_mine") && get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").current_animation!="left"):
#		clear = true
		
	#player gyro movement
	
	if Input.get_accelerometer().x > 1 && canWalk:
		get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,90,0))
		get_tree().get_nodes_in_group("player")[0].translate(Vector3(0,0,0.5))
		get_tree().get_nodes_in_group("cam")[0].translation.x = get_tree().get_nodes_in_group("player")[0].translation.x
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("walk").set_loop(false)
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("walk",-1,2)
	elif Input.get_accelerometer().x < -1 && canWalk:
		get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,270,0))
		get_tree().get_nodes_in_group("player")[0].translate(Vector3(0,0,0.5))
		get_tree().get_nodes_in_group("cam")[0].translation.x = get_tree().get_nodes_in_group("player")[0].translation.x
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("walk").set_loop(false)
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("walk",-1,2)
	else:
		if (canWalk):
			get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,0,0))
			get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("rest").set_loop(false)
			get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("rest",-1,2)
		else:
			get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,0,0))
			get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("boogie").set_loop(false)
			get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("boogie",-1,2)
	

func _on_AudioStreamPlayer_finished():
	currentTrack+=1
	audioplayer.stream = songs[currentTrack]
	audioplayer.play()
	floatLevel = 0
	experience+=10000

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "boogie":
		canWalk = true
	else:
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play(anim_name,-1,2)
