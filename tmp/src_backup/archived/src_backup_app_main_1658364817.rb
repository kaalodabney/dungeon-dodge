# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and very game programming
# Goals: Player controlled Sprite with Colision and sprite animations. Player can jump from square to square, auto attacking enemies in the same square 


def tick args

  init args

  actorController args

  spriteAnimations args

  viewOutput args

end

def init args
  args.state.keypressed ||= Array.new(0)
  #initialize array of players
  args.state.players ||= [{
    spriteAnim: "idle",
    spriteFlip: false, # facing right = false, facing left = true
    spriteID: 0,
    x: 590,
    y: 310,
    w: 100,
    h: 100,
    colRect: { x:590, y: 310, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
    healthbarUI: {path: "sprites/dc16pp/ui/health_ui.png", x: 640-40, y: 360-75, w: 100, h: 20},
    hearts: 4,
    heartCounter: {x: 640-25, y: 360-50, w: 4*25, h: 20},
    debugVal: "wait",
    debugTog: false,
    debugVal2: "wait",
    debugTog2: false,
    debugVal3: "wait",
    debugTog3: false,
    debugVal4: 0,
    debugTog4: true,
  }]

  # initialize array of enemies
  args.state.enemies ||= [{  
    spriteAnim: "idle",
    spriteFlip: false,
    spriteID: 2,
    x: 490,
    y: 310,
    w: 100,
    h:  100,
    colRect: { x: 490, y: 310, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
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
    colRect: { x: 1150, y: 360 - 50, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },]
end


# Loops through all enteties and detects collision with player and direction
# inputs: args, player object, keypressed direction
# outputs: array (collision true/false, direction)
def playerCollision args, p, e

  collision = false

  # moves player collision rectangle in pressed direction to see if the player would collide if they moved there
  up, right, down, left = false

  if args.state.keypressed.include?("up")
    p.colRect.y = p.y + p.dy
    up = true
  end
  
  if args.state.keypressed.include?("right")
    p.colRect.x = p.x + p.dx
    right = true
  end

  if args.state.keypressed.include?("down")
    p.colRect.y = p.y - p.dy
    down = true
  end

  if args.state.keypressed.include?("left")
    p.debugTog ? (p.debugTog = true) : (p.debugVal = p.colRect.x.dup; p.debugTog = true)
    if p.debugTog4
      p.debugVal4 += 1
    end
    p.colRect.x = (p.x - p.dx)``
    
    left = true
  end

  if left == true
    p.debugTog2 ? (p.debugTog2 = true) : (p.debugVal2 = p.colRect.x.dup; p.debugTog2 = true)
  end

  if p.colRect.intersect_rect? e.colRect

    p.colDir.push("up") if up
    p.colDir.push("right") if right
    p.colDir.push("down") if down
    p.colDir.push("left") if left
    collision = true
    p.debugTog4 = false
  end


    
  



  #args.outputs.borders << [p.colRect]
  args.outputs.borders << [p]
  args.outputs.borders << [e.colRect]
  
  return collision

end

# enemy collision detection
# loops through players, if intersecting with collision rectanges, set enemy.col to true/false
# enemy colRect is then explanded by 1 in each direction and continues to detect colision within this 1 pixel area outside of the actual enemy cooridnates
# when player moves away from enemy set e.col to false and shrink the e.colRect
def enemyCollision args, p, e
    # if e.colRect.intersect_rect? p
    #   if e.col == false
    #     e.colRect.x = e.x-1
    #     e.colRect.w = e.w+2
    #     e.colRect.y = e.y-1
    #     e.colRect.h = e.h+2
    #   end
    #   e.col = true
    # else
    #   e.col = false
    #   e.colRect.x = e.x
    #   e.colRect.w = e.w
    #   e.colRect.y = e.y
    #   e.colRect.h = e.h  
    # end

end


def actorController args

  
  # Loop through players and process input, collision, and movement
  args.state.players.each do |p|
    args.outputs.labels << [10, 440, "debugVal: #{p.debugVal}"]
    args.outputs.labels << [10, 420, "debugVal2: #{p.debugVal2}"]
    args.outputs.labels << [10, 400, "debugVal3: #{p.debugVal3}"]
    args.outputs.labels << [10, 380, "debugVal4: #{p.debugVal4}"]
    upPressed, downPressed, rightPressed, leftPressed = false
    p.colRect.x, p.colRect.y = p.x, p.y
    p.colDir.clear
    p.col = false
    p.dx = 0
    p.dy = 0
    moveSpeed = 5
    
    # up movement and animation state change   
    if args.inputs.up 
      upPressed = true
      args.state.keypressed.push("up")unless args.state.keypressed.include?("up") 
    end 

    # right movement input detection, calls player collision detection method before moving the character before setting the player speed to move to the right, sets sprite direction to false (right)
    if args.inputs.right 
      rightPressed = true #true while held
      args.state.keypressed.push("right") unless args.state.keypressed.include?("right") #add to input stack only one time per keypress
    end
    
    # down movement and animation state change
    if args.inputs.down 
      args.state.keypressed.push("down") unless args.state.keypressed.include?("down") 
      downPressed = true
    end     

    # left movement input detection, calls player collision detection method before setting the player speed to move to the left, sets sprite direction to false (right)
    if args.inputs.left 
      args.state.keypressed.push("left") unless args.state.keypressed.include?("left")
      leftPressed = true
      p.debugTog3 ? (p.debugTog3 = true) : (p.debugVal3 = p.colRect.x.dup; p.debugTog3 = true)
    end


    # Loop through each enemy and detect collision
    colBuffer = false ##creating a buffer to detect if collision is true for ANY enemies, not just the last one
    args.state.enemies.each do |e| 
      p.col = playerCollision(args, p, e) 
      colBuffer = true if p.col
      args.outputs.labels << [10, 560, "p.colCollision: #{p.col}"]
    end
    p.col = colBuffer

    args.outputs.labels << [10, 540, "p.colDir: #{p.colDir}"]

    args.outputs.labels << [10, 40, "p.x|p.colRect.x|p.dx, p.y|p.colRect.x|p.dy: #{p.x}|#{p.colRect.x}|#{p.dx} #{p.y}|#{p.colRect.y}|#{p.dy}"]
    args.state.keypressed.each do |k|
      args.outputs.labels << [10, 520, "p.colCollision3: #{p.col}"]
      p.dy = 5 if  k == "up"    #p.colDir.include?("up")) if  k == "up"    
      (p.dx = 5; p.spriteFlip = false) if  k == "right" #p.colDir.include?("right"); p.spriteFlip = false) if  k == "right"
      p.dy = -5  if k == "down"
      (p.dx = -5; p.spriteFlip = true) if k == "left"
    end

    p.dx = 0 if p.col
    p.dy = 0 if p.col

    (args.state.keypressed.delete("up") if args.state.keypressed.include?("up")) if !upPressed 
    (args.state.keypressed.delete("right") if args.state.keypressed.include?("right")) if !rightPressed
    (args.state.keypressed.delete("down") if args.state.keypressed.include?("down")) if !downPressed
    (args.state.keypressed.delete("left") if args.state.keypressed.include?("left")) if !leftPressed


    
    args.outputs.labels << [10, 500, "p.x/p.dx, p.y/p.dy: #{p.x}/#{p.dx} #{p.y}/#{p.dy}"]
    p.y += p.dy
    p.x += p.dx



    # move player healthbar with player
    p.healthbarUI.x = p.x
    p.healthbarUI.y = p.y - 30
    
    #loop through each enemy and run their collision detection against the given player
    args.state.enemies.each { |e| enemyCollision(args, p, e)}

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
  e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
  e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" : nil
  e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" : nil
 end

 #set player sprite path depending on current spriteAnim
 args.state.players.each do |p|
  (p.dy == 0 && p.dx == 0) ?  p.spriteAnim = "idle" : p.spriteAnim = "walk"
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
    args.outputs.sprites << {
      x: p.healthbarUI.x, 
      y: p.healthbarUI.y, 
      w: p.healthbarUI.w, 
      h: p.healthbarUI.h,
      path: p.healthbarUI.path
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
    args.outputs.labels << [10, 600, "Player.dx: #{args.state.players[0].dx}"]
    args.outputs.labels << [10, 580, "Player.dy: #{args.state.players[0].dy}"]
    
end