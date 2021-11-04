extends Node2D

const DEFAULT_SPEED = 8000
const JUMP_SPEED = 1000*35
const FRICTION = 20 
const GRAVITY = 1000

export (int) var player_number = 1
export (PackedScene) var Player = preload("res://Zeus.tscn")
export (PackedScene) var AI = preload("res://AI.tscn")
var velocity = Vector2.ZERO
var knock_back = Vector2.ZERO
var speed = 8000
var player
var player_group

func _ready():
	player = Player.instance()
	var hurtbox = player.get_node("HurtBox")
	hurtbox.connect("die", self, "_die")
	
	player_group = "player"+str(player_number)
	player.add_to_group(player_group)
	self.add_child(player)	
	
	if player_number == 1:
		player.global_transform = get_parent().get_node("Player1Spawn").global_transform
	else:
		player.global_transform = get_parent().get_node("Player2Spawn").global_transform
		var ai = AI.instance()
		player.add_child(ai)
	
	get_tree() \
		.get_nodes_in_group("player" + str(player_number))[0] \
		.connect("spawn_flag", self, "_on_spawn_flag")

func _on_spawn_flag():
	speed = DEFAULT_SPEED

func _physics_process(delta):
	if player_number == 1:
		if Input.is_action_pressed("move_right"):
			player.scale.x = player.scale.y * 1
			player.get_node("SpritePlayer").play("move")
			velocity.x += speed * delta
		elif Input.is_action_pressed("move_left"):
			player.scale.x = player.scale.y * -1
			player.get_node("SpritePlayer").play("move") 
			velocity.x -= speed * delta
		elif Input.is_action_just_pressed("attack"):
			player.get_node("SpritePlayer").play("attack")
		elif Input.is_action_just_pressed("attack_ranged"):
			player.get_node("SpritePlayer").play("attack_ranged")
			yield(player.get_node("SpritePlayer"), "animation_finished")
			
			if player.get_node("SpritePlayer").assigned_animation == "attack_ranged":
				var player_projectile = player.Projectile
				var projectile = player_projectile.instance()
				projectile.add_to_group(player_group)
				projectile.transform = player.get_global_transform()
				get_tree().get_root().add_child(projectile)
		elif !player.get_node("SpritePlayer").is_playing():
			player.get_node("SpritePlayer").play("idle")
			
	if player_number == 2:
		if Input.is_action_pressed("move_right_p2"):
			player.scale.x = player.scale.y * 1
			player.get_node("SpritePlayer").play("move")
			velocity.x += speed * delta
		elif Input.is_action_pressed("move_left_p2"):
			player.scale.x = player.scale.y * -1
			player.get_node("SpritePlayer").play("move") 
			velocity.x -= speed * delta
		elif Input.is_action_just_pressed("attack_p2"):
			player.get_node("SpritePlayer").play("attack")
		elif Input.is_action_just_pressed("attack_ranged_p2"):
			player.get_node("SpritePlayer").play("attack_ranged")
			yield(player.get_node("SpritePlayer"), "animation_finished")
			
			if player.get_node("SpritePlayer").assigned_animation == "attack_ranged":
				var player_projectile = player.Projectile
				var projectile = player_projectile.instance()
				projectile.add_to_group(player_group)
				projectile.transform = player.get_global_transform()
				get_tree().get_root().add_child(projectile)
		elif !player.get_node("SpritePlayer").is_playing():
			player.get_node("SpritePlayer").play("idle")
	
	velocity.y += GRAVITY * delta
	knock_back = lerp(knock_back, Vector2.ZERO, 2  * delta)
	velocity.x = lerp(velocity.x, 0, FRICTION * delta)
	velocity = player.move_and_slide(velocity + knock_back,Vector2.UP)
	
	if player_number == 1:
		if Input.is_action_just_pressed("jump"):
			if player.is_on_floor():
				$AudioJump.play()
				player.get_node("SpritePlayer").play("jump")
				velocity.y -= JUMP_SPEED * delta 
				
	if player_number == 2:
		if Input.is_action_just_pressed("jump_p2"):
			if player.is_on_floor():
				$AudioJump.play()
				player.get_node("SpritePlayer").play("jump")
				velocity.y -= JUMP_SPEED * delta 
			
	for i in player.get_slide_count():
		var collision = player.get_slide_collision(i).collider

		if collision.is_in_group("flag"):
			speed = speed / 2
			collision.queue_free()
			var flag = preload("res://Flag.tscn").instance()
			flag.get_node("Mask").disabled = true    
			player.get_node("Sprite").get_node("FlagMarker").add_child(flag)
			
func _die():	
	$AudioDeath.play()
	self.remove_child(player)	
	yield(get_tree().create_timer(5.0), "timeout")
			
	if player_number == 1:
		self.add_child(player)
		player.global_transform = get_parent().get_node("Player1Spawn").global_transform
		Global.player1_health = 100
	else:
		self.add_child(player)
		player.global_transform = get_parent().get_node("Player2Spawn").global_transform
		Global.player2_health = 100
			
			
			



