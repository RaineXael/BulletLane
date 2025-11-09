class_name Player
extends CharacterBody2D

@onready var graze_sound:AudioStreamPlayer = $GrazeSFX
@onready var hurt_sound:AudioStreamPlayer = $HurtSFX
@onready var bullet_prefab = load("res://prefabs/player/bullet.tscn")
@onready var spr = $SpriteContainer/Sprite
@onready var sprite_container = $SpriteContainer
@onready var anim = $AnimationPlayer
const SPEED = 145.0
const FOCUS_SPEED = 60.0
const JUMP_VELOCITY = -400.0
var lives = 3
@onready var graze_sprite = $Hitbox/CollisionShape2D/Sprite2D
@onready var score_label = $CanvasLayer/Control/Label


var score := 0

const DODGE_TIME = 0.18
const DODGE_COOLDOWN = 0.8
const DODGE_SPEED = 380.0
var prev_direction = 1.0

@export var bullet_speed = 500.0

var stop_time = 0.0
const HIT_STUN = 0.3
var dodge_time = 0.0
var dodge_cooldown = 0.0
var dodging = false
var shot_timer = 0.0

var invincibility_timer = 0.0
const INVINCIBILITY_TIME = 1.5
@export var shot_time = 0.1
func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	if stop_time > 0:
		stop_time -= delta
	else:
		if dodge_time > 0:
			dodge_time -= delta
		else:
			if dodging:
				dodging = false
				dodge_cooldown = DODGE_COOLDOWN
			
		if dodge_cooldown > 0:
			dodge_cooldown -= delta
		if invincibility_timer > 0:
			invincibility_timer -= delta
			sprite_container.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			sprite_container.modulate = Color(1.0, 1.0, 1.0, 1.0)
		#print(dodging)

		if Input.is_action_pressed('dodge'):
			if not dodging and dodge_cooldown <= 0:
				dodging = true
				$DashSFX.play()
				print('dodgeing')
				anim.play('dodge')
				dodge_time = DODGE_TIME
		graze_sprite.visible = Input.is_action_pressed('focus')
			
		if Input.is_action_just_pressed('fire'):
			shot_timer = 0.0
			
		if Input.is_action_pressed("fire"):
			shot_timer -= delta
			if shot_timer <= 0:
				shot_timer = shot_time
				spawn_bullet_to_cursor()
		if prev_direction > 0:
			spr.flip_h = false
		elif prev_direction < 0:
			spr.flip_h = true
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if dodging:
			velocity.x = prev_direction * DODGE_SPEED
		else:
			
			var direction := Input.get_axis("left", "right")
			if direction:
				if Input.is_action_pressed('focus'):
					velocity.x = direction * FOCUS_SPEED
				else:
					velocity.x = direction * SPEED
				prev_direction = direction
				anim.play('run')
			else:
				anim.play('idle')
				velocity.x = move_toward(velocity.x, 0, SPEED)
				
		move_and_slide()
	
func on_hit_with_bullet():
	if not dodging and not invincibility_timer > 0:
		lives -= 1
		hurt_sound.play()
		stop_time = HIT_STUN
		anim.play('hurt')
		invincibility_timer = INVINCIBILITY_TIME
		if lives <= 0:
			print('Your game is over!!! DIE!!!!!')
		
	print('The plkayer is fuckign dead!!!!! ')


func _on_hitbox_area_entered(area: Area2D) -> void:
	
	if area is Bullet:
		if area.type != 'player':
			on_hit_with_bullet()
			area.queue_free()
func spawn_bullet_to_cursor():
	var bullet = bullet_prefab.instantiate()
	bullet.type = 'player'
	print(get_parent())
	bullet.speed = bullet_speed
	bullet.global_position = global_position
	var dirvec = (get_mouse_world_pos()- global_position).normalized()
	bullet.set_color(Color(0.694, 0.388, 0.192, 1.0))
	bullet.angle = atan2(dirvec.y,dirvec.x)
	get_parent().add_child(bullet)
	$ShootSFX.play()
	
func get_mouse_world_pos() -> Vector2:
	return get_viewport().get_mouse_position()


func _on_graze_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if area.type == 'enemy' and not area.grazed and not invincibility_timer > 0 and not dodging:
			area.grazed = true
			add_score(5)
			graze_sound.play()



func add_score(add:int):
	score += add #do some cool anim or w/e
	score_label.text = "%0*d" % [7, score]

func _on_dodge_swipe_hitbox_area_entered(area: Area2D) -> void:
	if area is Bullet:
		if area.type == 'enemy' and dodging:
				#convert the bullets to the bouncy bois
				#for now
				area.queue_free()
				pass


func _on_button_pressed() -> void:
	pass # Replace with function body.
