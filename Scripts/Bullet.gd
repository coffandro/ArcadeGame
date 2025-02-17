extends Area2D

var speed = 750
var playerSide
var direction
var moving = true

onready var sprite = $Sprite
onready var collisionShape2D = $CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var destroyTimer = $DestroyTimer

func _physics_process(delta):
	if moving:
		position += transform.x * speed * delta * direction

func SetData(Side, Direction):
	yield(self, "ready")

	playerSide = Side
	sprite.scale.x = sprite.scale.x * Direction
	collisionShape2D.position.x = collisionShape2D.position.x * Direction
	direction = Direction

func _on_Bullet_body_entered(body):
	if "Player" in body.name:
		if body.player_number != playerSide:
			body.TakeDamage(20)
		else:
			return
	
	if not body.is_in_group("Teleporter"):
		animationPlayer.play("BulletHit")
		moving = false
		destroyTimer.start()

func _on_DestroyTimer_timeout():
	queue_free()
