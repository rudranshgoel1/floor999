extends Node2D

@onready var grid = $GridContainer

var tile_scene = preload("res://scenes/tile.tscn")
var symbols = ["🍎","🍌","🍇","🍓","🍒","🍑","🥝","🍍"]
var first_tile = null
var second_tile = null
var can_flip = true
var matches_found = 0

func _ready():
	start_game()

func start_game():
	var values = symbols + symbols
	values.shuffle()

	for i in range(16):
		var tile = tile_scene.instantiate()
		grid.add_child(tile)
		tile.value = values[i]
		tile.custom_minimum_size = Vector2(80, 80)
		tile.tile_clicked.connect(_on_tile_clicked)

func _on_tile_clicked(tile):
	if not can_flip:
		return

	tile.flip_up()

	if first_tile == null:
		first_tile = tile
	elif second_tile == null and tile != first_tile:
		second_tile = tile
		can_flip = false
		await get_tree().create_timer(0.8).timeout
		check_match()

func check_match():
	if first_tile.value == second_tile.value:
		first_tile.is_matched = true
		second_tile.is_matched = true
		matches_found += 1
		if matches_found == 8:
			print("You win!")
	else:
		first_tile.flip_down()
		second_tile.flip_down()

	first_tile = null
	second_tile = null
	can_flip = true
