class Api::Client::V1::BaseController < ApplicationController
  include ErrorHandler

  before_action :authenticate_client!

  skip_before_action :verify_authenticity_token

  $client_desc = []

  private

  def authenticate_client!
    device = Device.find_by(device_id: device_id)
    return render_response(message: 'Device_id is invalid!', success: false, status: 401) if device.nil?

    _auth_status, auth_data = JwtService.new(bearer_token, device_id, device.secret).authenticate!
    @current_client ||= Client.find(auth_data['object_id'])
  end

  def current_client
    return @current_client if defined? @current_client

    device = Device.find_by(device_id: device_id)
    return @current_client = nil if device.nil?

    auth_status, auth_data = JwtService.new(bearer_token, device_id, device.secret).authenticate
    @current_client = auth_status ? Client.find_by(id: auth_data[:object_id]) : nil
  end

  def bearer_token
    request.headers['Authorization']
  end

  def device_id
    request.headers['Device-Id']
  end

  def render_response(object: nil, message: nil, success: true, status: 200, serializer_options: nil, pagy: nil)
    resp_data = {success: success, message: message, data: nil}
    serializer_options ||= dynamic_serializer_options(object) if object
    resp_data[:data] = ActiveModelSerializers::SerializableResource.new(object, serializer_options) if object
    resp_data[:pagy] = pagy if pagy
    render json: resp_data, status: status
  end

  def dynamic_serializer_options(object)
    case object
    when ActiveRecord::Relation
      {each_serializer: "#{object.class.to_s.deconstantize}Serializer".constantize}
    when ApplicationRecord
      {serializer: "#{object.class.name}Serializer".constantize}
    else
      {serializer: nil}
    end
  end

  def pagy_metadata(pagy)
    {
      current_page: pagy.page,
      next_page: pagy.next,
      prev_page: pagy.prev,
      total_pages: pagy.pages,
      total_count: pagy.count
    }
  end
end
