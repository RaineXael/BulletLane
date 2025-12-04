extends Control

@onready var main_scene = $SubViewportContainer/SubViewport
@onready var player = $SubViewportContainer/SubViewport/Player
func add_child_to_main_scene(child:Node):
	main_scene.add_child(child)
