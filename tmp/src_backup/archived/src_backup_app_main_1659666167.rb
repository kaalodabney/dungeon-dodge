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
# [x] player auto attack
# [x] enemy damage and death
# [ ] world tiles

require 'app/entities.rb'
require 'lib/tiled/tiled.rb'

class Game
  attr_gtk
  attr_accessor :player, :enemyArray, :keypressed, :bombArray, :entityCount, :map
  def defaults
    @keypressed ||= Array.new(0)
    @entityCount ||= 0
    @player ||= Player.new(id: @entityCount, type: "player", x: 590, y: 250, w:75, h:75, movespeed: 6)
    @entityCount += 1
    @entityArray  ||= [ @player,
                    Enemy.new(id: @entityCount, type: "bat", x: 100, y: 600, movespeed: 3),
                    Enemy.new(id: @entityCount+1, type: "slime", x: 1100, y: 600, w:75, h:75),
                    Enemy.new(id: @entityCount+2, type: "goblin", x: 300, y: 600, movespeed: 2),
                    Enemy.new(id: @entityCount+3, type: "bat", x: 400, y: 550, movespeed: 3),
                    Enemy.new(id: @entityCount+4, type: "slime", x: 500, y: 600),
                    Enemy.new(id: @entityCount+5, type: "bat", x: 900, y: 400),
                    Enemy.new(id: @entityCount+6, type: "goblin", x: 200, y: 100, w:55, h:55),
                    Enemy.new(id: @entityCount+7, type: "bat", x: 200, y: 100, w:55, h:55),
                    Enemy.new(id: @entityCount+8, type: "slime", x: 200, y: 90, w:90, h:90),
                    Enemy.new(id: @entityCount+9, type: "bat", x: 201, y: 100, w:55, h:55)                  
                  ]
    @entityCount += 10              
    @upPressed ||= false
    @downPressed ||= false
    @rightPressed ||= false
    @leftPressed ||= false #true while pressed, used to remove input from input stack when button unpressed
    @shift ||= false
    @map ||= Tiled::Map.new("maps/dungeon.tmx")
    
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

    if inputs.keyboard.key_down.shift
      @shift = !@shift
    end

    # if inputs.keyboard.key_held.space
    #   if (state.tick_count % 20) == 0
    #     @entityArray.push(Bomb.new(id: @entityCount, x: @player.x, y: @player.y))
    #     @entityCount += 1
    #   end
    # end

    if inputs.keyboard.key_down.space
      @entityArray.push(Bomb.new(id: @entityCount, x: @player.x, y: @player.y))
      @entityCount += 1
    end

    if inputs.keyboard.key_down.escape
      reset
    end

    # player collision toggle
    if inputs.keyboard.key_down.c
      @keypressed.include?("c") ? @keypressed.delete("c") : @keypressed.push("c")
    end
  end

  def deleteEntity e
    @entityCount
  end

  def enemyDead enemy
    poof = Effect.new(id: @entityCount, type: "enemyDeath", x: enemy.x, y: enemy.y, w: enemy.w, h: enemy.h)
    @entityArray.push(poof)
    @entityCount += 1
    @entityArray.delete(enemy)
    @entityCount -= 1
  end

  def blowUpBomb bomb
      expl = Effect.new(id: @entityCount, type: "explosion", x: bomb.x-35, y: bomb.y-35)
      @entityArray.push(expl)
      @entityCount += 1

      @entityArray.each do |e|
        if e.is_a? Enemy
          col = expl.collision(e)
          e.damage(bomb.damageValue) if col 
        end
      end

      @entityArray.delete(bomb)
      @entityCount -= 1
  end

  def entityUpdate
    #Loop through enemies, resetting variables, passing args, and process movement, collision, damage and other logic
    @entityArray.each do |e|
      e.resetEntity
      
      if e.is_a? Player
        e.playerMovement @keypressed, @entityArray 
      elsif e.is_a? Enemy
        e.dead ? (enemyDead e) : (e.movement @entityArray) 
      end
    end

    if (state.tick_count % 30) == 0 && @shift
      @entityArray.push(Bomb.new(id: @entityCount, x: @player.x, y: @player.y))
      @entityCount += 1
    end
   

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

    @entityArray.each do |e|
  
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

      elsif e.type == "bomb"
        frameCount = 10
        frameSpeed = 13
        e.sprite = "sprites/dc16pp/props/bomb_anim_f#{e.spriteID}.png"
      
      elsif e.type == "explosion"
        frameCount = 7
        frameSpeed = 4
        e.sprite = "sprites/dc16pp/effects/explosion_anim_f#{e.spriteID}.png"

      elsif e.type == "enemyDeath"
        frameCount = 4
        frameSpeed = 10
        e.sprite = "sprites/dc16pp/effects/enemy_afterdead_explosion_anim_f#{e.spriteID}.png"
      
      end
  
      if (state.tick_count % frameSpeed) == 0
        e.spriteID += 1
        if e.spriteID >= frameCount
          e.spriteID = 0
          blowUpBomb e if e.type == "bomb"
          @entityArray.delete(e) if e.type == "explosion" || e.type == "enemyDeath"
          

        end
      end
    end

  end

  def viewOutput
    #enemies sprite output
    @entityArray.each do |e|
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
    outputs.labels << {x:640, y: 60, text: "[c] to #{@keypressed.include?("c") ? "disable" : "enable"} player collision.", alignment_enum: 1}
    outputs.labels << {x:640, y: 30, text: "[space/shift] = bomb | [esc] = reset", alignment_enum: 1}    
  end

  def tick
    detectInput
    entityUpdate #player and npc update loop
    spriteAnimations #entities animation loops
    viewOutput
  end
end

def boot args
  $game = Game.new 
  $game.defaults
  $game.map.load
  args.outputs.static_sprites << $game.map.layers.first.sprites
end

def tick args
  $game.args = args
  $game.tick
end

def reset args
  $gtk.reset
  boot args
end

$gtk.reset