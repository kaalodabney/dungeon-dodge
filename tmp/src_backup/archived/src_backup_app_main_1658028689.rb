# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and very game programming
# Goals: Player controlled Sprite with Colision and sprite animations. Player can jump from square to square, auto attacking enemies in the same square 
#
#
#
############################## Ruby Hello World
  # if args.inputs.mouse.click
  #     args.state.x = args.inputs.mouse.click.point.x -  64
  #     args.state.y = args.inputs.mouse.click.point.y - 50
  # end

  # args.outputs.labels  << [640, 500, 'Hello Rubah!', 5, 1]
  # args.outputs.sprites << [args.state.x,
  #                          args.state.y,
  #                          128,
  #                          101,
  #                          'dragonruby.png',
  #                          args.state.rotation]

  # args.state.rotation -= 10


def tick args

  #initialize player state variables
  args.state.player.spriteAnim ||= "idle"
  args.state.player.spriteID ||= 0
  args.state.player.spriteIdleArr ||= ["sprites/dc16pp/heroes/knight/knight_idle_anim_f0.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f1.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f2.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f3.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f4.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f5.png"]
  args.state.player.spriteWalkArr ||= ["sprites/dc16pp/heroes/knight/knight_run_anim_f0.png", "sprites/dc16pp/heroes/knight/knight_run_anim_f1.png", "sprites/dc16pp/heroes/knight/knight_run_anim_f2.png", "sprites/dc16pp/heroes/knight/knight_run_anim_f3.png", "sprites/dc16pp/heroes/knight/knight_run_anim_f4.png", "sprites/dc16pp/heroes/knight/knight_run_anim_f5.png"]

  #player animation, sprite incrementation every x ticks
  x=4
  if args.state.tick_count % x == 0
    args.state.player.spriteID += 1
    if args.state.player.spriteID > 5
      args.state.player.spriteID = 0
    end
  end

  #set player sprite depending on current animation playing
   args.state.player.spriteAnim == "idle" ? args.state.player.sprite =  args.state.player.spriteIdleArr[args.state.player.spriteID] : nil
   args.state.player.spriteAnim == "walk" ? args.state.player.sprite =  args.state.player.spriteWalkArr[args.state.player.spriteID] : nil



  #Player Input
  x=true
  if args.inputs.keyboard.key_held.w || args.inputs.keyboard.key_held.a || args.inputs.keyboard.key_held.s || args.inputs.keyboard.key_held.d
    args.state.player.spriteAnim = "walk"
  end

  if args.inputs.keyboard.key_up.w || args.inputs.keyboard.key_up.a || args.inputs.keyboard.key_up.s || args.inputs.keyboard.key_up.d
    args.state.player.spriteAnim = "idle"
  end

  #Sprite Outputs
  args.outputs.sprites << [
    640 - 50, #X
    360 - 50, #Y
    100, #W
    100, #H
    args.state.player.sprite #img path
  ]

  diagnostics args

end

def diagnostics args
    #Stats Labels
    args.outputs.labels << [10, 720, "Tick Counter: #{args.state.tick_count}"]
    args.outputs.labels << [10, 700, "FPS: #{args.gtk.current_framerate.round}"]
    args.outputs.labels << [10, 680, "SpriteID: #{args.state.player.spriteID}"]
    args.outputs.labels << [10, 660, "Sprite Src: #{args.state.player.sprite}"]
end





