extends Area2D

var path
var dir = 1
var player
var player_controller
var path_index = 0
var move_speed = 200
var rng = RandomNumberGenerator.new()
const JUMP_SPEED = 1000*35

func _ready():
	var level = get_tree().get_nodes_in_group("level")[0]
	var ai_path = level.get_node("AIPath")
	path = ai_path.curve.get_baked_points()
	player = get_parent()
	player_controller = player.get_parent()
	rng.randomize()
	
func _physics_process(delta):	
	var target = path[path_index]
		
	if player.position.distance_to(target) <= 200:	
		if path_index == path.size()-1:
			dir = -1
		if path_index == 0:
			dir = 1
		path_index += dir 
		
		target = path[path_index]
		
	if player_controller.velocity.x >= 0:
		player.scale.x = player.scale.y * 1
	else:
		player.scale.x = player.scale.y * -1
	
	if rng.randi_range(1,200) == 44 and player.is_on_floor():
		player_controller.velocity.y -= JUMP_SPEED * delta
	
	player_controller.velocity.x = (target - player.position).normalized().x * move_speed
	player_controller.velocity = player.move_and_slide(player_controller.velocity, Vector2.UP)

	player.get_node("SpritePlayer").play("move")
		
func _on_AI_body_entered(body):
	pass
