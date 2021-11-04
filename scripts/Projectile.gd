extends Area2D


export (int) var speed = 600
export (int) var damage = 25
onready var mouse_position = get_viewport().get_mouse_position() 
var direction

func _ready():
	connect("body_entered",self,"_body_entered")
	look_at(mouse_position)
	direction = (mouse_position - position).normalized()
	 
func _physics_process(delta):
	position +=  delta * direction * speed

func _on_screen_exit():
	queue_free()
