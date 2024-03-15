extends CanvasLayer

onready var ContinueButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContuneButton
onready var RestartButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton
func _ready():
	ContinueButton.connect("pressed", self, "on_continue_button_pressed")
	RestartButton.connect("pressed", self, "on_restart_button_pressed")
	
func on_continue_button_pressed():
	$"/root/LevelManager".increment_level()

func on_restart_button_pressed():
	$"/root/LevelManager".restart_level()
