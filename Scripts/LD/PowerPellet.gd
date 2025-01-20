extends Node2D

signal picked_up(emitter)

var currentPellet:int
var id:int
var powerupAssets = [
	preload("res://Art/Levels/Powerups/Bullets.png"),
	preload("res://Art/Levels/Powerups/Lightning.png"),
	preload("res://Art/Levels/Powerups/Shield.png")
]
var powerUps = [
	"Shoot",
	"Speed",
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
			body.apply_power_up(currentPellet)
				
			$Pellet/Collision.set_deferred("disabled", true)
			$Pellet/Sprite.texture = null
			emit_signal("picked_up", self)
