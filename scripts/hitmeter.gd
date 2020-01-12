extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (int(round(self.rect_position.x/10)*10)%120 == 0):
		self.rect_scale.x=1.5
		self.rect_scale.y=1.5
	else:
		self.rect_scale.x=1
		self.rect_scale.y=1
	if (self.rect_position.x>993):
		self.rect_position.x = 3
	else:
		self.rect_position.x += 5