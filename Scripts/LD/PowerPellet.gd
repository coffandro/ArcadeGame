extends Node2D

signal picked_up(emitter)

var currentPellet:int
var id:int
var offset = 750
var t = 0.0

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
	$Pellet.position.y -= offset
	t = 0

func _physics_process(delta: float) -> void:
	if $Pellet.position != $ZeroPoint.position:
		t += delta * 0.3
		$Pellet.position = ($ZeroPoint.position - Vector2(0, offset)).linear_interpolate($ZeroPoint.position, t)
		if t > 1:
			t = 1

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

func _on_Pellet_body_entered(body:Node):
	if not body.is_in_group("Player"):
		return
	if body.current_power_up != "":
		return
	if currentPellet == 1 and body.bullets == 5:
		return

	body.apply_power_up(currentPellet)
		
	$Pellet/Collision.set_deferred("disabled", true)
	$Pellet/Sprite.texture = null
	emit_signal("picked_up", self)
