extends KinematicBody2D

var curHp = 10
var maxHp = 10
var moveSpeed = 250
var damage = 1

var gold: int = 0

var curLevel = 0
var curXp = 0
var xpToNextLevel = 50
var xpToLevelIncreaseRate = 1.2

var interactDist = 70

var vel = Vector2()
var facingDir = Vector2()

onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite

func _physics_process(delta):
	vel = Vector2()

	# inputs
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1, 0)

	if vel != Vector2.ZERO:
		facingDir = vel
	vel = vel.normalized()
	move_and_slide(vel * moveSpeed)
	manageAnimation()
	
func manageAnimation():
	if(abs(vel.x) > 0 or abs(vel.y) >0):
		play_animation("Move")
	else:
		play_animation("Idle")
	if(facingDir.x <0):
		anim.flip_h = true
	else:
		anim.flip_h = false

func play_animation(animateName):
	if anim.animation != animateName:
		anim.play((animateName))
