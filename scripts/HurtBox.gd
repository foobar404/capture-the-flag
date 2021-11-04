extends Area2D


signal die

func _on_HurtBox_area_entered(area):
	if area.is_in_group("damage"):
#		var dir = (self.position - area.position).normalized()
		var is_player_damage = false
		var health
		
		# player and projectile damage
		var src_groups = area.get_parent().get_groups() + area.get_groups()
		var src_is_player1 = src_groups.find("player1")
		var src_is_player2 = src_groups.find("player2")
		
		var dest_groups = self.get_parent().get_groups()
		var dest_is_player1 = dest_groups.find("player1")
		var dest_is_player2 = dest_groups.find("player2")
		
		if src_is_player1 != -1 and dest_is_player2 != -1:
			is_player_damage = true
			Global.player2_health -= 5
			health = Global.player2_health 
		if src_is_player2 != -1 and dest_is_player1 != -1:
			is_player_damage = true
			Global.player1_health -= 5
			health = Global.player1_health
			
		if not is_player_damage:
			return 

#		self.get_parent().get_parent().knock_back = dir * 500
		
		if self.has_node("../Sprite/FlagMarker/Flag"):
			var flag = self.get_node("../Sprite/FlagMarker/Flag")
			self.get_node("../Sprite/FlagMarker").remove_child(flag)
			get_tree().get_root().add_child(flag)
			flag.global_transform = self.global_transform
			
			yield(get_tree().create_timer(1.0), "timeout")
			flag.get_node("Mask").disabled = false
			
		if health <= 0:
			emit_signal("die")
			return 
			
		$AudioHit.play()
	
		
