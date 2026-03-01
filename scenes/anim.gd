extends Node2D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("idle")
	anim.animation_finished.connect(onfinish)
	
func play_anim( animation_name ) -> void:
	anim.play( animation_name )
	
func stop_anim() -> void:
	anim.stop()

func onfinish(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")
	Global.messagelabelvis = true
	Global.message = "You fell into the hole and now \n you are at Floor -999, advance with\n going to the door."
