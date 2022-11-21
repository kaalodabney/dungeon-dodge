$gtk.reset

class Entity
    attr_accessor :warp, :id, :type, :x, :y, :w, :h, :movespeed, :sprite, :spriteDir, :colRect, :col, :colDir, :colArray, :spriteID, :spriteAnim, :dx, :dy
    def initialize args, id, type, x, y, w, h, movespeed, spriteAnim = "idle", spriteDir = "right"
        @args = args
        @id = id
        @type = type
        @x =  x
        @y =  y
        @w =  w
        @h =  h
        @movespeed = movespeed
        @dx = @movespeed
        @dy = @movespeed   
        @colRect = { x: x, y: y, w: w, h: h}
        @col = false
        @colDir = Array.new(0) #array of directions currently colliding
        @colArray = Array.new(0) #array of entities colliding with
        @spriteAnim = spriteAnim
        @spriteDir = spriteDir
        @spriteID = 0           
        @colArray = Array.new(0)           
    end

    def resetEntity
        @colRect.x = @x
        @colRect.y = @y
        @col = false
        @colDir.clear
    end

    def wrap
        @x -= 1280 if @x > 1280
        @y -= 720 if @y > 720
        @x += 1280 if @x < 0
        @y += 720 if @y < 0
    end

    def collision e

        collision = @colRect.intersect_rect? e.colRect
        if collision
            #c is current entity, e is colliding entity
            @colDir.push("top")    if   ((@colRect.y + @colRect.h) > e.y) && (e.y > @colRect.y)
            @colDir.push("bottom") if          (@colRect.y < (e.y + e.h)) && (@colRect.y > e.y) 
            @colDir.push("right")  if    ((@colRect.x+ @colRect.w) > e.x) && (e.x > @colRect.x)
            @colDir.push("left")   if          (@colRect.x < (e.x + e.w)) && (@colRect.x > e.x) 
        end

        return collision
    end

end
  
class Player < Entity
    attr_accessor :healthbar, :healthbarUI, :hearts
    def initialize args, id, x, y, w=50, h=50, movespeed=5 
      super(args, id, "player", x, y, w, h, movespeed)
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
            #collision = true if @colRect.intersect_rect? e.colRect
        end
    
        if dir == "right"
          @colRect.x = @x + @dx
          #collision = true if @colRect.intersect_rect? e.colRect
        end
    
        if dir == "down"
          @colRect.y = @y + @dy
          #collision = true if @colRect.intersect_rect? e.colRect
        end
    
        if dir == "left"
          @colRect.x = @x + @dx
          #collision = true if @colRect.intersect_rect? e.colRect
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
    def initialize args, id, type, x, y, w=50, h=50, movespeed=1
      super(args, id, type, x, y, w, h, movespeed)
    end


    def movement p, entityArray

        colBuffer = false
        entityArray.each do |e|
            colBuffer = collision(e)
        end
        @col = colBuffer

       
        if @colDir.include?("top") && @colDir.include?("bottom")
            @dy = 0
        else 
            @dy = -@movespeed if @colDir.include?("top") 
            @dy = @movespeed if @colDir.include?("bottom")
        end

        if @colDir.include?("right") && @colDir.include?("left")
            @dx = 0
        else
            @dx = -@movespeed if @colDir.include?("right")
            @dx = @movespeed if @colDir.include?("left")
        end
        
        if !@col
            @dx = @movespeed if @x < p.x
            @dx = -@movespeed if @x > p.x
            @dy = @movespeed if @y < p.y
            @dy = -@movespeed if @y > p.y
        end
        

        @x += @dx
        @y += @dy
 
        wrap

    end
  end