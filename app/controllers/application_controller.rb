class ApplicationController < ActionController::Base
  include Pagy::Backend

  def random_string
    SecureRandom.hex(12).to_s.insert(rand(21), Time.zone.now.to_i.to_s)
  end
end
