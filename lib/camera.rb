class Camera

    attr_accessor :x

    def initialize(player, window)
        @player = player
        @window = window
        @x = 0

    end

    def camera_possition
        if @player.x >= @window.width/2
            @x = @player.x - (@player.width/2) - @window.width/2
        end
    end

    def update(map)
        camera_possition
        if @x < 0
            @x = 0
        elsif @x + @window.width > map.b_values[-1][0]
            @x = map.b_values[-1][0] - @window.width
        end
    end
end
