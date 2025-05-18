extends Node2D

@onready var animplayer = $wolrd2_cutscene/AnimationPlayer
@onready var camera = $wolrd2_cutscene/Path2D/PathFollow2D/Camera2D
@onready var path_follower = $wolrd2_cutscene/Path2D/PathFollow2D

var is_opening  = false
var is_path_following = false

var player_in_area = false
var player = null

var smoke_happened = false
var smoke_happening = false

func _physics_process(delta: float) -> void:
	if is_opening and is_path_following:
		if !smoke_happening:
			path_follower.progress_ratio += 0.001

		if path_follower.progress_ratio >= 0.76 and !smoke_happened and !smoke_happening:
			await play_smoke_event()

		if path_follower.progress_ratio >= 1.0:
			cutsceneClosing()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player") and !player_in_area:
		player_in_area = true
		player = body
		cutsceneOpening()

func cutsceneOpening():
	is_opening = true
	is_path_following = true
	animplayer.play("cover_fade")
	
	if player:
		player.camera.enabled = false

	camera.enabled = true
	$wolrd2_cutscene.visible = true

func cutsceneClosing():
	is_path_following = false
	is_opening = false
	camera.enabled = false
	
	if player:
		player.camera.enabled = true
	
	$wolrd2_cutscene.visible = false
	$World2_Main.visible = true
	
	# Optional: Delay before switching scene
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://path_to_next_scene.tscn")

func toggle_smoke():
	var smoke1 = $wolrd2_cutscene/Smoke_Particle1
	var smoke2 = $wolrd2_cutscene/Smoke_Particle2
	smoke1.emitting = !smoke1.emitting
	smoke2.emitting = !smoke2.emitting

func play_smoke_event():
	smoke_happening = true
	toggle_smoke()

	await get_tree().create_timer(1.0).timeout
	$wolrd2_cutscene/Finished.visible = true
	$wolrd2_cutscene/Un_Finished.visible = false
	toggle_smoke()

	await get_tree().create_timer(0.5).timeout
	smoke_happened = true
	smoke_happening = false
