require 'rails_helper'

RSpec.describe JwtService do
  let(:device_id) { 'device123' }
  let(:device_secret) { 'secretabc' }
  let(:object_id) { 'object456' }
  let(:object_type) { 'Client' }
  let(:token) { described_class.generate_jwt_token(object_id, device_id, device_secret, object_type) }
  let(:service) { described_class.new("Bearer #{token}", device_id, device_secret, object_type) }

  describe '.generate_jwt_token' do
    it 'generates a JWT token' do
      expect(token).to be_a(String)
    end
  end

  describe '#authenticate' do
    context 'with a valid token' do
      it 'authenticates successfully' do
        success, payload = service.authenticate
        expect(success).to be true
        expect(payload['object_id']).to eq object_id
      end
    end

    context 'with an expired token' do
      before do
        allow(Settings).to receive(:token_life_time).and_return(-1)
      end

      it 'fails to authenticate' do
        success, payload = service.authenticate
        expect(success).to be false
        expect(payload).to be_nil
      end
    end

    context 'with an invalid token' do
      let(:service) { described_class.new("Bearer invalid_token", device_id, device_secret, object_type) }

      it 'fails to authenticate' do
        success, payload = service.authenticate
        expect(success).to be false
        expect(payload).to be_nil
      end
    end
  end
end
