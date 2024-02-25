extends CanvasLayer

func _ready():
	var baseLevel = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevel.size() > 0):
		baseLevel[0].connect("coin_total_changed", self, "on_coin_total_change")

func on_coin_total_change(totalCoins, collectedCoins):
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collectedCoins, "/", totalCoins)
