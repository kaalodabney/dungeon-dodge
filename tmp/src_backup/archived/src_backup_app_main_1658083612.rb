# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and very game programming
# Goals: Player controlled Sprite with Colision and sprite animations. Player can jump from square to square, auto attacking enemies in the same square 


def tick args

  init args

  playerMovement args

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
    dx: 0,
    dy: 0,
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
    dx: 0,
    dy: 0,
  },{
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 4,
    x: 1150,
    y: 360 - 50,
    w: 100,
    h: 100,
    collision: false,
    dx: 0,
    dy: 0,
  },]
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
    e.collision ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
    e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" : nil
    e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" : nil
   end

   #set player sprite path depending on current spriteAnim
   args.state.players.each do |p|
    (p.dy == 0 && p.dx == 0) ?  p.spriteAnim = "idle" : p.spriteAnim = "walk"
    p.spriteAnim == "idle" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{p.spriteID}.png" : nil
    p.spriteAnim == "walk" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_walk_anim_f#{p.spriteID}.png" : nil
   end
end

def enemiesCollision args, pClone, dir

  args.state.enemies.each do |e|
    pClone 

  end
end


def playerCollision args, pClone, dir

    args.state.players.each do |p|
      args.state.enemies.each do |e|

        if dir == "up"
          pClone.y = p.y+p.dy
          (pClone.intersect_rect? e) ? (p.dy = 0; e.collision = true; p.collision = true) : nil
        end

        if dir == "down"
          pClone.y = p.y-p.dy
          (pClone.intersect_rect? e) ? (p.dy = 0; e.collision = true; p.collision = true) : nil
        end
        
        if dir == "right"
          pClone.x = p.x+p.dx
          (pClone.intersect_rect? e) ?  (p.dx = 0; e.collision = true; p.collision = true) : nil
        end
        
        if dir == "left"
          pClone.x = p.x-p.dx
          (pClone.intersect_rect? e) ? (p.dx = 0; e.collision = true; p.collision = true) : nil
        end
      end
    end  
end


def playerMovement args

  #Player Input
  args.state.players.each do |p|

    upDownPressed = false
    rightLeftPressed = false
    moveSpeed = 5
    pClone = {x: p.x, y: p.y, w: p.w, h: p.h}

    if args.inputs.up # up movement and animation state change   
      p.dy = moveSpeed
      args.state.keypressed = "up"
      playerCollision(args, pClone, "up")
      p.collision ? p.dy = 0 : nil
      p.y += p.dy
      upDownPressed = true
      p.collision = false
    end 
    
    if args.inputs.down #down movement and animation state change
      p.dy = moveSpeed
      args.state.keypressed = "down"
      playerCollision(args, pClone, "down")
      p.collision ? p.dy = 0 : nil
      p.y -= p.dy
      upDownPressed = true
      p.collision = false
    end

    
    if args.inputs.right # right movement and animation state change
      p.dx = moveSpeed
      args.state.keypressed = "right"
      playerCollision(args, pClone, "right")
      p.collision ? p.dx = 0 : nil
      p.x += p.dx
      p.spriteFlip = false
      rightLeftPressed = true
      p.collision = false
    end
    
    if args.inputs.left # left movement and animation state change
      p.dx = moveSpeed
      args.state.keypressed = "left"
      playerCollision(args, pClone, "left")
      p.collision ? p.dx = 0 : nil
      p.x -= p.dx
      p.spriteFlip = true
      rightLeftPressed = true
      p.collision = false
    end

    upDownPressed || rightLeftPressed ? nil : (args.state.keypressed = ""; p.dx = 0; p.dy = 0)
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
    args.outputs.labels << [10, 680, "SpriteID: #{args.state.players[0].spriteID}"]
    args.outputs.labels << [10, 660, "Sprite: #{args.state.players[0].sprite}"]
    args.outputs.labels << [10, 640, "Key Pressed: #{args.state.keypressed}"]
    args.outputs.labels << [10, 620, "Animation: #{args.state.players[0].spriteAnim}"]
    args.outputs.labels << [10, 600, "Player dx: #{args.state.players[0].dx}"]
    args.outputs.labels << [10, 580, "Player dy: #{args.state.players[0].dx}"]
end






