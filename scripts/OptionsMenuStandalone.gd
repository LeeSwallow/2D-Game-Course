extends CanvasLayer

func _ready():
	$OptionsMenu.connect("back_pressed", self, "on_back_pressed")

func on_back_pressed():
	$"/root/ScreenTrasitionManager".transition_to_menu()
