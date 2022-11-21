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
  attr_accessor :playerArray, :enemyArray, :keypressed
  def initialize args
    @args = args
    @keypressed = Array.new(0)
    @playerArray = [Player.new(args, 1, 590, 250, 75, 75)]
    @enemyArray  = [Enemy.new(args, 2, "bat", 100, 600, 75, 75),
                    Enemy.new(args, 3, "bat", 1100, 600, 75, 75),
                    Enemy.new(args, 4, "goblin", 300, 600, 50, 50),
                    Enemy.new(args, 5, "goblin", 400, 550, 50, 50),
                    Enemy.new(args, 6, "goblin", 500, 600, 50, 50),
                    Enemy.new(args, 7, "goblin", 900, 400),
                    Enemy.new(args, 8, "slime", 200, 100, 85, 85),
                    Enemy.new(args, 9, "slime", 200, 100, 85, 85),
                    Enemy.new(args, 10, "slime", 200, 100, 85, 85),
                  
                  ]
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

    if @args.inputs.keyboard.key_down.escape
      $gtk.reset
    end
  end

  def entityUpdate args
    #reset game states
    @upPressed, @downPressed, @rightPressed, @leftPressed = false 
    detectInput #detects player input and pushes to input stack

    #Loop through enemies and process movement, collision, damage and other logic
    @enemyArray.each do |e|
      e.resetEntity 


      e.movement(@playerArray[0], @enemyArray)
    end

    #Loop through players and process movement, collision, damage, and other logic
    @playerArray.each do |p|
      #reset player states
      p.colArray.clear
      p.colDir.clear
      p.col = false
      p.dx = 0
      p.dy = 0
      p.colRect.x, p.colRect.y = p.x, p.y
      
      p.movement(keypressed, self.enemyArray)

      @args.outputs.labels << {x: 10, y: 560, text: "x/cx/dx, x/cy/dy: [#{p.x}/#{p.colRect.x}/#{p.dx}, #{p.y}/#{p.colRect.y}/#{p.dy}]"}
      @args.outputs.borders << p.colRect
      @args.outputs.borders << {x: p.x, y: p.y, w: p.w, h: p.h, r: 255, g: 0, b: 0}
    end

    # removes unpressed keys from the input stack
    (@keypressed.delete("up") if @keypressed.include?("up")) unless @upPressed
    (@keypressed.delete("right") if @keypressed.include?("right")) unless @rightPressed
    (@keypressed.delete("down") if @keypressed.include?("down")) unless @downPressed
    (@keypressed.delete("left") if @keypressed.include?("left")) unless @leftPressed
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
        e.sprite = "sprites/dc16pp/heroes/knight/knight_idle_anim_f#{e.spriteID}.png" if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/heroes/knight/knight_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk" 
       
      elsif e.type == "goblin"
        frameSpeed = 5
        frameCount = 6
        (e.dy == 0 && e.dx == 0) ?  e.spriteAnim = "idle" : e.spriteAnim = "walk"
        e.sprite = "sprites/dc16pp/enemies/goblin/goblin_idle_anim_f#{e.spriteID}.png" if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/enemies/goblin/goblin_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
      
      elsif e.type == "slime"
        frameCount = 6
        frameSpeed = 3
        (e.dy == 0 && e.dx == 0) ?  e.spriteAnim = "idle" : e.spriteAnim = "walk"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_idle_anim_f#{e.spriteID}.png"  if e.spriteAnim == "idle"
        e.sprite = "sprites/dc16pp/enemies/slime/slime_run_anim_f#{e.spriteID}.png" if e.spriteAnim == "walk"
      
      elsif e.type == "slime-L"
        frameCount = 6
        e.col ? frameSpeed = 3 : frameSpeed = 10
        (e.dy == 0 && e.dx == 0) ?  e.spriteAnim = "idle" : e.spriteAnim = "walk"
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
      @args.outputs.borders << {x: e.colRect.x-1, y: e.colRect.y-1, w: e.colRect.w+1, h: e.colRect.h+1}
    end
  
    #player sprite output
    @playerArray.each do |p|
      @args.outputs.solids << {
        x: p.healthbar.x, 
        y: p.healthbar.y, 
        w: p.healthbar.w,
        h: p.healthbar.h,
        r: 200,
        g: 10,
        b: 10
      }
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
    @args.outputs.labels << {x: 10, y: 720, text: "Tick Counter: #{@args.state.tick_count}"}
    @args.outputs.labels << {x: 10, y: 700, text: "FPS: #{@args.gtk.current_framerate.round}"}
    @args.outputs.labels << {x: 10, y: 680, text: "SpriteID: #{@playerArray[0].spriteID}"}
    @args.outputs.labels << {x:10, y: 660, text: "Sprite: #{@playerArray[0].sprite}"}
    @args.outputs.labels << {x:10, y: 640, text: "Key Pressed: #{@keypressed}"}
    @args.outputs.labels << {x:10, y: 620, text: "Animation: #{@playerArray[0].spriteAnim}"}
    @args.outputs.labels << {x:10, y: 600, text: "Player.dx: #{@playerArray[0].dx}"}
    @args.outputs.labels << {x:10, y: 580, text: "Player.dy: #{@playerArray[0].dy}"}  
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
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end