class Entity
    attr_accessor :type, :x, :y, :w, :h, :sprite, :spriteDir, :colRect, :col, :colDir, :colArray, :spriteID, :spriteAnim, :dx, :dy
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
      @colArray = []             
    end
  end
  
  class Player < Entity
    attr_accessor :healthbar, :healthbarUI, :hearts
    def initialize args, x, y, w=100, h=100
      super(args, "player", x, y, w, h)
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
  
      @colRect.x, @colRect.y = @x, @y 
      @col = collision
    end
  end
  
  class Enemy < Entity
    def initialize args, type, x, y, w=100, h=100
      super(args, type, x, y, w, h)
    end
  
    def enemyCollision p
      collision = false
      collision = [@colRect.x-1, @colRect.y-1, @colRect.w+2, @colRect.h+2].intersect_rect? p.colRect
      @col = collision
    end
  
  end