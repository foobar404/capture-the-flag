extends Node2D


onready var Flag = load("res://Flag.tscn")

func _ready():
	var flag = Flag.instance()
	$FlagSpawnPoint.add_child(flag)
	$AnimationPlayer.play("float")

func _on_P1Dropzone_spawn_flag():
	var flag = Flag.instance()
	$FlagSpawnPoint.add_child(flag)

func _on_P2Dropzone_spawn_flag():
	var flag = Flag.instance()
	$FlagSpawnPoint.add_child(flag)
