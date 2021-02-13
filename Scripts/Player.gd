extends KinematicBody2D

var curHp = 10
var maxHp = 10
export var speed = 200
export var sprintMultiplier = 3
var currentSpeed = speed
var damage = 1
var gold: int = 0
var curLevel = 0
var curXp = 0
var xpToNextLevel = 50
var xpToLevelIncreaseRate = 1.2
var interactDist = 70
var vel = Vector2()
var facingDir = Vector2()

var sprintAvailable : bool = true

onready var rayCast = $RayCast2D
onready var anim = $AnimatedSprite
onready var sprintCooldownTimer = $SprintCooldownTimer
onready var sprintTimer = $SprintTimer

# DEBUG
onready var cdLabel = $cdLabel

func _ready():
	sprintCooldownTimer.connect("timeout",self,"_on_sprint_cooldown_finish") 
	sprintTimer.connect("timeout",self,"_on_sprint_finish") 
func _process(delta):
	cdLabel.text = String(sprintCooldownTimer.time_left) 
func _physics_process(delta):
	move()
	action()
	manageAnimation()
	
func action():
	pass
	
func move():
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

	# manage facing dir + raycast degree
	if vel != Vector2.ZERO:
		facingDir = vel
		rayCast.rotation_degrees = rad2deg(facingDir.angle()) - 90
	
	if Input.is_action_pressed("sprint") && sprintAvailable:
		sprint()
	move_and_slide(vel.normalized() * currentSpeed)
	
func manageAnimation():
	var moving = abs(vel.x) > 0 or abs(vel.y) >0
	if(moving && Input.is_action_pressed("sprint") && sprintAvailable):
		play_animation("Move") ## TODO: sprint animation
		sprintCooldown()
	elif(moving):
		play_animation("Move")
	else:
		play_animation("Idle")
	if(facingDir.x <0):
		anim.flip_h = true
	else:
		anim.flip_h = false

func sprint():
	currentSpeed = speed * sprintMultiplier
	sprintTimer.start()
	
func sprintCooldown():
	sprintAvailable = false
	sprintCooldownTimer.start()

func _on_sprint_finish():
	currentSpeed = speed
func _on_sprint_cooldown_finish():
	sprintAvailable = true

func play_animation(animateName):
	if anim.animation != animateName:
		anim.play((animateName))
