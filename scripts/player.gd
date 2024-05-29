extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_fishing = false
var can_fish = false
var fish_animation_finished = false
var hook_animation_finished = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_water = $RayCastWater
@onready var ray_cast_ground = $RayCastGround


func _ready():
	# Conecta o sinal "animation_finished" do AnimatedSprite2D ao método _on_animated_sprite_2d_animation_finished
	animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)

func _process(delta):
	
	if ray_cast_water.is_colliding() and not ray_cast_ground.is_colliding():
		can_fish = true
	else:
		can_fish = false
		
	
	if can_fish: 
		if Input.is_action_just_pressed("fish"):
			if is_fishing:
				animated_sprite.play("hook")
			else:
				animated_sprite.play("fish")
				is_fishing = true
			fish_animation_finished = false
		elif is_fishing and fish_animation_finished:
			animated_sprite.play("fishing")

func _physics_process(delta):
	
	if is_fishing:
		return
	
	addGravity(delta)
	handleJump()

	var direction = Input.get_axis("move_left", "move_right")
	
	handleAnimations(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


#Aux Functions

func addGravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handleJump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func handleAnimations(direction):
	if is_fishing:
		return
		
	if direction > 0:
		animated_sprite.play("walk")
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.play("walk")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
		









func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "fish":
		fish_animation_finished = true
	elif animated_sprite.animation == "hook":
		is_fishing = false
