extends Area2D


signal spawn_flag

func _on_Dropzone_body_entered(body):
	if body.is_in_group("player"):	
		var flag = body.get_node("Sprite").get_node("FlagMarker").get_node("Flag")
		
		if flag:	
			if body.is_in_group("player1") and self.is_in_group("player1"):
				Global.player1_score += 1
				flag.queue_free()
				emit_signal("spawn_flag")
			elif body.is_in_group("player2") and self.is_in_group("player2"):
				Global.player2_score += 1
				flag.queue_free()
				emit_signal("spawn_flag")
