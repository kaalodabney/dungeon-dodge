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
    collisionDirection: "",
    dx: 0,
    dy: 0,
    healthbarUI: {path: "sprites/dc16pp/ui/health_ui.png", x: 640-25, y: 360-50, w: 100, h: 20},
    heartCounter: {heartCount: 4, x: 640-25, y: 360-50, w: heartCount*25, h: 20}
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
    collisionDirection: "",
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
    collisionDirection: "",
    dx: 0,
    dy: 0,
  },]
end


#intersecting rectangles player collision
def playerCollisionRect args, p, dir
  pClone = {x: p.x, y: p.y, w: p.w, h: p.h}

    # predicts if a movement will cause a player to colide with an enemy, if so set collision to true for that player and colliding enemy  
    # - collision turned false again 
    args.state.enemies.each do |e|
      p.collisionDirection = ""

      dir == "right" ? pClone.x = p.x + p.dx : nil
      dir == "left"  ? pClone.x = p.x - p.dx : nil
      dir == "up"    ? pClone.y = p.y + p.dy : nil
      dir == "down"  ? pClone.y = p.y - p.dy : nil

      (pClone.intersect_rect? e) ?  (p.collisionDirection = dir;  e.collision = true; p.collision = true) : nil
    
    end
end


def playerMovement args

  #Player Input
  args.state.players.each do |p|

    upDownPressed = false
    rightLeftPressed = false
    moveSpeed = 5
    
    # right movement and animation state change
    if args.inputs.right 
      p.dx = moveSpeed
      args.state.keypressed = "right"
      playerCollisionRect(args, p, "right")
      p.collision ? nil : p.x += p.dx
      
      p.spriteFlip = false
      rightLeftPressed = true
      p.collision = false
    end
    # left movement and animation state change
    if args.inputs.left 
      p.dx = moveSpeed
      args.state.keypressed = "left"
      playerCollisionRect(args, p, "left")
      p.collision ? nil : p.x -= p.dx
      
      p.spriteFlip = true
      rightLeftPressed = true
      p.collision = false
    end
    # up movement and animation state change   
    if args.inputs.up 
      p.dy = moveSpeed
      args.state.keypressed = "up"
      playerCollisionRect(args, p, "up")
      p.collision ? nil : p.y += p.dy

      upDownPressed = true
      p.collision = false
    end 
    # down movement and animation state change
    if args.inputs.down 
      p.dy = moveSpeed
      args.state.keypressed = "down"
      playerCollisionRect(args, p, "down")
      p.collision ? nil : p.y -= p.dy
      
      upDownPressed = true
      p.collision = false
    end  


    upDownPressed ? nil : p.dy = 0
    rightLeftPressed ? nil : p.dx = 0
    upDownPressed || rightLeftPressed ? nil : args.state.keypressed = ""
  end
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
  e.collision ? (e.spriteAnim = "walk"; e.collision = false) : e.spriteAnim = "idle"
  e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" : nil
  e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" : nil
 end

 #set player sprite path depending on current spriteAnim
 args.state.players.each do |p|
  (p.dy == 0 && p.dx == 0) ?  p.spriteAnim = "idle" : (p.spriteAnim = "walk"; p.collision = false)
  p.spriteAnim == "idle" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{p.spriteID}.png" : nil
  p.spriteAnim == "walk" ? p.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{p.spriteID}.png" : nil
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
    args.outputs.labels << [10, 580, "Player dy: #{args.state.players[0].dy}"]
end






