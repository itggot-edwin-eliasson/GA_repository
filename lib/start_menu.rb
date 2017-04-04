
class StartMenu

    def initialize(window)
        @window = window
        @game_title = Gosu::Image.from_text(window,'Boyert Adventures', 'Fipps-Regular', 72,)
        @start_game_txt = Gosu::Image.from_text(window, 'Start', 'Fipps-Regular', 40)
        @quit_game_txt = Gosu::Image.from_text(window, 'Quit', 'Fipps-Regular', 40)
        @options = [:start, :quit]
    end

    def selected
        @options.first
    end

    def move
        @options.rotate!(1)
    end

    def sel
        return @options[0]
    end

    def draw
        @game_title.draw_rot(@window.width/2, 100, 10, 0, 0.5, 0.5, 1, 1, 0xff_ff0000)
        if @options[0] == :start
            @start_game_txt = Gosu::Image.from_text(@window, 'Start', 'Fipps-Regular', 56)
            @quit_game_txt = Gosu::Image.from_text(@window, 'Quit', 'Fipps-Regular', 48)
        else
            @start_game_txt = Gosu::Image.from_text(@window, 'Start', 'Fipps-Regular', 48)
            @quit_game_txt = Gosu::Image.from_text(@window, 'Quit', 'Fipps-Regular', 56)
        end
        @start_game_txt.draw_rot((@window.width/2), @window.height/2, 10, 0, 0.5, 0.5, 1, 1, 0xff_ffffff)
        @quit_game_txt.draw_rot(@window.width/2, @window.height/2 + 40, 10, 0, 0.5, 0.5, 1, 1, 0xff_ffffff)
    end


end
