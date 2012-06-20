class MembersController < ApplicationController
  inherit_resources
  has_scope :page, default: 1
  has_scope :by_updated_at

  actions :show, :update, :index
  respond_to :json, only: [:index]
  respond_to :html, :only => [ :show, :update ]

  before_filter only: [:index] { if ENV['DASH_TOKEN'] != params[:token] then render :nothing => true, :status => :unauthorized end }
end
