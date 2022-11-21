$gtk.reset

class Entity
    attr_accessor :type, :id, :x, :y, :w, :h, :sprite, :spriteDir, :colRect, :col, :colDir, :colArray, :spriteID, :spriteAnim, :dx, :dy
    def initialize args, id, type, x, y, w, h, spriteAnim = "idle", spriteDir = "right"
        @args = args
        @id = id,
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
        @colArray = []             
    end
end
  
class Player < Entity
    attr_accessor :healthbar, :healthbarUI, :hearts
    def initialize args, id, x, y, w=50, h=50
      super(args, id, "player", x, y, w, h)
      @healthbar = {x: x, y: y-25, w: 100, h: 20, r: 225, g: 0, b: 0}
      @healthbarUI = {path: "sprites/dc16pp/ui/health_ui.png", x: x, y: y-25, w: 100, h: 20}
      @hearts = 4
    end
  
    def playerCollision e, dir
      collision = false
  
      # moves player collision rectangle in pressed direction to see if the player would collide if moved
      if dir == "up"
        @colRect.y = @y + @dy
        collision = true if @colRect.intersect_rect? e.colRect
      end
  
      if dir == "right"
        @colRect.x = @x + @dx
        collision = true if @colRect.intersect_rect? e.colRect
      end
  
      if dir == "down"
        @colRect.y = @y + @dy
        collision = true if @colRect.intersect_rect? e.colRect
      end
  
      if dir == "left"
        @colRect.x = @x + @dx
        collision = true if @colRect.intersect_rect? e.colRect
      end
      collision ? (@colArray.push(e) unless @colArray.include?(e)) : (@colArray.delete(e) if @colArray.include?(e))
      @colRect.x, @colRect.y = @x, @y 
      @col = collision
    end

    def playerMovement keypressed, enemyArray
        #Loop through input stack
         #  - set moveSpeed for each direction
         #  - dectects collision with enemies in each direction pressed
         #  - if collided in up/down or left/right, set dx or dy to 0
         moveSpeed = 5
         keypressed.each do |k|
   
           @dy = moveSpeed if k == "up"
           (@dx = moveSpeed; @spriteDir = false) if k == "right"
           @dy = -moveSpeed if k == "down" 
           (@dx = -moveSpeed; @spriteDir = true) if k == "left"
   
           colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
           enemyArray.each do |e| 
             playerCollision(e, k) 
             colBuffer = true if @col
           end
           @col = colBuffer
   
           #sets dx/dy to 0 if up/down or left/right isn't pressed
           if ["up", "down"].include?(k)
             (@dy = 0; @args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if @col
           end
           if ["right", "left"].include?(k)
             (@dx = 0; @args.outputs.labels << [10, 540, "Collision Direction: #{k}"]) if @col
           end
         end
   
         #move player by movespeed in both up/down and left/right
         @y += @dy
         @x += @dx
   
         # move player healthbar with player
         @healthbarUI.x = @x
         @healthbar.x = @x
         @healthbarUI.y = @y - 30
         @healthbar.y = @y - 30
     end

    #Caculates player damage based on amount of enemies in @colArray
    def playerDamage
        if @healthbar.w > 20
            @healthbar.w -=  0.5
        else
            @hearts -= 1 if @hearts > 1
            @healthbar.w = ((@hearts * 25) + (-5 * @hearts + 20))
        end
    end
end
  
class Enemy < Entity
    def initialize args, id, type, x, y, w=50, h=50
      super(args, id, type, x, y, w, h)
    end
  

    def enemyCollision e, xMove, yMove
        
        xCollision, yCollision = false
  
      # moves player collision rectangle in pressed direction to see if the player would collide if moved
        if xMove
            @colRect.y = @x + @dx
            xCollision = true if @colRect.intersect_rect? e.colRect
        end
   
        if yMove
            @colRect.x = @y + @dy
            yCollision = true if @colRect.intersect_rect? e.colRect
        end

        collision = xCollision || yCollision
        collision ? (@colArray.push(e) unless @colArray.include?(e)) : (@colArray.delete(e) if @colArray.include?(e))
        @colRect.x, @colRect.y = @x, @y 
        @col = collision

        attackRange = [@colRect.x-1, @colRect.y-1, @colRect.w+2, @colRect.h+2].intersect_rect? e.colRect

        if attackRange && e.type == "player"
            e.playerDamage
        end

        @dy = 0 if yCollision
        @dx = 0 if xCollision

    end

    def enemyMovement p, entitiesArray
        movespeed = 2
        xMove, yMove = false
        (@dx = movespeed; xMove = true) if @x < p.x
        (@dx = -movespeed; xMove = true) if @x > p.x
        (@dy = movespeed; yMove = true ) if @y < p.y
        (@dy = -movespeed; yMove = true) if @y > p.y

        entitiesArray.each do |e|
            @args.outputs.labels << [10, 400, "enemyMovement: #{@dx}, #{@dy}"]
            enemyCollision(e, xMove, yMove)
        end
       
        
        @y += @dy
        @x += @dx

        # @colRect.x = @x
        # @colRect.y = @y
    
      end
  
  end