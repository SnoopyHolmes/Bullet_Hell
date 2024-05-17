extends RigidBody2D

signal lose_life

enum COLOR {
	CYAN,
	MAGENTA
}

@export var currentColor: COLOR
@export var initialSpeed: float

var playerPaddle: Node2D
var speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	playerPaddle = get_node("/root/Main/Player")
	speed = initialSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var paddlePos = Vector2(playerPaddle.position.x, playerPaddle.position.y + 40)
	position = position.lerp(paddlePos, speed * delta)
	
	if Input.is_action_just_pressed("shift"):
		shift()


@export var bullet_hit_callable = func(body):
	lose_life.emit()
		
		
func shift():
	if currentColor == COLOR.CYAN:
		currentColor = COLOR.MAGENTA
		set_collision_layer_value(2,false)#sets ship and paddle collision cyan to false
		set_collision_layer_value(3,false)
		
		set_collision_layer_value(1,true)#sets ship and paddle collision magenta to true
		set_collision_layer_value(4,true)
		
		set_collision_mask_value(5,false) #sets enemy collision
		set_collision_mask_value(6,true)
		
		set_collision_mask_value(7,false) #sets bullet collision
		set_collision_mask_value(8,true)
	
	elif currentColor == COLOR.MAGENTA:
		currentColor = COLOR.CYAN
		set_collision_layer_value(1,false)#sets ship and paddle collision magenta to false
		set_collision_layer_value(4,false)
		
		set_collision_layer_value(2,true)#sets ship and paddle collision cyan to true
		set_collision_layer_value(3,true)
		
		set_collision_mask_value(5,true) #sets enemy collision
		set_collision_mask_value(6,false)
		
		set_collision_mask_value(7,true) #sets bullet collision
		set_collision_mask_value(8,false)
	


func _on_player_player_died():
	queue_free()


func update_powerup(powerup = 0):
	if powerup == 6: 
		apply_scale(Vector2(0.5, 0.5))
	elif powerup != 6 and (scale.x <= 0.5 and scale.y <= 0.5): # If the player has no powerup, do this:
		apply_scale(Vector2(2, 2))
		
	if powerup == 3:
		speed = initialSpeed * 5
	elif powerup != 3:
		speed = initialSpeed
