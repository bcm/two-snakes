class PcsController < ApplicationController
  def index
    render(json: {pcs: []})
  end
end
