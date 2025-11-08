class_name Bullet
extends Area2D

@export_enum('enemy','player') var type

@export var angle = 0.0
@export var speed = 0
@export var damage = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(cos(angle),sin(angle)) * delta * speed
