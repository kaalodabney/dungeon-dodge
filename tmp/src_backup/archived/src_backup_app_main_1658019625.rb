# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and very game programming
# Goals: Player controlled Sprite with Colision and sprite animations. Player can jump from square to square, auto attacking enemies in the same square 
#
#
#
#
#



def tick args

  args.state.rotation ||= 0
  args.state.x ||= 576
  args.state.y ||= 100

  if args.inputs.mouse.click
      args.state.x = args.inputs.mouse.click.point.x -  64
      args.state.y = args.inputs.mouse.click.point.y - 50
  end

  args.outputs.labels  << [640, 500, 'Hello Rubah!', 5, 1]
  args.outputs.sprites << [args.state.x,
                           args.state.y,
                           128,
                           101,
                           'dragonruby.png',
                           args.state.rotation]

  args.state.rotation -= 10

  args.outputs.labels << [10, 720, "Tick Counter: #{args.state.tick_count}"]
  args.outputs.labels << [10, 700, "FPS: #{args.gtk.current_framerate.round}"]

  args.outputs.sprite << [
    640 - 50, #X
    360 - 50, #Y
    100, #W
    100, #H
    'sprites/dc16pp/heroes/knight/knight_idle_anim_f0.png' # path
  ]





end



