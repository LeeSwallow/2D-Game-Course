extends CanvasLayer

signal back_pressed

onready var windowModeButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowModeButton
onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
var fullscreen = false

func _ready():
	windowModeButton.connect("pressed", self, "on_window_mode_button_pressed")
	backButton.connect("pressed", self, "on_back_button_pressed")
	update_display()
	
func update_display():
	windowModeButton.text = "FULLSCREEN" if fullscreen else "WINDOWED"

func on_window_mode_button_pressed():
	fullscreen = !OS.window_fullscreen
	OS.window_fullscreen = fullscreen
	update_display()
	
func on_back_button_pressed():
	emit_signal("back_pressed")
