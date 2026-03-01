extends Button

var has_mole: bool = false

signal hole_clicked(had_mole)

@onready var mole_label = $Blahaj50

func _ready():
	mole_label.hide()
	pressed.connect(_on_pressed)

func show_mole():
	has_mole = true
	mole_label.show()

func hide_mole():
	has_mole = false
	mole_label.hide()

func _on_pressed():
	emit_signal("hole_clicked", has_mole)
	if has_mole:
		hide_mole()
