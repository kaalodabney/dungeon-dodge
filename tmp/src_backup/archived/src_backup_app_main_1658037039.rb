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

  init args

  playerInput args

  spriteAnimations args

  viewOutput args

end

def init args
  #initialize state.player variables
  args.state.player.spriteAnim ||= "idle"
  args.state.player.spriteFlip ||= false # facing right = false, facing left = true
  args.state.player.spriteID ||= 0
  args.state.player.x ||= 640 - 50
  args.state.player.y ||= 360 - 50
  args.state.player.width ||= 100
  args.state.player.height ||= 100

  # initialize array of enemies

  args.state.enemies ||= [{  
    args.state.enemies.spriteAnim: "idle",
    args.state.enemies.spriteFlip: false,
    args.state.enemies.spriteID: 0,
    args.state.enemies.x: 350,
    args.state.enemies.y: 360 - 50,
    args.state.enemies.width: 100,
    args.state.enemies.height:  100
  },{
    args.state.enemies.spriteAnim: "idle",
    args.state.enemies.spriteFlip: true,
    args.state.enemies.spriteID: 0,
    args.state.enemies.x: 1150,
    args.state.enemies.y: 360 - 50,
    args.state.enemies.width: 100,
    args.state.enemies.height: 100
  }]

end

def spriteAnimations args
    #player animation, sprite incrementation every x ticks
    x=5
    if args.state.tick_count % x == 0
      args.state.player.spriteID += 1
      if args.state.player.spriteID > 5
        args.state.player.spriteID = 0
      end
    end

   #set player sprite depending on current animation playing
   args.state.player.spriteAnim == "idle" ? args.state.player.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{args.state.player.spriteID}.png" : nil
   args.state.player.spriteAnim == "walk" ? args.state.player.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{args.state.player.spriteID}.png" : nil

   #loop through npc animations

   args.state.enemies.each do |e|
    e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/heroes/knight/goblin_idle_anim_f#{e.spriteID}.png" : nil
    e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/heroes/knight/goblin_run_anim_f#{e.spriteID}.png" : nil
   end


end

def playerInput args
  #Player Input
  # args.inputs.keyboard.up ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "up") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.down ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "down") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.right ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "right") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.left ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "left") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")

  #Player Input
  args.state.player.moveSpeed = 5
  if args.inputs.up
    args.state.player.spriteAnim = "walk"; args.state.keypressed = "up"
    args.state.player.y += args.state.player.moveSpeed
    upDownPressed = true
  elsif args.inputs.down
    args.state.player.spriteAnim = "walk"; args.state.keypressed = "down"
    args.state.player.y -= args.state.player.moveSpeed
    upDownPressed = true
  else
    upDownPressed = false
  end
  
  if args.inputs.right
    args.state.player.spriteAnim = "walk"; args.state.keypressed = "right"
    args.state.player.x += args.state.player.moveSpeed
    args.state.player.spriteFlip = false
    rightLeftPressed = true
  elsif args.inputs.left
    args.state.player.spriteAnim = "walk"; args.state.keypressed = "left"
    args.state.player.x -= args.state.player.moveSpeed
    args.state.player.spriteFlip = true
    rightLeftPressed = true
  else
    rightLeftPressed = false
  end

  upDownPressed || rightLeftPressed ? nil : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
end

def viewOutput args
    #player sprite output
    args.outputs.sprites << {
      x: args.state.player.x,
      y: args.state.player.y,
      w: args.state.player.width,
      h: args.state.player.height,
      path: args.state.player.sprite,
      flip_horizontally: args.state.player.spriteFlip
    }

    #enemies sprite output
    args.state.enemies.each do |e|
      args.outputs.sprites << {
        x: e.x,
        y: e.y,
        w: e.width,
        h: e.height,
        path: e.sprite,
        flip_horizontally: e.spriteFlip
      }
    end

    diagnosticsLabels args

end


def diagnosticsLabels args
    #Stats Labels
    args.outputs.labels << [10, 720, "Tick Counter: #{args.state.tick_count}"]
    args.outputs.labels << [10, 700, "FPS: #{args.gtk.current_framerate.round}"]
    args.outputs.labels << [10, 680, "SpriteID: #{args.state.player.spriteID}"]
    args.outputs.labels << [10, 660, "Sprite Src: #{args.state.player.sprite}"]
    args.outputs.labels << [10, 640, "Key Pressed: #{args.state.keypressed}"]
    args.outputs.labels << [10, 620, "Animation: #{args.state.player.spriteAnim}"]
end






