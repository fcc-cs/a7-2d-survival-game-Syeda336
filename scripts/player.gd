extends CharacterBody2D

var SPEED = 100.0
var player_state

@export var inv: Inventory


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 and direction.y != 0:
		player_state = "walking"
	
	velocity = direction * SPEED
	move_and_slide()
	
	player_anim(direction)

func player_anim(dir):
	if player_state == "idle":
		$AnimatedSprite2D.play("idle")
	if player_state == "walking":
		if dir.y == -1:
			$AnimatedSprite2D.play("north_walk")
		if dir.x == 1:
			$AnimatedSprite2D.play("east_walk")
		if dir.y == 1:
			$AnimatedSprite2D.play("south_walk")
		if dir.x == -1:
			$AnimatedSprite2D.play("west_walk")
			
		if dir.x > 0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("north_east_walk")
		if dir.x > 0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("south_east_walk")
		if dir.x < -0.5 and dir.y > 0.5:
			$AnimatedSprite2D.play("south_west_walk")
		if dir.x < -0.5 and dir.y < -0.5:
			$AnimatedSprite2D.play("north_west_walk")

func player():
	pass
	
