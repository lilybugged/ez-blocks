extends MultiMeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(40):
		if (x<10):
			self.multimesh.set_instance_transform(x,Transform(Basis(), Vector3(-10+(2*x),0.0,0)))
#		else:
#			self.multimesh.set_instance_transform(x,Transform(Basis().rotated(Vector3(1, 0, 0), 0.5*PI), Vector3(-10+(2*((x-10)%10)),2*(x/10),-2)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
