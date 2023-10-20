class Api::Client::V1::AccountsController < Api::Client::V1::BaseController
  skip_before_action :authenticate_client!, only: %w[login]

  $client_desc << 'api/client/v1/accounts | PUT | Authorization(header), Device-Id(header), name, password | update profile'
  def update
    current_client.update(client_params)
    if current_client.save
      render_response(object: current_client)
    else
      render_response(success: false, message: current_client.errors.full_messages[0])
    end
  end

  $client_desc << 'api/client/v1/accounts/profile | GET | Authorization(header), Device-Id(header) | get profile'
  def profile
    render_response(object: current_client)
  end

  $client_desc << 'api/client/v1/accounts/login | POST | Device-Id(header), username, password | Login'
  def login
    header_device_id = request.headers['Device-Id']
    return render_response(success: false, message: 'device_id is required in header') if header_device_id.blank?

    client = Client.find_by(username: params[:username])
    return render_response(success: false, message: 'Incorrect credentials') unless client&.authenticate(params[:password])

    device = Device.find_or_initialize_by(device_id: header_device_id)
    device.update!(client_id: client.id, secret: random_string)
    access_token = JwtService.generate_jwt_token(client.id, device.device_id, device.secret)
    render_response(object: {access_token: access_token})
  end

  $client_desc << 'api/client/v1/accounts/logout | DELETE | Authorization(header), Device-Id(header) | logout'
  def logout
    # device = current_client.devices.find_by(device_id: current_client.current_device_id)
    current_client.devices.delete_all
    render_response(message: 'Logout successfully!')
  end

  private

  def client_params
    params.permit(:name, :password, :password_confirmation)
  end
end
