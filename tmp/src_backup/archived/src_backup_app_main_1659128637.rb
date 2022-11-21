# DragonRuby Hello World and Game Dev Learning Project
#
# Screen: 1280x720 (ALWAYS)
#
# Project brief: simple project to learn dragonruby and simple game development
# Goals: 
# [x] Player controlled Sprite with Colision and sprite animations.
# [x] player healthbar, player takes damage when touching enemy
# [ ] spawn enemies in random locations outside of x range of player
# [x] enemies move towards the player slowly
# [x] enemy collision
# [ ] player auto attack
# [ ] enemy damage
# [ ] world tiles

require 'app/entities.rb'

class Game
  attr_gtk
  attr_accessor :player, :enemyArray, :keypressed
  def defaults
    @keypressed ||= Array.new(0)
    @player ||= Player.new(movespeed: 10, id: 1, type: "player", x: 590, y: 250, w:75, h:75)
    @enemyArray  ||= [Enemy.new(id: 2, type: "bat", x: 100, y: 600, movespeed: 5),
                    Enemy.new(id: 3, type: "bat", x: 1100, y: 600, w:75, h:75),
                    Enemy.new(id: 4, type: "goblin", x: 300, y: 600),
                    Enemy.new(id: 5, type: "goblin", x: 400, y: 550),
                    Enemy.new(id: 6, type: "goblin", x: 500, y: 600),
                    Enemy.new(id: 7, type: "goblin", x: 900, y: 400),
                    Enemy.new(id: 8, type: "slime", x: 200, y: 100, w:55, h:55),
                    Enemy.new(id: 9, type: "slime", x: 200, y: 100, w:55, h:55),
                    Enemy.new(id: 10, type: "slime", x: 200, y: 90, w:90, h:90),
                    Enemy.new(id: 11, type: "slime", x: 201, y: 100, w:55, h:55)                  
                  ]
    @upPressed ||= false
    @downPressed ||= false
    @rightPressed ||= false
    @leftPressed ||= false #true while pressed, used to remove input from input stack when button unpressed

  end

  def detectInput
    @upPressed, @downPressed, @rightPressed, @leftPressed = false 

    #Pushes up to input stack if pressed
    if inputs.up 
      @upPressed = true
      @keypressed.push("up")unless @keypressed.include?("up") 
    end 

    #Pushes right to input stack if pressed
    if inputs.right 
      @rightPressed = true
      @keypressed.push("right") unless @keypressed.include?("right")
    end

    #Pushes down to input stack
    if inputs.down 
      @downPressed = true
      @keypressed.push("down") unless @keypressed.include?("down") 
    end     

    #Pushes left to input stack
    if inputs.left 
      @leftPressed = true
      @keypressed.push("left") unless @keypressed.include?("left")
    end

    if inputs.keyboard.key_down.escape
      reset
    end

    if inputs.keyboard.key_down.c
      @keypressed.include?("c") ? @keypressed.delete("c") : @keypressed.push("c")
     
    end
  end

  def entityUpdate
    #Loop through enemies, resetting variables, passing args, and process movement, collision, damage and other logic
    @enemyArray.each do |e|
      e.resetEntity
      e.movement(@player, @enemyArray)
    end

    #reset player states
    @player.resetEntity

    @player.playerMovement @keypressed, @enemyArray

    outputs.labels << {x: 10, y: 560, text: "x/cx/dx, x/cy/dy: [#{@player.x}/#{@player.colRect.x}/#{@player.dx}, #{@player.y}/#{@player.colRect.y}/#{@player.dy}]"}
    outputs.borders << @player.colRect
    outputs.borders << {x: @player.x, y: @player.y, w: @player.w, h: @player.h, r: 255, g: 0, b: 0}
    

    # removes unpressed keys from the input stack
    (@keypressed.delete("up") if @keypressed.include?("up")) unless @upPressed
    (@keypressed.delete("right") if @keypressed.include?("right")) unless @rightPressed
    (@keypressed.delete("down") if @keypressed.include?("down")) unless @downPressed
    (@keypressed.delete("left") if @keypressed.include?("left")) unless @leftPressed
  end

  def spriteAnimations
    frameSpeed ||= 5
    frameCount ||= 6
    entities = @enemyArray.dup
    entities.push(player)
  
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
  
      if (state.tick_count % frameSpeed) == 0
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
      outputs.sprites << { x: e.x, y: e.y, w: e.w, h: e.h, path: e.sprite, flip_horizontally: e.spriteDir == "left"}
      outputs.borders << {x: e.colRect.x-1, y: e.colRect.y-1, w: e.colRect.w+1, h: e.colRect.h+1}
    end
  
    #player sprite output
    outputs.solids << {
        x: @player.healthbar.x, 
        y: @player.healthbar.y, 
        w: @player.healthbar.w,
        h: @player.healthbar.h,
        r: 200,
        g: 10,
        b: 10
      }
    outputs.sprites << {
        x: @player.x,
        y: @player.y,
        w: @player.w,
        h: @player.h,
        path: @player.sprite,
        flip_horizontally: @player.spriteDir
      }
    outputs.sprites << {
        x: @player.healthbarUI.x, 
        y: @player.healthbarUI.y, 
        w: @player.healthbarUI.w, 
        h: @player.healthbarUI.h,
        path: @player.healthbarUI.path
      }
    diagnosticsLabels
  end

  def diagnosticsLabels
    #Stats Labels
    outputs.labels << {x: 10, y: 720, text: "Tick Counter: #{state.tick_count}"}
    outputs.labels << {x: 10, y: 700, text: "FPS: #{gtk.current_framerate.round}"}
    outputs.labels << {x: 10, y: 680, text: "SpriteID: #{@player.spriteID}"}
    outputs.labels << {x:10, y: 660, text: "Sprite: #{@player.sprite}"}
    outputs.labels << {x:10, y: 640, text: "Key Pressed: #{@keypressed}"}
    outputs.labels << {x:10, y: 620, text: "Animation: #{@player.spriteAnim}"}
    outputs.labels << {x:10, y: 600, text: "Player.dx: #{@player.dx}"}
    outputs.labels << {x:10, y: 580, text: "Player.dy: #{@player.dy}"}
    outputs.labels << {x:640, y: 50, text: "Press [c] to #{@keypressed.include?("c") ? "disable" : "enable"} player collision.", alignment_enum: 1}  
  end

  def tick
    defaults
    detectInput
    entityUpdate #player and npc update loop
    spriteAnimations #entities animation loops
    viewOutput
  end
end

def boot
  $game = Game.new
end

def tick args
  $game.args = args
  $game.tick
end

def reset
  $gtk.reset
  $game = Game.new
end

$gtk.reset