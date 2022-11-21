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
$gtk.reset

class Entity

  attr_accessor :x, :y, :w, :h, :sprite, :spriteDir, :colRect
  def initialize args, type, x, y, w, h, spriteAnim = "idle", spriteDir = "right"
    @args = args
    @type = type
    @x =  x
    @y =  y
    @w =  w
    @h =  h
    @colRect = { x: x, y: y, w: w, h: h}
    @col = false
    @colDir = Array.new(0)
    @dx = 0
    @dy = 0   
    @spriteAnim = spriteAnim
    @spriteDir = spriteDir
    @spriteID = 0                       
  end
end

class Player < Entity

  attr_accessor :healthbar, :healthbarUI
  def initialize args, x, y, w=100, h=100
    super(args, "player", x, y, w, h)
    @healthbar = {x: x+25, y: y+60, w: 100, h: 20, r: 225, g: 0, b: 0}
    @healthbarUI = {path: "sprites/dc16pp/ui/health_ui.png", x: x+80, y: y+185, w: 100, h: 20}
    @hearts = 4
    @enemyColArray = [] 
  end
end

class Enemy < Entity
  def initialize args, type, x, y, w=100, h=100
    super(args, type, x, y, w, h)

  end
end

class Game

  def initialize args
    @args = args
    @keypressed = Array.new(0)
    @playerArray = [ Player.new(args, 590, 250)]
    @enemyArray = [
      Enemy.new(args, "goblin", 100, 400),
      Enemy.new(args, "bat", 200, 400),
      Enemy.new(args, "bat", 300, 400),
      Enemy.new(args, "bat", 400, 400),
      Enemy.new(args, "slime", 500, 400),
      Enemy.new(args, "slime", 600, 400),
      Enemy.new(args, "slime", 900, 400, 200, 200)
    ]

  end

  def viewOutput

    #enemies sprite output
    @enemyArray.each do |e|
      @args.outputs.sprites << {
        x: e.x,
        y: e.y,
        w: e.w,
        h: e.h,
        path: e.sprite,
        flip_horizontally: e.spriteDir == "left"
      }
      @args.outputs.borders << [e.colRect.x-1, e.colRect.y-1, e.colRect.w+1, e.colRect.h+1]
    end
  
    #player sprite output
    @playerArray.each do |p|
      @args.outputs.solids << [
        p.healthbar.x, 
        p.healthbar.y, 
        p.healthbar.w,
        p.healthbar.h,
        200,
        10,
        10
    ]
      @args.outputs.sprites << {
        x: p.x,
        y: p.y,
        w: p.w,
        h: p.h,
        path: p.sprite,
        flip_horizontally: p.spriteDir
      }
      @args.outputs.sprites << {
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
    @args.outputs.labels << [10, 720, "Tick Counter: #{@args.state.tick_count}"]
    @args.outputs.labels << [10, 700, "FPS: #{@args.gtk.current_framerate.round}"]
    @args.outputs.labels << [10, 680, "SpriteID: #{self.playerArray[0].spriteID}"]
    @args.outputs.labels << [10, 660, "Sprite: #{self.playerArray[0].sprite}"]
    @args.outputs.labels << [10, 640, "Key Pressed: #{self.keypressed}"]
    @args.outputs.labels << [10, 620, "Animation: #{self.playerArray[0].spriteAnim}"]
    @args.outputs.labels << [10, 600, "Player.dx: #{self.playerArray[0].dx}"]
    @args.outputs.labels << [10, 580, "Player.dy: #{self.playerArray[0].dy}"]  
  end

  def tick
    #entityUpdate #player and npc update loop
    #spriteAnimations #entities animation loops
    viewOutput
  end
end


def tick args

  args.state.game ||= Game.new args
  args.state.game.tick
end

# new code
###########################################################################################################
# old code 

# def init args
#   args.state.debug ||= {tog: false, val: ""}
#   args.state.keypressed ||= Array.new(0)
#   #initialize array of players
#   args.state.players ||= [
#     player1: {
#       type: "player",
#       spriteAnim: "idle",
#       spriteFlip: false, # facing right = false, facing left = true
#       spriteID: 0,
#       x: 590,
#       y: 250,
#       w: 100,
#       h: 100,
#       colRect: { x: .x, y: 250, w: 100, h: 100,},
#       col: false,
#       colDir: Array.new(0),
#       dx: 0,
#       dy: 0,                               
#       healthbar: {x: 615, y: 310, w: 100, h: 20, r: 225, g: 0, b: 0},
#       healthbarUI: {path: "sprites/dc16pp/ui/health_ui.png", x: 640-40, y: 360-75, w: 100, h: 20},
#       hearts: 4,
#       enemyColArray: [] 
#     }
#   ]

#   enemyLineX = 100
#   enemyLineY = 400

#   # initialize array of enemies
#   args.state.enemies ||= [
#     enemy0: {  
#     type: "goblin",
#     spriteAnim: "idle",
#     spriteFlip: false,
#     spriteID: 0,
#     x: 100,
#     y: 400,
#     w: 100,
#     h:  100,
#     colRect: { x: 100, y: 400, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 1,
#     type: "bat",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX + 100,
#     y: enemyLineY,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX + 100, y: enemyLineY, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 2,
#     type: "bat",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX + 200,
#     y: enemyLineY,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX + 200, y: enemyLineY, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 3,
#     type: "slime",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX + 300,
#     y: enemyLineY,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX + 300, y: enemyLineY, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 4,
#     type: "slime",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX + 400,
#     y: enemyLineY,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX + 400, y: enemyLineY, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 5,
#     type: "slime",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX,
#     y: enemyLineY-100,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX, y: enemyLineY-100, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   },{
#     id: 6,
#     type: "slime",
#     spriteAnim: "idle",
#     spriteFlip: true,
#     spriteID: 0,
#     x: enemyLineX,
#     y: enemyLineY-250,
#     w: 100,
#     h:  100,
#     colRect: { x: enemyLineX, y: enemyLineY-250, w: 100, h: 100,},
#     col: false,
#     colDir: Array.new(0),
#     dx: 0,
#     dy: 0,
#   }]
# end


# # Loops through all entities and detects collision with player and direction
# # inputs: args, player object, enemy, keypressed direction
# # outputs: true/false
# def playerCollision args, p, e, dir

#   collision = false

#   # moves player collision rectangle in pressed direction to see if the player would collide if moved
#   if dir == "up"
#     p.colRect.y = p.y + p.dy
#     collision = true if p.colRect.intersect_rect? e.colRect
#   end


#   if dir == "right"
#     p.colRect.x = p.x + p.dx
#     collision = true if p.colRect.intersect_rect? e.colRect
#   end

#   if dir == "down"
#     p.colRect.y = p.y + p.dy
#     collision = true if p.colRect.intersect_rect? e.colRect
#   end

#   if dir == "left"
#     p.colRect.x = p.x + p.dx
#     collision = true if p.colRect.intersect_rect? e.colRect
#   end

#   p.colRect.x, p.colRect.y = p.x, p.y 

  
#   return collision
# end

# #detects collision within 1 pixel of the enemy
# def enemyCollision args, p, e
#   collision = false
#   collision = [e.colRect.x-1, e.colRect.y-1, e.colRect.w+2, e.colRect.h+2].intersect_rect? p.colRect
#   return collision
# end


# def entityController args

  
#   #Loop through players and process input, collision, and movement
#   args.state.players.each do |p|

#     #reset all player tick based variables
#     upPressed, downPressed, rightPressed, leftPressed = false #true while pressed, used to remove input from input stack when button unpressed
#     p.colDir.clear
#     p.enemyColArray.clear
#     p.col = false
#     p.dx = 0
#     p.dy = 0
#     p.colRect.x, p.colRect.y = p.x, p.y
#     moveSpeed = 5
    
#     #Pushes up to input stack if pressed
#     if args.inputs.up 
#       upPressed = true
#       args.state.keypressed.push("up")unless args.state.keypressed.include?("up") 
#     end 

#     #Pushes right to input stack if pressed
#     if args.inputs.right 
#       rightPressed = true
#       args.state.keypressed.push("right") unless args.state.keypressed.include?("right")
#     end
    
#     #Pushes down to input stack
#     if args.inputs.down 
#       args.state.keypressed.push("down") unless args.state.keypressed.include?("down") 
#       downPressed = true
#     end     

#     #Pushes left to input stack
#     if args.inputs.left 
#       args.state.keypressed.push("left") unless args.state.keypressed.include?("left")
#       leftPressed = true
#     end


#     #Loop through input stack
#     #  - set moveSpeed for each direction
#     #  - dectects collision with enemies in each direction pressed
#     #  - if collided in up/down or left/right, set dx or dy to 0
#     args.state.keypressed.each do |k|

#       p.dy = moveSpeed if k == "up"
#       (p.dx = moveSpeed; p.spriteFlip = false) if k == "right"
#       p.dy = -moveSpeed if k == "down" 
#       (p.dx = -moveSpeed; p.spriteFlip = true) if k == "left"

#       colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
#       args.state.enemies.each do |e| 
#         p.col = playerCollision(args, p, e, k) 
#         e.col = enemyCollision(args, p, e)
#         (p.enemyColArray.push(e) unless p.enemyColArray.include?(e)) if e.col 
#         colBuffer = true if p.col
#       end
#       p.col = colBuffer

#       if ["up", "down"].include?(k)
#         (p.dy = 0; args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if p.col
#       end
#       if ["right", "left"].include?(k)
#         (p.dx = 0; args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if p.col
#       end

#     end

#     #move player by movespeed in both up/down and left/right
#     p.y += p.dy
#     p.x += p.dx

#     # move player healthbar with player
#     p.healthbarUI.x = p.x
#     p.healthbar.x = p.x
#     p.healthbarUI.y = p.y - 30
#     p.healthbar.y = p.y - 30

#     #calculate player damage
#     if p.healthbar.w > 20 && p.enemyColArray.length() > 0
#       p.healthbar.w -=  (0.5 * (p.enemyColArray.length() - (0.2 * p.enemyColArray.length())))
#     elsif p.enemyColArray.length() > 0
#       #p.hearts = 5 if p.hearts < 1
#       p.hearts -= 1 if p.hearts > 1
#       p.healthbar.w = ((p.hearts * 25) + (-5 * p.hearts + 20))
#     end


      
#     args.outputs.labels << [10, 560, "x/cx/dx, x/cy/dy: [#{p.x}/#{p.colRect.x}/#{p.dx}, #{p.y}/#{p.colRect.y}/#{p.dy}]"]

#     # removes unpressed keys from the input stack
#     (args.state.keypressed.delete("up") if args.state.keypressed.include?("up")) unless upPressed
#     (args.state.keypressed.delete("right") if args.state.keypressed.include?("right")) unless rightPressed
#     (args.state.keypressed.delete("down") if args.state.keypressed.include?("down")) unless downPressed
#     (args.state.keypressed.delete("left") if args.state.keypressed.include?("left")) unless leftPressed

  
#     args.outputs.borders << [p.colRect]
#     args.outputs.borders << [p.x, p.y, p.w, p.h, 255, 0, 0]
#   end

# end

# def spriteAnimations args

#   frameSpeed ||= 5
#   frameCount ||= 6

# entities = args.state.players + args.state.enemies


#   # increment each entity sprite every x ticks
#   entities.each do |e|

#     if e.type == "player"
#       frameSpeed = 5
#       frameCount = 6
#       (e.dy == 0 && e.dx == 0) ?  e.spriteAnim = "idle" : e.spriteAnim = "walk"
#       e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{e.spriteID}.png" : nil
#       e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{e.spriteID}.png" : nil
     
   
#     elsif e.type == "goblin"
#       frameSpeed = 5
#       frameCount = 6
#       e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
#       e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" if e.spriteAnim == "idle"
#       e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
    
#     elsif e.type == "slime"
#       frameCount = 6
#       e.col ? frameSpeed = 4 : frameSpeed = 10
#       e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
#       e.sprite = "sprites/dc16pp/enemies/slime/slime_idle_anim_f#{e.spriteID}.png"  if e.spriteAnim == "idle"
#       e.sprite = "sprites/dc16pp/enemies/slime/slime_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
   
#     elsif e.type == "bat"
#       frameCount = 4
#       e.col ? frameSpeed = 4 : frameSpeed = 10
#       e.sprite = "sprites/dc16pp/enemies/flying creature/fly_anim_f#{e.spriteID}.png"
#     end

#     if (args.state.tick_count % frameSpeed) == 0
#       e.spriteID += 1
#       if e.spriteID >= frameCount
#         e.spriteID = 0
#       end
#     end
#   end

#   # increment each enemy sprite every x/y ticks based on enemy type
#   # args.state.enemies.each do |e|

#   #   args.outputs.labels << [900, 520 - (e.id * 20), "[sID:#{e.spriteID}, id:#{e.id}, et: #{e.type}], "] 
#   #   if e.type == "goblin" || e.type == "slime"
#   #     if args.state.tick_count % x.speed == 0
#   #       e.spriteID += 1
#   #       if e.spriteID > x.count
#   #         e.spriteID = 0
#   #       end
#   #     end
#   #   end
    
#   #   if e.type == "bat"
#   #     if args.state.tick_count % y.speed == 0
#   #        e.spriteID += 1
#   #       if e.spriteID > y.count
#   #           e.spriteID = 0
#   #       end
#   #     end
#   #   end

#   # end

#  #loop through npcs, set sprite path depending on current spriteAnim and enemyType
#   args.state.enemies.each do |e|
    
#   end

#  #set player sprite path depending on current spriteAnim
#  args.state.players.each do |p|
#  end
# end




# def diagnosticsLabels args
#     #Stats Labels
#     args.outputs.labels << [10, 720, "Tick Counter: #{args.state.tick_count}"]
#     args.outputs.labels << [10, 700, "FPS: #{args.gtk.current_framerate.round}"]
#     args.outputs.labels << [10, 680, "SpriteID: #{args.state.players[0].spriteID}"]
#     args.outputs.labels << [10, 660, "Sprite: #{args.state.players[0].sprite}"]
#     args.outputs.labels << [10, 640, "Key Pressed: #{args.state.keypressed}"]
#     args.outputs.labels << [10, 620, "Animation: #{args.state.players[0].spriteAnim}"]
#     args.outputs.labels << [10, 600, "Player.dx: #{args.state.players[0].dx}"]
#     args.outputs.labels << [10, 580, "Player.dy: #{args.state.players[0].dy}"]
    
# end