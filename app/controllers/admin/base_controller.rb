class Admin::BaseController < ApplicationController
  layout 'admin/main'
  before_action :authenticate_admin!
end
