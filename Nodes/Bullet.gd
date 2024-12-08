extends Area2D

var speed = 750
var playerSide
var direction

func _physics_process(delta):
	position += transform.x * speed * delta * direction

func SetData(Side, Direction):
	playerSide = Side
	direction = Direction

func _on_Bullet_body_entered(body):
	if "Player" in body.name:
		if body.playerNumber != playerSide:
			body.TakeDamage(10)
	if not body.is_in_group("Teleporter"):
		queue_free()
