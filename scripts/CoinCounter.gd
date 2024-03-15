extends HBoxContainer

func _ready():
	var baseLevel = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevel.size() > 0):
		baseLevel[0].connect("coin_total_changed", self, "on_coin_total_change")
		update_diplay(baseLevel[0].totalCoins, baseLevel[0].totalCoins)
func update_diplay(totalCoins, collectedCoins):
	$CoinLabel.text = str(collectedCoins, "/", totalCoins)
	
func on_coin_total_change(totalCoins, collectedCoins):
	update_diplay(totalCoins, collectedCoins)
