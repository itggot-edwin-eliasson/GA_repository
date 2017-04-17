
class Game < Gosu::Window

    attr_accessor :music
    def initialize
        super 640, 480, false, (1000/60)
        self.caption = "Boyert Adventures"
        @background_image = Gosu::Image.new('media/parallax-mountain-bg.png')
        @mountain_image = Gosu::Image.new('media/parallax-mountain-mountains.png')
        @sel_sound = Gosu::Sample.new('media/Pickup_00.wav')
        @music = Gosu::Song.new('media/Loop_1.ogg')

        setup
    end

    def setup
        @start_menu = StartMenu.new(self)
        @music.play(true)
    end

    def button_down(id)
        unless @boyert_adventures
            if id == Gosu::KbReturn
                if @start_menu.sel == :start
                    @sel_sound.play
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
        @background_image.draw(0,0,-2, 3, 3)
        @mountain_image.draw(0, 0, -1 , 3, 3)
        @boyert_adventures.draw if @boyert_adventures
        unless @boyert_adventures
            @start_menu.draw
        end
    end



end
