extends CharacterBody2D

var SPEED = 100.0
var player_state

signal stick_collected
signal slime_collected
signal apple_collected

@export var inv: Inventory

var bow_equiped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_locattion = null

@onready var camera = $Camera2D

func _physics_process(delta: float) -> void:
	mouse_locattion = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 and direction.y != 0:
		player_state = "walking"
	
	velocity = direction * SPEED
	move_and_slide()
	
	if Input.is_action_just_pressed("arrow"):
		if bow_equiped:
			bow_equiped = false
		else:
			bow_equiped = true
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("mouse_left") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
	
	player_anim(direction)

func player_anim(dir):
	SPEED = 100
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
			
	if bow_equiped:
		SPEED = 0
		if mouse_locattion.x >= -25 and mouse_locattion.x <= 25 and mouse_locattion.y < 0:
			$AnimatedSprite2D.play("n_attack")
		if mouse_locattion.y >= -25 and mouse_locattion.y <= 25 and mouse_locattion.x > 0:
			$AnimatedSprite2D.play("e_attack")
		if mouse_locattion.x >= -25 and mouse_locattion.x <= 25 and mouse_locattion.y > 0:
			$AnimatedSprite2D.play("s_attack")
		if mouse_locattion.y >= -25 and mouse_locattion.y <= 25 and mouse_locattion.x < 0:
			$AnimatedSprite2D.play("w_attack")
			
		if mouse_locattion.x >= 25 and mouse_locattion.y <= -25:
			$AnimatedSprite2D.play("ne_attack")
		if mouse_locattion.x >= 0.5 and mouse_locattion.y >= 25:
			$AnimatedSprite2D.play("se_attack")
		if mouse_locattion.x <= -0.5 and mouse_locattion.y >= 25:
			$AnimatedSprite2D.play("sw_attack")
		if mouse_locattion.x <= -25 and mouse_locattion.x <= -25:
			$AnimatedSprite2D.play("nw_attack")


func player():
	pass

func collect(item):
	if inv:
		inv.insert(item)
		print(item)
		
		match item.resource_path:
			"res://inventoryitems/stick.tres":
				emit_signal("stick_collected")
			"res://inventoryitems/slime.tres":
				emit_signal("slime_collected")
			"res://inventoryitems/apple.tres":
				emit_signal("apple_collected")

	else:
		print("Inventory is null! Assign it in the Player Inspector.")
