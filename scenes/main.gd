extends Node2D

@onready var grid = $GridContainer
@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var mole_timer = $MoleTimer
@onready var floor_label = $FloorLabel
@onready var wrong = $Wrong
@onready var error = $Error
@onready var glitch = $Glitcherror

var hole_scene = preload("res://scenes/hole.tscn")
var mainscreen = preload("res://scenes/gamescreen.tscn")
var holes = []
var current_mole_hole = null
var score = 0
var lives = 3
var mole_visible_duration = 1.2

func _ready():
	mole_timer.timeout.connect(_on_mole_timer_timeout)
	error.hide()
	Global.messagelabelvis = false
	start_game()

func start_game():
	score = 0
	lives = 3
	score_label.text = "Score: 0"
	lives_label.text = "Lives: 3"

	for child in grid.get_children():
		child.queue_free()
	holes.clear()

	for i in range(9):
		var hole = hole_scene.instantiate()
		grid.add_child(hole)
		hole.custom_minimum_size = Vector2(100, 100)
		hole.hole_clicked.connect(_on_hole_clicked)
		holes.append(hole)

	mole_timer.wait_time = 1.5
	mole_timer.start()

func _on_mole_timer_timeout():
	if current_mole_hole != null and current_mole_hole.has_mole:
		current_mole_hole.hide_mole()
		lose_life()
		if lives <= 0:
			return

	current_mole_hole = holes[randi() % holes.size()]
	current_mole_hole.show_mole()

func _on_hole_clicked(had_mole):
	if had_mole:
		score += 1
		score_label.text = "Score: " + str(score)
		if score == 3:
			success()
	else:
		lose_life()
		
func success():
	Global.floor -= 1
	if score == 3:
		get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")
		Global.message =  "Well now it is \n Floor -" + str(Global.floor)
		Global.messagelabelvis = true

func lose_life():
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	wrong.play()
	if lives <= 0:
		if score <= 0:
			error.show()
			glitch.play()
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://scenes/victory2.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/gamescreen.tscn")
			Global.message.text = "TRY AGAIN."
			Global.messagelabelvis = true

func game_over():
	mole_timer.stop()
	if current_mole_hole != null:
		current_mole_hole.hide_mole()
	print("Game Over! Final Score: " + str(score))
	await get_tree().create_timer(2.0).timeout
	start_game()
