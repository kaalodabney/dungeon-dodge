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
    x: 640 - 50,
    y: 360 - 50,
    w: 100,
    h: 100,
    colRect: { x: 640 - 50, y: 360 - 50, w: 100, h: 100,},
    col: false,
    colDir: "",
    dx: 0,
    dy: 0,
    healthbarUI: {path: "sprites/dc16pp/ui/health_ui.png", x: 640-40, y: 360-75, w: 100, h: 20},
    hearts: 4,
    heartCounter: {x: 640-25, y: 360-50, w: 4*25, h: 20}
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
    colRect: { x: 350, y: 360 - 50, w: 100, h: 100,},
    col: false,
    colDir: "",
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
    colDir: "",
    dx: 0,
    dy: 0,
  },]
end


# player collision detection with player collision rectangles 
# accepts a player object and a keypress direction
# loops through enemies and moves only the player.colRect forward and detects if there would be a colision
# sets player.col to true/false
def playerCollisionRect args, p, dir
  p.colRect = {x: p.x, y: p.y, w: p.w, h: p.h}

    # predicts if a movement will cause a player to colide with an enemy, if so set collision to true for that player and colliding enemy  
    # - collision turned false again 
    args.state.enemies.each do |e|

      dir == "right" ? p.colRect.x = p.x + p.dx : nil
      dir == "left"  ? p.colRect.x = p.x - p.dx : nil
      dir == "up"    ? p.colRect.y = p.y + p.dy : nil
      dir == "down"  ? p.colRect.y = p.y - p.dy : nil

      (p.colRect.intersect_rect? e) ?  (p.colDir = dir; p.col = true) : nil
    
    end
end

# enemy collision detection
# loops through players, if intersecting with collision rectanges, set enemy.col to true/false
# enemy colRect is then explanded by 1 in each direction and continues to detect colision within this 1 pixel area outside of the actual enemy cooridnates
# when player moves away from enemy set e.col to false and shrink the e.colRect
def enemyCollision(args, e)
  args.state.players.each do |p|

    if e.colRect.intersect_rect? p.colRect
      if e.col == false
        e.colRect.x = e.x-1
        e.colRect.w = e.w+2
        e.colRect.y = e.y-1
        e.colRect.h = e.h+2
      end
      e.col = true
    else
      e.col = false
      e.colRect.x = e.x
      e.colRect.w = e.w
      e.colRect.y = e.y
      e.colRect.h = e.h  
    end
  end
end


def actorController args

  # Loop through players and process input, collision, and movement
  args.state.players.each do |p|

    upPressed, downPressed, rightPressed, leftPressed = false
    moveSpeed = 5
    
    # right movement and animation state change
    if args.inputs.right 
      args.state.keypressed.push("right") unless args.state.keypressed.include?("right") 
      playerCollisionRect(args, p, "right")
      p.spriteFlip = false
      rightPressed = true
    end
    # left movement and animation state change
    if args.inputs.left 
      p.dx = moveSpeed
      args.state.keypressed.push("left") unless args.state.keypressed.include?("left") 
      playerCollisionRect(args, p, "left")
      p.spriteFlip = true
      leftPressed = true
    end
    # up movement and animation state change   
    if args.inputs.up 
      p.dy = moveSpeed
      args.state.keypressed.push("up") unless args.state.keypressed.include?("up") 
      playerCollisionRect(args, p, "up")
      upPressed = true
    end 
    # down movement and animation state change
    if args.inputs.down 
      p.dy = moveSpeed
      args.state.keypressed.push("down") unless args.state.keypressed.include?("down") 
      playerCollisionRect(args, p, "down")

      downPressed = true
    end  

    # if player not pressing (up/down) or (left/right), set (y/x) speed to 0
    args.state.keypressed.include?("up") || args.state.keypressed.include?("down") ? p.dy = 0 : p.dy = moveSpeed
    args.state.keypressed.include?("right") || args.state.keypressed.include?("left") ? p.dx = 0 : p.dx = moveSpeed

    p.x += p.dx 
    p.x -= p.dx
    p.y += p.dy
    p.y -= p.dy

    p.col = false

    upPressed    ? nil : args.state.keypressed.delete("up")
    downPressed  ? nil : args.state.keypressed.delete("down")
    rightPressed ? nil : args.state.keypressed.delete("right")
    leftPressed  ? nil : args.state.keypressed.delete("left")



    # move player healthbar with player
    p.healthbarUI.x = p.x
    p.healthbarUI.y = p.y - 30
    
    #loop through each enemy and run their collision detection method
    args.state.enemies.each { |e| enemyCollision(args, e)}

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
    args.outputs.labels << [10, 560, "Player.col: #{args.state.players[0].col ? "Collision Detected": "false"}"]
end






