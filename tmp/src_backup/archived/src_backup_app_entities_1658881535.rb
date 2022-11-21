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
        @dy = 0
        @dx = 0
    end

    def wrap
        @x -= 1280 if @x > 1280
        @y -= 720 if @y > 720
        @x += 1280 if @x < 0
        @y += 720 if @y < 0
    end

    def collision e

        c = @colRect.intersect_rect? e.colRect
        if c && e.id != @id
            #c is current entity, e is colliding entity
            @colDir.push("top")    if   ((@colRect.y + @colRect.h) > e.y) && (e.y > @colRect.y) && !@colDir.include?("top")
            @colDir.push("bottom") if          (@colRect.y < (e.y + e.h)) && (@colRect.y > e.y) && !@colDir.include?("bottom")
            @colDir.push("right")  if    ((@colRect.x+ @colRect.w) > e.x) && (e.x > @colRect.x) && !@colDir.include?("right")
            @colDir.push("left")   if          (@colRect.x < (e.x + e.w)) && (@colRect.x > e.x) && !@colDir.include?("left")
            @args.outputs.labels << {x: 10, y: 500, text: "slime: #{@colDir}"} if @type == "slime"
        end

        return c
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

    def playerMovement keypressed, enemyArray
        #Loop through input stack
         #  - set moveSpeed for each direction
         #  - dectects collision with enemies in each direction pressed
         #  - if collided in up/down or left/right, set dx or dy to 0
         
        # if keypressed
        #     keypressed.each do |k|
        #         @dy = @moveSpeed if k == "up"
        #         (@dx = @moveSpeed; @spriteDir = false) if k == "right"
        #         @dy = - @moveSpeed if k == "down" 
        #         (@dx = - @moveSpeed; @spriteDir = true) if k == "left"
        #     end
        # end
        @args.outputs.labels << {x: 10, y: 520, text: "#{keypressed == true}"}
        @dx = @movespeed if keypressed.include?("right")
        @dx = -@movespeed if keypressed.include?("left")
        @dy = @movespeed if keypressed.include?("up")
        @dy = -@movespeed if keypressed.include?("down")


        colBuffer = false # A buffer to detect if collision is true for ANY enemies, not just the last one, in a certain direction
        enemyArray.each do |e| 
            colBuffer = true if true
        end
        @col = colBuffer

        if @col
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


    def movement p, enemyArray

        colBuffer = false
        enemyArray.each do |e|
            colBuffer = true if collision(e)
        end
        colBuffer = true if collision(p)
        @col = colBuffer

       
        
        
        
            @dx = @movespeed if @x < p.x
            @dx = -@movespeed if @x > p.x
            @dy = @movespeed if @y < p.y
            @dy = -@movespeed if @y > p.y

        if @col
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
        end
        

        @x += @dx
        @y += @dy
 
        wrap

    end
  end