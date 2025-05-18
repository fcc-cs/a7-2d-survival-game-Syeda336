extends Node2D

var player_in_area = false
var player = null

func _on_detection_of_player_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_in_area = true
		
		$new_wolrd2_cutscene/Smoke_Particle1.emitting = false
		$new_wolrd2_cutscene/Smoke_Particle2.emitting = false
		
