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
require 'app/entities.rb'

class Game
  def initialize args
    @args = args
    @keypressed = Array.new(0)
    @playerArray = [Player.new(args, 590, 250)]
    @enemyArray  = [Enemy.new(args, "goblin", 100, 400),
                    Enemy.new(args, "bat", 200, 400),
                    Enemy.new(args, "bat", 300, 400),
                    Enemy.new(args, "bat", 400, 400),
                    Enemy.new(args, "slime", 500, 400),
                    Enemy.new(args, "slime", 600, 400),
                    Enemy.new(args, "slime-L", 900, 400, 200, 200)]
    @upPressed, @downPressed, @rightPressed, @leftPressed = false #true while pressed, used to remove input from input stack when button unpressed

  end

  def detectInput
    #Pushes up to input stack if pressed
    if @args.inputs.up 
      @upPressed = true
      @keypressed.push("up")unless @keypressed.include?("up") 
    end 

    #Pushes right to input stack if pressed
    if @args.inputs.right 
      @rightPressed = true
      @keypressed.push("right") unless @keypressed.include?("right")
    end

    #Pushes down to input stack
    if @args.inputs.down 
      @downPressed = true
      @keypressed.push("down") unless @keypressed.include?("down") 
    end     

    #Pushes left to input stack
    if @args.inputs.left 
      @leftPressed = true
      @keypressed.push("left") unless @keypressed.include?("left")
    end
  end

  def entityUpdate args
    #reset game states
    @upPressed, @downPressed, @rightPressed, @leftPressed = false 
    detectInput #detects player input and pushes to input stack

    #Loop through players and process movement, collision, damage, and other logic
    @playerArray.each do |p|
      #reset player states
      p.colDir.clear
      p.colArray.clear
      p.col = false
      p.dx = 0
      p.dy = 0
      p.colRect.x, p.colRect.y = p.x, p.y
      
      p.playerMovement @keypressed, @enemyArray
      p.playerDamage

      @args.outputs.labels << [10, 560, "x/cx/dx, x/cy/dy: [#{p.x}/#{p.colRect.x}/#{p.dx}, #{p.y}/#{p.colRect.y}/#{p.dy}]"]
      @args.outputs.borders << [p.colRect]
      @args.outputs.borders << [p.x, p.y, p.w, p.h, 255, 0, 0]
    end

    # removes unpressed keys from the input stack
    (@keypressed.delete("up") if @keypressed.include?("up")) unless @upPressed
    (@keypressed.delete("right") if @keypressed.include?("right")) unless @rightPressed
    (@keypressed.delete("down") if @keypressed.include?("down")) unless @downPressed
    (@keypressed.delete("left") if @keypressed.include?("left")) unless @leftPressed

    #Loop through enemies and process movement, collision, damage and other logic
    @enemyArray.each do |e|
      #enemy collision detection
      @playerArray.each do |p|
        e.enemyCollision(p)
      end
      e.enemyMovement


    end
    
  

  end

  def spriteAnimations
    frameSpeed ||= 5
    frameCount ||= 6
    entities = @playerArray + @enemyArray
  
    # increment each entity sprite every x ticks
    entities.each do |e|
  
      if e.type == "player"
        frameSpeed = 5
        frameCount = 6
        (e.dy == 0 && e.dx == 0) ?  e.spriteAnim = "idle" : e.spriteAnim = "walk"
        e.spriteAnim == "idle" ? e.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{e.spriteID}.png" : nil
        e.spriteAnim == "walk" ? e.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{e.spriteID}.png" : nil
       
      elsif e.type == "goblin"
        frameSpeed = 5
        frameCount = 6
        e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
        e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
      
      elsif e.type == "slime"
        frameCount = 6
        e.col ? frameSpeed = 2 : frameSpeed = 5
        e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_idle_anim_f#{e.spriteID}.png"  if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
      
      elsif e.type == "slime-L"
        frameCount = 6
        e.col ? frameSpeed = 3 : frameSpeed = 10
        e.col ? e.spriteAnim = "walk" : e.spriteAnim = "idle"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_idle_anim_f#{e.spriteID}.png"  if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"

      elsif e.type == "bat"
        frameCount = 4
        e.col ? frameSpeed = 3 : frameSpeed = 5
        e.sprite = "sprites/dc16pp/enemies/flying creature/fly_anim_f#{e.spriteID}.png"
      end
  
      if (@args.state.tick_count % frameSpeed) == 0
        e.spriteID += 1
        if e.spriteID >= frameCount
          e.spriteID = 0
        end
      end
    end  
  end

  def viewOutput
    #enemies sprite output
    @enemyArray.each do |e|
      @args.outputs.sprites << { x: e.x, y: e.y, w: e.w, h: e.h, path: e.sprite, flip_horizontally: e.spriteDir == "left"}
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
    diagnosticsLabels
  end

  def diagnosticsLabels
    #Stats Labels
    @args.outputs.labels << [10, 720, "Tick Counter: #{@args.state.tick_count}"]
    @args.outputs.labels << [10, 700, "FPS: #{@args.gtk.current_framerate.round}"]
    @args.outputs.labels << [10, 680, "SpriteID: #{@playerArray[0].spriteID}"]
    @args.outputs.labels << [10, 660, "Sprite: #{@playerArray[0].sprite}"]
    @args.outputs.labels << [10, 640, "Key Pressed: #{@keypressed}"]
    @args.outputs.labels << [10, 620, "Animation: #{@playerArray[0].spriteAnim}"]
    @args.outputs.labels << [10, 600, "Player.dx: #{@playerArray[0].dx}"]
    @args.outputs.labels << [10, 580, "Player.dy: #{@playerArray[0].dy}"]  
  end

  def tick args
    entityUpdate args#player and npc update loop
    spriteAnimations #entities animation loops
    viewOutput
  end
end

def tick args

  args.state.game ||= Game.new args
  args.state.game.tick args
end