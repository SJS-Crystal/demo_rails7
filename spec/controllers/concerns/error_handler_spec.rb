require 'rails_helper'

class FakesController < ApplicationController
  include ErrorHandler

  def action_that_raises_standard_error
    raise StandardError
  end

  def action_that_raises_access_denied
    raise AccessDenied
  end

  def action_that_raises_record_not_found
    raise ActiveRecord::RecordNotFound
  end

  def action_that_raises_record_invalid
    client = Client.new
    client.errors.add(:name, "can't be blank")
    raise ActiveRecord::RecordInvalid.new(client)
  end

  def action_that_raises_decode_error
    raise JWT::DecodeError
  end

  def action_that_raises_expired_signature
    raise JWT::ExpiredSignature
  end
end

RSpec.describe FakesController, type: :controller do
  after do
    Rails.application.reload_routes!
  end

  controller do
    def render_response(opts = {})
      render json: { message: opts[:message], success: opts[:success] }, status: opts[:status]
    end
  end

  shared_examples_for 'an error response' do |message, status|
    it 'returns the appropriate status code' do
      expect(response.status).to eq status
    end

    it 'returns the error message in the response body' do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['message']).to eq message
    end

    it 'returns a success: false in the response body' do
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['success']).to eq false
    end
  end

  describe 'ErrorHandler' do
    context 'when StandardError is raised' do
      before do
        routes.draw { get 'action_that_raises_standard_error' => 'fakes#action_that_raises_standard_error' }
        get :action_that_raises_standard_error
      end
      it_behaves_like 'an error response', 'Internal Error!', 500
    end

    context 'when AccessDenied is raised' do
      before do
        routes.draw { get 'action_that_raises_access_denied' => 'fakes#action_that_raises_access_denied' }
        get :action_that_raises_access_denied
      end
      it_behaves_like 'an error response', 'You do not have access!', 403
    end

    context 'when RecordNotFound is raised' do
      before do
        routes.draw { get 'action_that_raises_record_not_found' => 'fakes#action_that_raises_record_not_found' }
        get :action_that_raises_record_not_found
      end
      it_behaves_like 'an error response', 'Not found', 404
    end

    context 'when RecordInvalid is raised' do
      before do
        routes.draw { get 'action_that_raises_record_invalid' => 'fakes#action_that_raises_record_invalid' }
        get :action_that_raises_record_invalid
      end
      it_behaves_like 'an error response', ["Name can't be blank"], 422
    end

    context 'when DecodeError is raised' do
      before do
        routes.draw { get 'action_that_raises_decode_error' => 'fakes#action_that_raises_decode_error' }
        get :action_that_raises_decode_error
      end
      it_behaves_like 'an error response', 'Invalid token', 401
    end

    context 'when ExpiredSignature is raised' do
      before do
        routes.draw { get 'action_that_raises_expired_signature' => 'fakes#action_that_raises_expired_signature' }
        get :action_that_raises_expired_signature
      end
      it_behaves_like 'an error response', 'Token expired!', 401
    end
  end
end
