$gtk.reset

class Entity
    attr_accessor :warp, :type, :id, :x, :y, :w, :h, :sprite, :spriteDir, :colRect, :col, :colDir, :colArray, :spriteID, :spriteAnim, :dx, :dy
    def initialize args, id, type, x, y, w, h, spriteAnim = "idle", spriteDir = "right"
        @args = args
        @id = id,
        @type = type
        @x =  x
        @y =  y
        @w =  w
        @h =  h
        @lastx = x
        @lasty = y
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

    def wrap
        @x -= 1280 if @x > 1280
        @y -= 720 if @y > 720
        @x += 1280 if @x < 0
        @y += 720 if @y < 0
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

    def movement keypressed, enemyArray
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
             collision(e, k) 
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

         wrap
   
         # move player healthbar with player
         @healthbarUI.x = @x
         @healthbar.x = @x
         @healthbarUI.y = @y - 30
         @healthbar.y = @y - 30


    end

    def collision e, dir
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

    #Caculates player damage based on amount of enemies in @colArray
    def damage
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
      @debugVal = false
    end

    def isInside e
        collision = [@x, @y, @w, @h].intersect_rect? e.colRect
        
        @args.outputs.labels << [10, 500, "x | lastx: #{collision}"]
        return collision
    end

    def movement p, entityArray

        entityArray.each do |e|
            if ((isInside e) && (e.id != @id))
               
                @x = @lastx
                @y = @lasty
                @colRect.x, @colRect.y = @x, @y 
            end
        end

        movespeed = 1

        (@dx = movespeed; @colDir.push("right")) if @x < p.x
        (@dx = -movespeed; @colDir.push("left")) if @x > p.x
        (@dy = movespeed; @colDir.push("up")) if @y < p.y
        (@dy = -movespeed; @colDir.push("down")) if @y > p.y

        colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
        entityArray.each do |e|
            collision(e) unless e.id == @id
            colBuffer = true if @col
        end
        @col = colBuffer

        @colDir.each do |dir|
            #sets dx/dy to 0 if up/down or left/right isn't pressed
            if ["up", "down"].include?(dir)
                @dy = 0 if @col
            end
            if ["right", "left"].include?(dir)
                @dx = 0 if @col
            end
        end
        @lastx = @x
        @lasty = @y
        @y += @dy
        @x += @dx

        wrap

    end

    def collision e
        collision = false
        
        if @colDir.include?("right") || @colDir.include?("left")
            @colRect.x = @x + @dx 
            collision = @colRect.intersect_rect? e.colRect
            
        end
        
        if @colDir.include?("up") || @colDir.include?("down")
            @colRect.y = @y + @dy 
            collision = @colRect.intersect_rect? e.colRect
        end

        collision ? (@colArray.push(e) unless @colArray.include?(e)) : (@colArray.delete(e) if @colArray.include?(e))
        attackRange = [@colRect.x-1, @colRect.y-1, @colRect.w+2, @colRect.h+2].intersect_rect? e.colRect

        if attackRange && e.type == "player"
            e.damage
            collision = true
        end      
        @colRect.x, @colRect.y = @x, @y 
        @col = collision
    end

    def damage
    end
  
  end