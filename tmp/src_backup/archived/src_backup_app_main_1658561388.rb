# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and simple game development
# Goals: 
# [x] Player controlled Sprite with Colision and sprite animations.
# [ ] player healthbar, player takes damage when touching enemy
# [ ] spawn enemies in random locations outside of x range of player
# [ ] enemies move towards the player slowly


def tick args

  init args

  entityController args

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
    y: 250,
    w: 100,
    h: 100,
    colRect: { x:590, y: 250, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,                               
    healthbar: {x: 615, y: 310, w: 100, h: 20, r: 225, g: 0, b: 0},
    healthbarUI: {path: "sprites/dc16pp/ui/health_ui.png", x: 640-40, y: 360-75, w: 100, h: 20},
    hearts: 4,
    enemyColArray: [] 
  }]

  enemyLineX = 100
  enemyLineY = 400

  # initialize array of enemies
  args.state.enemies ||= [{  
    id: 0,
    spriteAnim: "idle",
    spriteFlip: false,
    spriteID: 2,
    x: enemyLineX,
    y: enemyLineY,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX, y: enemyLineY, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 1,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 4,
    x: enemyLineX + 100,
    y: enemyLineY,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX + 100, y: enemyLineY, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 2,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 2,
    x: enemyLineX + 200,
    y: enemyLineY,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX + 200, y: enemyLineY, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 3,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 4,
    x: enemyLineX + 300,
    y: enemyLineY,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX + 300, y: enemyLineY, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 4,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 2,
    x: enemyLineX + 400,
    y: enemyLineY,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX + 400, y: enemyLineY, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 5,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 2,
    x: enemyLineX,
    y: enemyLineY-100,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX, y: enemyLineY-100, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  },{
    id: 6,
    spriteAnim: "idle",
    spriteFlip: true,
    spriteID: 2,
    x: enemyLineX,
    y: enemyLineY-250,
    w: 100,
    h:  100,
    colRect: { x: enemyLineX, y: enemyLineY-250, w: 100, h: 100,},
    col: false,
    colDir: Array.new(0),
    dx: 0,
    dy: 0,
  }]
end


# Loops through all entitiees and detects collision with player and direction
# inputs: args, player object, enemy, keypressed direction
# outputs: true/false
def playerCollision args, p, e, dir

  collision = false

  # moves player collision rectangle in pressed direction to see if the player would collide if moved
  if dir == "up"
    p.colRect.y = p.y + p.dy
    collision = true if p.colRect.intersect_rect? e.colRect
  end


  if dir == "right"
    p.colRect.x = p.x + p.dx
    collision = true if p.colRect.intersect_rect? e.colRect
  end

  if dir == "down"
    p.colRect.y = p.y + p.dy
    collision = true if p.colRect.intersect_rect? e.colRect
  end

  if dir == "left"
    p.colRect.x = p.x + p.dx
    collision = true if p.colRect.intersect_rect? e.colRect
  end

  p.colRect.x, p.colRect.y = p.x, p.y 

  
  return collision
end

#detects collision within 1 pixel of the enemy
def enemeyCollision args, p, e
  collision = false
  collision = [e.colRect.x-1, e.colRect.y-1, e.colRect.w+2, e.colRect.h+2].intersect_rect? p.colRect
  return collision
end


def entityController args

  
  #Loop through players and process input, collision, and movement
  args.state.players.each do |p|

    #reset all player tick based variables
    upPressed, downPressed, rightPressed, leftPressed = false #true while pressed, used to remove input from input stack when button unpressed
    p.colDir.clear
    p.enemyColArray.clear
    p.col = false
    p.dx = 0
    p.dy = 0
    p.colRect.x, p.colRect.y = p.x, p.y
    moveSpeed = 5
    
    #Pushes up to input stack if pressed
    if args.inputs.up 
      upPressed = true
      args.state.keypressed.push("up")unless args.state.keypressed.include?("up") 
    end 

    #Pushes right to input stack if pressed
    if args.inputs.right 
      rightPressed = true
      args.state.keypressed.push("right") unless args.state.keypressed.include?("right")
    end
    
    #Pushes down to input stack
    if args.inputs.down 
      args.state.keypressed.push("down") unless args.state.keypressed.include?("down") 
      downPressed = true
    end     

    #Pushes left to input stack
    if args.inputs.left 
      args.state.keypressed.push("left") unless args.state.keypressed.include?("left")
      leftPressed = true
    end


    #Loop through input stack
    #  - set moveSpeed for each direction
    #  - dectects collision with enemies in each direction pressed
    #  - if collided in up/down or left/right, set dx or dy to 0
    args.state.keypressed.each do |k|

      p.dy = moveSpeed if k == "up"
      (p.dx = moveSpeed; p.spriteFlip = false) if k == "right"
      p.dy = -moveSpeed if k == "down" 
      (p.dx = -moveSpeed; p.spriteFlip = true) if k == "left"

      colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
      args.state.enemies.each do |e| 
        p.col = playerCollision(args, p, e, k) 
        e.col = enemeyCollision(args, p, e)
        (p.enemyColArray.push(e) unless p.enemyColArray.include?(e)) if e.col 
        colBuffer = true if p.col
      end
      p.col = colBuffer

      if ["up", "down"].include?(k)
        (p.dy = 0; args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if p.col
      end
      if ["right", "left"].include?(k)
        (p.dx = 0; args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if p.col
      end

    end

    #move player by movespeed in both up/down and left/right
    p.y += p.dy
    p.x += p.dx

    # move player healthbar with player
    p.healthbarUI.x = p.x
    p.healthbar.x = p.x
    p.healthbarUI.y = p.y - 30
    p.healthbar.y = p.y - 30

    #calculate player damage
    if p.healthbar.w > 20
      p.healthbar.w -=  (0.5 * (p.enemyColArray.length() - 0.2)
    elsif p.enemyColArray.length() > 0
      #p.hearts = 5 if p.hearts < 1
      p.hearts -= 1 if p.hearts > 1
      p.healthbar.w = ((p.hearts * 25) + (-5 * p.hearts + 20))
    end


      
    args.outputs.labels << [10, 560, "x/cx/dx, x/cy/dy: [#{p.x}/#{p.colRect.x}/#{p.dx}, #{p.y}/#{p.colRect.y}/#{p.dy}]"]

    # removes unpressed keys from the input stack
    (args.state.keypressed.delete("up") if args.state.keypressed.include?("up")) unless upPressed
    (args.state.keypressed.delete("right") if args.state.keypressed.include?("right")) unless rightPressed
    (args.state.keypressed.delete("down") if args.state.keypressed.include?("down")) unless downPressed
    (args.state.keypressed.delete("left") if args.state.keypressed.include?("left")) unless leftPressed

  
    args.outputs.borders << [p.colRect]
    args.outputs.borders << [p.x, p.y, p.w, p.h, 255, 0, 0]
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
    args.outputs.borders << [e.colRect.x-1, e.colRect.y-1, e.colRect.w+1, e.colRect.h+1]
  end

  #player sprite output
  args.state.players.each do |p|
    x = 4
    args.outputs.solids << [
      p.healthbar.x, 
      p.healthbar.y, 
      p.healthbar.w,
      p.healthbar.h,
      200,
      10,
      10
  ]
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