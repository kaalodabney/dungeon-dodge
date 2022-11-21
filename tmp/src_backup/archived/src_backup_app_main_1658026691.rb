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
  args.state.player.spriteID ||= 0
  args.state.player.spriteSrcArr ||= ["sprites/dc16pp/heroes/knight/knight_idle_anim_f0.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f1.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f2.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f3.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f4.png", "sprites/dc16pp/heroes/knight/knight_idle_anim_f5.png"]

  #player animation, sprite incrementation every 30 ticks
  args.state.player.sprite =  args.state.player.spriteSrcArr[args.state.player.spriteID]

  if args.state.tick_count % 30 == 0
    spriteID += 1
    if spriteID > 5
      spriteID = 0
    end
  end
  





  #Stats Labels
  args.outputs.labels << [10, 720, "Tick Counter: #{args.state.tick_count}"]
  args.outputs.labels << [10, 700, "FPS: #{args.gtk.current_framerate.round}"]
  args.outputs.labels << [10, 680, "SpriteID: #{args.state.player.spriteI}"]
  args.outputs.labels << [10, 660, "Sprite Src: #{args.state.player.spriteSrcArr[args.state.player.spriteID]}"]




  #Player Sprite Output
  args.outputs.sprites << [
    640 - 50, #X
    360 - 50, #Y
    100, #W
    100, #H
    args.state.player.sprite # path
  ]


end



