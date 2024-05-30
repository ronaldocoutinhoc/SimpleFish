extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_player.play(getRandomFish())
	animated_sprite_2d.play(getRandomFish())
	animation_player.play("Catch")


func getRandomFish():
	

	var fishOdds = {
		5: "Fish1",
		10: "Fish2",
		40: "Fish3",
		45: "Fish4",
	}
	
	verifyMaxPercent(fishOdds)
	randomize()
	var fishOdd = randi() % 100 + 1
	
	var accumulated_chance = 0
	var chances = fishOdds.keys()
	chances.sort()
	
	for chance in fishOdds.keys():
		accumulated_chance += chance
		if fishOdd <= accumulated_chance:
			return fishOdds[chance]
	
	return null
	
func verifyMaxPercent(odds):
	var keys = odds.keys()
	var total = 0
	
	for chance in keys:
		total += chance
	
	assert(total == 100, "The total percentage of fish odds must sum to 100!!")
	

	
	
