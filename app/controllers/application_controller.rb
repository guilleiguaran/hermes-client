class ApplicationController < ActionController::Base
  require 'ym4r/google_maps/geocoding'
  include Ym4r::GoogleMaps
  helper :all
  protect_from_forgery
end
