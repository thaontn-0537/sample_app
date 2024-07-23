class DemoPartialsController < ApplicationController
  def new
    @zone = "Zone New action"
    @date = Date.today
  end

  def edit
    @zone = "Zone New action"
    @date = Date.today - 4
  end
end
