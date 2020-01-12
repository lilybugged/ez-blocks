extends Spatial 

const meshRef = preload("res://grass/relevant/grass_0.obj")
const mat0Ref = preload("res://grass/relevant/grass.material")
const mat1Ref = preload("res://grass/relevant/dirt.material")
const mat2Ref = preload("res://shirt2.material")
var clear = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	var gameMap = []
#	for i in range(20):
#		var num = randi()%10
#		var newMesh = MeshInstance.new()
#
#		if num != 0 or i<5:
#			if i < 5:
#				if i==0 or i==4:
#					newMesh.mesh = load("res://grass/relevant/grass_3.obj")
#				else:
#					newMesh.mesh = load("res://grass/relevant/grass_2.obj")
#			else:
#				newMesh.mesh = meshRef
#			newMesh.translate(Vector3(0-4+((i%5)*2),int((i/5)*-2),0))
#			if i==4:
#				newMesh.set_rotation_degrees(Vector3(0,180,0))
#				#newMesh.set_rotation_degrees(Vector3(0,90,0))
#			newMesh.set_surface_material(0,mat0Ref)
#			newMesh.set_surface_material(1,mat1Ref)
#			gameMap.push_back(newMesh)
#			add_child(gameMap[i])
#		else:
#			newMesh.mesh = load("res://ore/iron ore.obj")
#			newMesh.translate(Vector3(0-4+((i%5)*2),int((i/5)*-2),0))
#			newMesh.set_rotation_degrees(Vector3(0,270,0))
#			newMesh.set_surface_material(0,mat1Ref)
#			newMesh.set_surface_material(1,mat2Ref)
#			gameMap.push_back(newMesh)
#			add_child(gameMap[i])

func _process(delta):
	
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
	
	if Input.get_accelerometer().x > 1:
		get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,90,0))
		get_tree().get_nodes_in_group("player")[0].translate(Vector3(0,0,0.5))
		get_tree().get_nodes_in_group("cam")[0].translation.x = get_tree().get_nodes_in_group("player")[0].translation.x
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("walk").set_loop(false)
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("walk",-1,2)
	elif Input.get_accelerometer().x < -1:
		get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,270,0))
		get_tree().get_nodes_in_group("player")[0].translate(Vector3(0,0,0.5))
		get_tree().get_nodes_in_group("cam")[0].translation.x = get_tree().get_nodes_in_group("player")[0].translation.x
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("walk").set_loop(false)
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("walk",-1,2)
	else:
		get_tree().get_nodes_in_group("player")[0].set_rotation_degrees(Vector3(0,0,0))
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").get_animation("rest").set_loop(false)
		get_tree().get_nodes_in_group("player")[0].get_node("AnimationPlayer").play("rest",-1,2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
