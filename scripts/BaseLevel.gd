extends Node

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

func _ready():
	spawnPosition = $Player.global_position
	register_player($Player)
	
func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	
func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance) #  형제 노드 간 우선순위 유지를 위해 필요
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	
func on_player_died():
	currentPlayerNode.queue_free() # 마지막에 실행하므로 상관없음
	create_player()
