extends Node2D

@onready var animplayer = $wolrd2_cutscene/AnimationPlayer
@onready var camera = $wolrd2_cutscene/Path2D/PathFollow2D/Camera2D

var is_opening  = false
var is_path_following = false

var player_in_area = false
var player = null

var smoke_happend = false
var smoke_happening = false

func _physics_process(delta: float) -> void:
	if is_opening:
		var path_follower = $wolrd2_cutscene/Path2D/PathFollow2D
		
		if is_path_following:
			if !smoke_happening:
				path_follower.progress_ratio += 0.001
			
			if path_follower.progress_ratio >= 1:
				cutsceneClosing()
				
			if !smoke_happend and path_follower.progress_ratio >= 0.76 and !smoke_happening:
				smoke_happening = true
				toggle_smoke()
				
				await get_tree().create_timer(1.0).timeout
				$wolrd2_cutscene/Finished.visible = true
				$wolrd2_cutscene/Un_Finished.visible = false
				toggle_smoke()
				
				await get_tree().create_timer(0.5).timeout
				smoke_happend = true
				smoke_happening = false

func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		
		if !player_in_area:
			player_in_area = true
			cutsceneOpening()

func cutsceneOpening():
	is_opening = true
	animplayer.play("cover_fade")
	player.camera.enabled = false
	camera.enabled = true
	is_path_following = true
	
func cutsceneClosing():
	is_path_following = false
	is_opening = false
	camera.enabled = false
	player.camera.enabled = true
	$wolrd2_cutscene.visible = false
	$World2_Main.visible = true
	
func toggle_smoke():
	var smoke1 = $wolrd2_cutscene/Smoke_Particle1
	var smoke2 = $wolrd2_cutscene/Smoke_Particle2
	
	smoke1.emitting = !smoke1.emitting
	smoke2.emitting = !smoke2.emitting
		
