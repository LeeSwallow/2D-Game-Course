extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	playButton.connect("pressed", self, "on_play_pressed")
	optionButton.connect("pressed", self, "on_option_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_option_pressed():
	$"/root/ScreenTrasitionManager".transition_to_scene("res://scenes/UI/OptionsMenuStandalone.tscn")
	

func on_quit_pressed():
	get_tree().quit()
