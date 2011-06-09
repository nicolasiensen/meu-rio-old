class PagesController < ApplicationController

  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message =~ %r{Missing template pages/}
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    else
      raise exception
    end
  end

  def show
    logger.debug("Rendering page: #{current_page}")

    @current_page = params[:id].to_s.downcase
    render :template => current_page
  end


  protected

  def current_page
    "pages/#{params[:id].to_s.downcase}"
  end

end
