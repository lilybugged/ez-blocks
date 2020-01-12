extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0):
		get_tree().get_nodes_in_group("water")[i].get_node("AnimationPlayer").get_animation("default").set_loop(true)
		get_tree().get_nodes_in_group("water")[i].get_node("AnimationPlayer").play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
