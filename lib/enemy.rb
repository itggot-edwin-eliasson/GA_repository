class Enemy

    attr_accessor :x, :y

    def initialize
        @x = 1000
        @y = 100
        @direction = :right
        @speed = 2
        @image = Gosu::Image.new('media/enemy3.png')
        @g = 0.5
        @org_y = @y
        @t = 0
        @vel_y = 0
        @on_ground = false
        @alive = true
        @death_sound = Gosu::Sample.new('media/SFX_Jump_09.wav')
    end

    def height
        @image.height
    end

    def width
        @image.width
    end

    def move(direction)
        if direction == :right
            @x += @speed
        elsif direction == :left
            @x -= @speed
        end
    end


    def jump
        count
        # @x = (@vel_x * @t + 0) + @org_x
        @y = -1 * (((-@g*@t**2)/2) + @vel_y * @t + 0) + @org_y
    end

    def count
        @t += 1
    end

    def kill
        @alive = false
        @death_sound.play
    end

    def alive?
        !@alive
    end

    def change_direction
        if @direction == :left
            @direction = :right
        else
            @direction = :left
        end
    end

    def not_on_ground
        @on_ground = false
    end

    def on_ground
        @on_ground = true
    end

    def update
        if @on_ground
            move(@direction)
        end

        unless @on_ground
            jump
        end
    end


    def draw (camera)
        # @image.draw(@x - camera.x, @y, 2)

        if @direction == :right
            @image.draw(@x + @image.width - camera.x, @y, 2, -1)
        else
            @image.draw(@x  - camera.x, @y, 2, 1)
        end
    end



end
