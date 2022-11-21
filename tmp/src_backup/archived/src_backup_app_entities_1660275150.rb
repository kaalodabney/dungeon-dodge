class Entity
    attr_accessor :warp, :id, :type, :x, :y, :w, :h, :movespeed, :sprite, :spriteDir, :colRect, :col, :colDir, :colArray, :spriteID, :spriteAnim, :dx, :dy
    def initialize id:, type:, x:, y:, zoom:, w: 16, h: 16, movespeed:0, spriteAnim: "idle", spriteDir: "right"
        @id = id
        @type = type
        @x =  x
        @y =  y
        @w =  w * zoom
        @h =  h * zoom
        @movespeed = movespeed
        @dx = @movespeed
        @dy = @movespeed   
        @colRect ||= { x: x, y: y, w: w, h: h}
        @col = false
        @colDir = Array.new(0) #array of directions currently colliding
        @colArray = Array.new(0) #array of entities colliding with
        @spriteAnim = spriteAnim
        @spriteDir = spriteDir
        @spriteID = 0              
    end

    def resetEntity
        @colRect.x = 10
        @colRect.y = @y
        @col = false
        @colDir.clear
        @dy = 0
        @dx = 0
    end

    def wrap
        @x -= 1280 if @x > 1280
        @y -= 720 if @y > 720
        @x += 1280 if @x < 0
        @y += 720 if @y < 0
    end

    #pushes back the collision rectangle in the given direction until the entity doesn't collied any longer
    def collisionPushBack
        @y -= 1 if @colDir.include?("top") && !@colDir.include?("bottom")
        @x -= 1 if @colDir.include?("right") && !@colDir.include?("left")
        @y += 1 if @colDir.include?("bottom") && !@colDir.include?("up")
        @x += 1 if @colDir.include?("left") && !@colDir.include?("right")
    end

    def collision e
        if !e.is_a? Effect
            c = @colRect.intersect_rect? e.colRect
            if c && e.id != @id
                #c is current entity, e is colliding entity
                if ((@colRect.y + @colRect.h) > e.y) && (e.y > @colRect.y) && !@colDir.include?("top")
                    @colDir.push("top")
                end
                if (@colRect.y < (e.y + e.h)) && (@colRect.y > e.y) && !@colDir.include?("bottom")
                    @colDir.push("bottom") 
                end
                if ((@colRect.x+ @colRect.w) > e.x) && (e.x > @colRect.x) && !@colDir.include?("right")
                    @colDir.push("right")  
                end
                if (@colRect.x < (e.x + e.w)) && (@colRect.x > e.x) && !@colDir.include?("left")
                    @colDir.push("left")   
                end

            end
        end

        return c
    end

end
  
class Player < Entity
    attr_accessor :healthbar, :healthbarUI, :hearts
    def initialize id:, type: "player", x:, y:, movespeed:1, zoom:
      super(id: id, type: type, x: x, y: y, movespeed: movespeed, zoom: zoom)
      @healthbar = {x: x, y: y-25, w: 100, h: 20, r: 225, g: 0, b: 0}
      @healthbarUI = {path: "sprites/dc16pp/ui/health_ui.png", x: x, y: y-25, w: 100, h: 20}
      @hearts = 4
    end

    def playerMovement keypressed, entityArray
        #Loop through input stack
         #  - set moveSpeed for each direction
         #  - dectects collision with enemies in each direction pressed
         #  - if collided in up/down or left/right, set dx or dy to 0
         
        if !keypressed.empty?
            keypressed.each do |k|
                @dy = @movespeed if k == "up"
                (@dx = @movespeed; @spriteDir = false) if k == "right"
                @dy = -@movespeed if k == "down" 
                (@dx = -@movespeed; @spriteDir = true) if k == "left"
            end
        end

        colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
        entityArray.each do |e| 
            if keypressed.include?("c")
                colBuffer = true if collision(e)
                collisionPushBack
            end
        end
        @col = colBuffer

        if @col
            if @colDir.include?("top") && @colDir.include?("bottom")
                @dy = 0
            # else 
            #     @dy = -@movespeed if @colDir.include?("top") 
            #     @dy = @movespeed if @colDir.include?("bottom")
            end
    
            if @colDir.include?("right") && @colDir.include?("left")
                @dx = 0
            # else
            #     @dx = -@movespeed if @colDir.include?("right")
            #     @dx = @movespeed if @colDir.include?("left")
            end
        end
   
         #move player by movespeed in both up/down and left/right
         @y += @dy
         @x += @dx

        #  wrap
   
         # move player healthbar with player
         @healthbarUI.x = @x
         @healthbar.x = @x
         @healthbarUI.y = @y - 30
         @healthbar.y = @y - 30
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
    attr_accessor :dead
    def initialize id: , type: , x: , y: , movespeed: 1, zoom:
        super(id: id, type: type, x: x, y: y, movespeed: movespeed, zoom: zoom)
        @hp ||= 25
        @dead ||= false
    end

    def movement entityArray
        p = entityArray[0]
        @dx = @movespeed if @x < p.x
        @dx = -@movespeed if @x > p.x
        @dy = @movespeed if @y < p.y
        @dy = -@movespeed if @y > p.y

        @colRect.x += @dx
        @colRect.y += @dy
         
        colBuffer = false
        entityArray.each do |e|
            colBuffer = true if collision(e) && @id != e.id
            e.damage if colBuffer && e.type == "player" 
        end
        @col = colBuffer

        if @col

            collisionPushBack 
            # if @colDir.include?("top") || @colDir.include?("bottom")
            #     @dy = 0
            # end
            # if @colDir.include?("right") || @colDir.include?("left")
            #     @dx = 0
            # end
            # if @colDir.include?("top") && @colDir.include?("bottom")
            #     @dy = 0
            # else 
            #     @dy = -@movespeed if @colDir.include?("top") 
            #     @dy = @movespeed if @colDir.include?("bottom")
            # end
    
            # if @colDir.include?("right") && @colDir.include?("left")
            #     @dx = 0
            # else
            #     @dx = -@movespeed if @colDir.include?("right")
            #     @dx = @movespeed if @colDir.include?("left")
            # end
        else    
            @x += @dx
            @y += @dy
        end
 
        wrap

    end

    def damage dmgVal 
        puts "damage"
        @hp -= dmgVal
        @dead = true if @hp <= 0 
    end

    def death

    end
end

class Bomb < Entity
    attr_accessor :damageValue
    def initialize id: , type: "bomb" , x: , y: , w: 32 , h: 32
        super(id: id, type: type, x: x, y: y, w: w, h: h)
        @damageValue ||= 25
        
    end

    
end

class Effect < Entity

    def initialize id: , type: , x: , y: , w: 64 , h: 65
        super(id: id, type: type, x: x, y: y, w: w, h: h)
        
    end
    
end

$gtk.reset