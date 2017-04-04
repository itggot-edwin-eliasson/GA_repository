
class Game < Gosu::Window

    def initialize
        super 640, 480, false, (1000/60)
        self.caption = "Boyert Adventures"
        @background_image = Gosu::Image.new('media/background.jpg')


        setup
    end

    def setup
        @start_menu = StartMenu.new(self)
    end

    def button_down(id)
        unless @boyert_adventures
            if id == Gosu::KbReturn
                if @start_menu.sel == :start
                    @boyert_adventures = BoyertAdventures.new(self)
                else
                    exit
                end
            elsif id == Gosu::KbUp || id == Gosu::KbDown
                @start_menu.move
            end
        end
        if @boyert_adventures
            @boyert_adventures.button_down(id)
        end
    end

    def update
        @boyert_adventures.update if @boyert_adventures


    end

    def draw
        @background_image.draw(0,0,-2)
        @boyert_adventures.draw if @boyert_adventures
        unless @boyert_adventures
            @start_menu.draw
        end
    end



end
