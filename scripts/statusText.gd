extends Label
onready var opacity = 255
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rect_position.y+=1
	self.add_color_override("font_color", Color(1,1,1,(opacity/255.0)))
	self.add_color_override("font_color_shadow", Color(17/255.0,7/255.0,34/255.0,(opacity/255.0)))
	opacity-=1
	if (opacity<1):
		get_parent().remove_child(self)
