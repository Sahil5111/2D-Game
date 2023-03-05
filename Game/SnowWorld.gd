extends Node2D
const player = preload("res://Player/2Dplayer.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_2Dplayer_create_clone(position):
	var clone_node = player.instance()
	clone_node.position = position
	var ysort = get_node("YSort")
	ysort.add_child(clone_node)
