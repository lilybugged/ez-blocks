extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var newMesh:MeshInstance
	self.mesh = PlaneMesh.new()
	newMesh = MeshInstance.new()
	newMesh.translate(Vector3(3,0,0))
	newMesh.mesh = PlaneMesh.new()
	add_child(newMesh)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
