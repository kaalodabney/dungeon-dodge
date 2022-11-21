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
  #initialize array of players
  args.state.players ||= [{
    spriteAnim: "idle",
    spriteFlip: false, # facing right = false, facing left = true
    spriteID: 0,
    x: 640 - 50,
    y: 360 - 50,
    w: 100,
    h: 100,
    collision: false,
    speed: 0
  }]


  # initialize array of enemies

  args.state.enemies ||= [{  
    spriteAnim: "idle",
    spriteFlip: false,
    spriteID: 2,
    x: 350,
    y: 360 - 50,
    w: 100,
    h:  100,
    collision: false,
    speed: 0
  },{
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 4,
    x: 1150,
    y: 360 - 50,
    w: 100,
    h: 100,
    collision: false,
    speed: 0
  },
]

end

def spriteAnimations args
    x=5 #animation speed
    args.state.players.each do |p|
      if args.state.tick_count % x == 0
        p.spriteID += 1
        if p.spriteID > 5
          p.spriteID = 0
        end
      end
    end

    args.state.enemies.each do |e|
      if args.state.tick_count % x == 0
        e.spriteID += 1
        if e.spriteID > 5
          e.spriteID = 0
        end
      end
    end

   #loop through npcs, set sprite path depending on current spriteAnim
   args.state.enemies.each do |e|
    e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" : nil
    e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" : nil
   end

   #set player sprite path depending on current spriteAnim
   args.state.players.each do |p|
    p.spriteAnim == "idle" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{p.spriteID}.png" : nil
    p.spriteAnim == "walk" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{p.spriteID}.png" : nil
   end



end

#detect collision with players for each enemy
def enemyCollision args
   args.state.enemies.each do |e|
    (args.state.players.any_intersect_rect? e) ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
  end
end

def playerCollision args, dir

  args.state.players.each do |p|
    pClone ||= {x: p.x, y: p.y, w: p.w, h: p.h}
    dir == "up" ? pClone = {x: p.x, y: p.y+p.speed, w: p.w, h: p.h} : nil
    dir == "down" ? pClone = {x: p.x, y: p.y-p.speed, w: p.w, h: p.h} : nil
    dir == "right" ? pClone = {x: p.x+p.speed, y: p.y, w: p.w, h: p.h} : nil
    dir == "up" ? pClone = {x: p.x-p.speed, y: p.y, w: p.w, h: p.h}: nil

    if args.state.enemies.any_intersect_rect? pClone
      p.collision = true
      args.outputs.labels << [10, 600, "collision"]
      p.speed = 0
    end
  end

end





def playerInput args
  #Player Input
  # args.inputs.keyboard.up ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "up") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.down ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "down") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.right ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "right") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")
  # args.inputs.keyboard.left ? (args.state.player.spriteAnim = "walk"; args.state.keypressed = "left") : (args.state.player.spriteAnim = "idle"; args.state.keypressed = "")

  #Player Input
  args.state.players.each do |p|

    speed = 5
    
    if args.inputs.up # up movement and animation state change
      p.speed = speed
      p.spriteAnim = "walk"; args.state.keypressed = "up"
      playerCollision(args,"up")
      p.y += p.speed
      upDownPressed = true
    elsif args.inputs.down #down movement and animation state change
      p.speed = speed
      p.spriteAnim = "walk"; args.state.keypressed = "down"
      playerCollision(args,"down")
      p.y -= p.speed
      upDownPressed = true
    else
      upDownPressed = false
    end
    
    if args.inputs.right # right movement and animation state change
      p.speed = speed
      p.spriteAnim = "walk"; args.state.keypressed = "right"
      playerCollision(args,"right")
      p.x += p.speed
      p.spriteFlip = false
      rightLeftPressed = true
    elsif args.inputs.left # left movement and animation state change
      p.speed = speed
      p.spriteAnim = "walk"; args.state.keypressed = "left"
      playerCollision(args,"left")
      p.x -= p.speed
      p.spriteFlip = true
      rightLeftPressed = true
    else
      rightLeftPressed = false
    end

    upDownPressed || rightLeftPressed ? nil : (p.spriteAnim = "idle"; args.state.keypressed = "")
  end
end


def viewOutput args

  #enemies sprite output
  args.state.enemies.each do |e|
    args.outputs.sprites << {
      x: e.x,
      y: e.y,
      w: e.w,
      h: e.h,
      path: e.sprite,
      flip_horizontally: e.spriteFlip
    }
  end

  #player sprite output
  args.state.players.each do |p|
    args.outputs.sprites << {
      x: p.x,
      y: p.y,
      w: p.w,
      h: p.h,
      path: p.sprite,
      flip_horizontally: p.spriteFlip
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






