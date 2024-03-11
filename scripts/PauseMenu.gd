extends CanvasLayer

onready var resumeButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
onready var optionButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var optionsMenuScene = preload("res://scenes/UI/OptionsMenu.tscn")

func _ready():
	resumeButton.connect("pressed", self, "on_resume_pressed")
	optionButton.connect("pressed", self, "on_option_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	get_tree().paused = true

func _unhandled_input(event):
	if(event.is_action_pressed("pause")):
		unpause()
		get_tree().set_input_as_handled()

func unpause():
	queue_free()
	get_tree().paused = false

func on_resume_pressed():
	unpause()
	
func on_option_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false
	
func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true
	$PopUpAnimation.play("default")
	
func on_quit_pressed():
	$"/root/ScreenTrasitionManager".transition_to_menu()
	unpause()

