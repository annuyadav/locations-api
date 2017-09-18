class LocationsController < ApplicationController

  before_action :set_location, only: [:show, :update, :destroy]

  # GET /locations
  def index
    @locations = GeoLocation::Location.all.page(params[:page]||1)
    json_response(@locations)
  end

  def search
    _page = params[:page] || 1
    _query = params[:query] || params[:q] || ''
    @locations = _query.present? ? GeoLocation.search(_query).page(_page) : []
    json_response(@locations)
  end

  # POST /locations
  def create
    @location = GeoLocation::Location.create!(location_params)
    json_response(@location, :created)
  end

  # GET /locations/:id
  def show
    json_response(@location)
  end

  # PUT /locations/:id
  def update
    @location.update(location_params)
    head :no_content
  end

  # DELETE /locations/:id
  def destroy
    @location.destroy
    head :no_content
  end

  private

  def location_params
    # whitelist params
    params.permit(GeoLocation::Location.attribute_names)
  end

  def set_location
    @location = GeoLocation::Location.find(params[:id])
  end
end
