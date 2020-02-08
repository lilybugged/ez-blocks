extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_node("AnimationPlayer").get_animation("auger_on").set_loop(true)
	self.get_node("AnimationPlayer").play("auger_on",-1,2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
