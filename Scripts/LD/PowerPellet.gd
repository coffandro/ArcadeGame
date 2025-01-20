extends Node2D

var currentPellet:int
var powerupAssets = [
	preload("res://Art/Levels/Powerups/Bullets.png"),
	preload("res://Art/Levels/Powerups/Lightning.png"),
	preload("res://Art/Levels/Powerups/Shield.png")
]
var powerUps = [
	"Shoot",
	"Lightning",
	"Shield"
]

func _ready():
	$Pellet/Collision.disabled = true
	$Pellet/Sprite.texture = null

func SpawnPellet(PelletNum:int):
	currentPellet = PelletNum
	$Pellet/Sprite.texture = powerupAssets[PelletNum-1]
	$Pellet/Collision.set_deferred("disabled", false)
	$Pellet.position = Vector2($Pellet.position.x, 0)
	
func _on_Pellet_body_entered(body:Node):
	if body.is_in_group("Player"):
		if body.currrentPowerUp == "":
			match currentPellet:
				1:
					body.currrentPowerUp = ""
					body.bullets = 5
				2:
					body.currrentPowerUp = powerUps[1]
				3:
					body.currrentPowerUp = powerUps[2]
				
			$Pellet/Collision.set_deferred("disabled", true)
			$Pellet/Sprite.texture = null
