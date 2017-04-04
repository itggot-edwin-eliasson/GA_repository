class Player

    attr_accessor :x, :y
    attr_accessor :on_ground, :invulnerable, :damage, :lives, :walking, :stuck

    def initialize(window)
        @x = 200
        @y = 100
        @image = Gosu::Image.new('media/player.png')
        @player_tiles = Gosu::Image::load_tiles('media/player-tiles.png', 32, 32)
        @current_player = @player_tiles.first
        @vel_y = 0
        @g = 0.5
        @org_x = @x
        @org_y = @y
        @t = 0
        @on_ground = true
        @player_direction = :right
        @walking = false
        @speed = 5
        @life_image = Gosu::Image.new('media/heart.png')
        @lives = [@life_image, @life_image, @life_image]
        @damage = false
        @time = 0
        @invulnerable = false
        @stuck = false
    end

    def height
        @image.height
    end

    def width
        @image.width
    end

    def ground?
        @on_ground
    end

    def move(way)
        @walking = true
        if way == :right
            @x += @speed
            @player_direction = way
        elsif way == :left
            @x -= @speed
            @player_direction = way
        end
    end

    def stuck(direction)
        if direction == @player_direction
            @speed = 0
            @stuck = true
        else
            @speed = 5
            @stuck = false
        end

    end

    def take_damage(collision)
        @lives.delete_at(@lives.length - 1)
        @collision = collision
        @damage = true
        # tick = 0
        # while tick < 30
        #     if @collision == :right
        #         @x -= 1
        #     else
        #         @x += 1
        #     end
        #     tick += 1
        # end

        # if tick == 30
        #     @damage = false
        # end
        if @lives.length == 0
            exit
        end

    end

    def not_stuck
        @speed = 5
        @stuck = false
    end

    def jump
        count
        # @x = (@vel_x * @t + 0) + @org_x
        @y = -1 * (((-@g*@t**2)/2) + @vel_y * @t + 0) + @org_y
    end

    def count
        @t += 1
    end

    def jumping
        @vel_y = 10
        @on_ground = !@on_ground
        @org_y = @y
        @t = 0
        @g = 0.5
    end

    def on_ground
        @on_ground = true
        @t = 0
        @vel_y = 0
        @org_y = @y
    end

    def not_on_ground
        @on_ground = false
    end

    def not_walking
        @walking = false
    end


    def button_down(button)
        unless @damage
            if button == Gosu::KbSpace or button == Gosu::KbUp and @on_ground
                jumping
            elsif button == Gosu::KbEscape
                exit
            end
        end
    end

    def update
        # p @x,@y
        # p @on_ground
        # p @speed
        p @stuck

        if @damage
            if @collision == :right
                @x -= 6
            else
                @x += 6
            end

            if @time > 6
                @damage = false
                @invulnerable = true
                # @time = 0
            else
                @time += 1
            end

        end

        if @invulnerable

            if @time > 50
                @invulnerable = false
                @time = 0
            else
                @time += 1
            end
        end

        if @on_ground == false
            jump
            @current_player = @player_tiles[4]
        elsif @walking
            step = (Gosu::milliseconds / 100 % 3) + 1
            @current_player = @player_tiles[step]
        elsif @damage
            @current_player = @player_tiles[5]
        else
            @current_player = @player_tiles.first
        end

        # p @lives.length

    end

    def draw (camera)
        if @player_direction == :right
            @current_player.draw(@x - camera.x,@y,1,1)
        else
            @current_player.draw(@x + @image.width - camera.x,@y,1,-1)
        end
    end

end
