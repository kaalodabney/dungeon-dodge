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
    debugVal1: "wait",
    debugTog1: false,
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


# Loops through all entitiees and detects collision with player and direction
# inputs: args, player object, enemy, keypressed direction
# outputs: true/false
def playerCollision args, p, e, dir

  collision = false

  # moves player collision rectangle in pressed direction to see if the player would collide if they moved there
  #up, right, down, left = false


  if dir == up
    p.colRect.y = p.y + p.dy
    collision = true if p.colRect.intersect_rect? e.colRect
    p.colRect.


  if dir == right

  if dir == left

  if dir == down


  ##############################################################################################################################################
  # reverse the input stack to detect collision in a single direction, starting with the last input added to the stack
  # args.state.keypressed.each do |k|
  #   p.colRect.x, p.colRect.y = p.x, p.y 
  #   if k == "up"
  #     p.colRect.y = p.y + p.dy
  #     if p.colRect.intersect_rect? e.colRect
  #       p.colDir.push("up")
  #       collision = true
  #     end
  #     p.colRect.y = p.y
  #   end

  #   if k == "right"
  #     p.colRect.x = p.x + p.dx
  #     if p.colRect.intersect_rect? e.colRect
  #       p.colDir.push("right")
  #       collision = true
  #     end
  #     p.colRect.x = p.x
  #   end

  #   if k == "down" 
  #     p.colRect.y = p.y - p.dy
  #     if p.colRect.intersect_rect? e.colRect
  #       p.colDir.push("down")
  #     end
  #     p.colRect.y = p.y
  #   end

  #   if k == "left"
  #     p.colRect.x = p.x - p.dx
  #     if p.colRect.intersect_rect? e.colRect
  #       p.colDir.push("left")
  #       collision = true
  #     end
  #     p.colRect.x = p.x
  #   end
  #   p.colRect.x, p.colRect.y = p.x, p.y 
  # end


  ##############################################################################################################################################
  ##############################################################################################################################################

  # if args.state.keypressed.include?("up")
  #   p.colRect.y = p.y + p.dy
  #   up = true
  # end
  
  # if args.state.keypressed.include?("right")
  #   p.colRect.x = p.x + p.dx
  #   right = true
  # end

  # if args.state.keypressed.include?("down")
  #   p.colRect.y = p.y + p.dy
  #   down = true
  # end

  # if args.state.keypressed.include?("left")
    
  #   if p.debugTog4
  #     p.debugVal4 += 1
  #   end
    
  #   p.colRect.x = (p.x + p.dx)
  #   p.debugTog1 ? (p.debugTog1 = true) : (p.debugVal1 = [p.colRect.x, p.x, p.dx]; p.debugTog1 = true)
  #   left = true
  # end

  # if p.colRect.intersect_rect? e.colRect
  #   p.debugTog2 ? (p.debugTog2 = true) : (p.debugVal2 = [p.colRect.x, p.x]; p.debugTog2 = true)
  #    if up
  #   p.colDir.push("right") if right
  #   p.colDir.push("down") if down
  #   p.colDir.push("left") if left
  #   collision = true
  #   p.debugTog4 = false
  # end


#############################################################################################################################################################
   




  



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
    args.outputs.labels << [10, 120, "[colRect.x, p.x]: First Left input (before collision check): #{p.debugVal3}"]
    args.outputs.labels << [10, 100, "[colRect.x, p.x]: keypressed array includes left (in playerCollision): #{p.debugVal1} (colRect.x should be 585, p.xx should be 590)"]
    args.outputs.labels << [10, 80, "left input count (in playerCollision): #{p.debugVal4}"]
    
    
    upPressed, downPressed, rightPressed, leftPressed = false
    
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
      p.debugTog3 ? (p.debugTog3 = true) : (p.debugVal3 = [p.colRect.x, p.x]; p.debugTog3 = true)
    end


    args.state.keypressed.each do |k|
      p.dy = moveSpeed if k == "up"
      (p.dx = moveSpeed; p.spriteFlip = false) if k == "right"
      p.dy = -moveSpeed if k == "down" 
      (p.dx = -moveSpeed; p.spriteFlip = true) if k == "left"
    end



    # Loop through each enemy and detect collision
    colBuffer = false ##creating a buffer to detect if collision is true for ANY enemies, not just the last one
    args.state.enemies.each do |e| 
      p.col = playerCollision(args, p, e, dir) 
      colBuffer = true if p.col
      args.outputs.labels << [10, 560, "p.colCollision: #{p.col}"]
    end
    p.col = colBuffer
                                                                                                                                                          args.outputs.labels << [10, 540, "p.colDir: #{p.colDir}"]
                                                                                                                                                          args.outputs.labels << [10, 40, "p.x|p.colRect.x|p.dx, p.y|p.colRect.x|p.dy: #{p.x}|#{p.colRect.x}|#{p.dx} #{p.y}|#{p.colRect.y}|#{p.dy}"]
    # removes unpressed keys from the input stack
    (args.state.keypressed.delete("up") if args.state.keypressed.include?("up")) unless upPressed
    (args.state.keypressed.delete("right") if args.state.keypressed.include?("right")) unless rightPressed
    (args.state.keypressed.delete("down") if args.state.keypressed.include?("down")) unless downPressed
    (args.state.keypressed.delete("left") if args.state.keypressed.include?("left")) unless leftPressed




    p.colDir.each do |dir|
      p.dx = 0 if ["right", "left"].include?(dir)
      p.dy = 0 if ["up", "down"].include?(dir)
    end

    # if p.col
    #   args.outputs.labels << [10, 140, "dx/dy: #{p.dx}/#{p.dy}"]
    #   p.dx = 0 if (p.colDir & ["right", "left"]).any?
    #   p.dy = 0 if (p.colDir & ["up", "down"]).any?
    #   args.outputs.labels << [10, 160, "dx/dy: #{p.dx}/#{p.dy}"]
    # end


  

    
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