class Map

    attr_accessor :level

    def initialize(camera)
        @objects = {c: Gosu::Image.new("media/leaf.png"), b: Gosu::Image.new("media/bricks.png"), w: Gosu::Image.new("media/water.png")}
        @array = []
        @b_values = []
        @w_values = []
        @level = 1
        read
        map_b_values
        map_w_values
        @camera = camera
    end

    def read
        f = File.readlines('levels/level.csv')
        f.each do |a|
            @array << a.split(';')
        end
        @array.each do |a|
            a[-1].chomp!
        end
    end

    def array
        @array
    end

    def b_values
        @b_values
    end

    def w_values
        @w_values
    end

    def map_b_values
        @array.each_with_index do |row, y|
            row.each_with_index do |object, x|
                if object == "b"
                    @b_values << [x*32, y*32]
                end
            end
        end
    end

    def map_w_values
        @array.each_with_index do |row, y|
            row.each_with_index do |object, x|
                if object == "w"
                    @w_values << [x*32, y*32]
                end
            end
        end
    end

    def draw
        @array.each_with_index do |row, y|
            row.each_with_index do |object, x|
                if object != "" and @camera
                    @objects[object.to_sym].draw((x*@objects[object.to_sym].width) - @camera.x, y*@objects[object.to_sym].height, 0)
                end
            end
        end
    end

end
