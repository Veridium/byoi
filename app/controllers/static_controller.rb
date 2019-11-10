class StaticController < ApplicationController
    layout 'static'
    def show
        render params[:page]
    end
end
