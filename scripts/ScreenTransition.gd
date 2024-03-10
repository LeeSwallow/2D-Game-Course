extends CanvasLayer

signal screen_covered

func on_screen_covered():
	emit_signal("screen_covered")
