extends Node2D

var player_in_zone: bool = false

@onready var trigger_zone = $TriggerZone
@onready var player = $Player
@onready var floor_label = $FloorLabel
@onready var inst = $Inst

func _ready():
	trigger_zone.body_entered.connect(_on_body_entered)
	trigger_zone.body_exited.connect(_on_body_exited)
	floor_label.text = "Floor: -" + str(Global.floor)
	inst.hide()
	$MessageLabel.visible = Global.messagelabelvis
	$MessageLabel.text = Global.message

func _on_body_entered(body):
	if body == player:
		player_in_zone = true
		inst.show()

func _on_body_exited(body):
	if body == player:
		player_in_zone = false
		inst.hide()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_E and player_in_zone:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
