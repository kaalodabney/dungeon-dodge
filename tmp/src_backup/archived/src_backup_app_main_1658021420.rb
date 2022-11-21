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


#initialize player sprite anims
playerIdleAnim = ['sprites/dc16pp/heroes/knight/knight_idle_anim_f0.png', 'sprites/dc16pp/heroes/knight/knight_idle_anim_f1.png', 'sprites/dc16pp/heroes/knight/knight_idle_anim_f2.png', 'sprites/dc16pp/heroes/knight/knight_idle_anim_f5.png']


def playerIdleAnimIterator(sprite)

  #!sprite ? args.state.
end


def tick args

  args.state.rotation ||= 0
  args.state.x ||= 576
  args.state.y ||= 100
  args.state.player.sprite ||= nil

  !sprite ? args.output.labels << [10, 680, "args.state.player.sprite == nil"]

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

  ## outputs player sprite to view
  args.outputs.sprites << [
    640 - 50, #X
    360 - 50, #Y
    100, #W
    100, #H
    args.state.player.sprite # path
  ]

  args.state.tick_count%3 == 0 ? args.player.sprite == 
    


    long_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elitteger dolor velit, ultricies vitae libero vel, aliquam imperdiet enim."
    max_character_length = 30
    long_strings_split = args.string.wrapped_lines long_string, max_character_length
    args.outputs.labels << long_strings_split.map_with_index do |s, i|
      { x: 10, y: 600 - (i * 20), text: s }
    end




end



