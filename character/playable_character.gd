extends CharacterBody2D


const speed = 400
const acceleration = 10

var key_is_pressed = false

const JUMP_VELOCITY = -400.0
@onready var character_sprite = $CharacterSprite


var starting_run = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#print(delta)
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
	print(velocity.x)
	if (velocity.x > 2):
		if(key_is_pressed):
			character_sprite.play("move_forward")
		else:
			character_sprite.play("forward_decelerate")
		#character_sprite.animation = "move_forward"
	elif (velocity.x < -2):
		character_sprite.play("move_backward")
	else:
		character_sprite.play("idle")
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	key_is_pressed = false
	if (Input.is_action_pressed("ui_right")):
		key_is_pressed = true
		velocity.x = min(velocity.x + acceleration, speed)
	elif (Input.is_action_pressed("ui_left")):
		velocity.x = max(velocity.x - acceleration, -speed)
	else:
		velocity.x = lerp(velocity.x,0.0,0.05)
	
	#print(direction)
	#if(starting_run):
		#if direction:
			#velocity.x = direction * speed
		#else:
			#velocity.x = move_toward(velocity.x, 0, speed)
	move_and_slide()


func _on_character_sprite_animation_looped():
	var animation = character_sprite.animation
	var list_animations = ["move_forward","move_backward","forward_decelerate"]
	if(animation in list_animations):
		starting_run = true
		character_sprite.frame = character_sprite.sprite_frames.get_frame_count(character_sprite.animation)
