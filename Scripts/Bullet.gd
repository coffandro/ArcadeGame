extends Area2D

var speed = 750
var playerSide
var direction
var moving = true

func _physics_process(delta):
	if moving:
		position += transform.x * speed * delta * direction

func SetData(Side, Direction):
	playerSide = Side
	$Sprite.scale.x = $Sprite.scale.x * Direction
	$CollisionShape2D.position.x = $CollisionShape2D.position.x * Direction
	direction = Direction

func _on_Bullet_body_entered(body):
	if "Player" in body.name:
		if body.playerNumber != playerSide:
			body.TakeDamage(10)
	if not body.is_in_group("Teleporter"):
		$AnimationPlayer.play("BulletHit")
		moving = false
		$DestroyTimer.start()


func _on_DestroyTimer_timeout():
	queue_free()
