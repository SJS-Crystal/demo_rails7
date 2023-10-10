require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#random_string' do
    it 'returns a string' do
      expect(subject.random_string).to be_a(String)
    end

    it 'returns a string of at least 22 characters' do
      expect(subject.random_string.length).to be >= 22
    end

    it 'includes a Unix timestamp' do
      timestamp = Time.zone.now.to_i.to_s
      expect(subject.random_string).to include(timestamp)
    end

    it 'is unique each time it is called' do
      first_call = subject.random_string
      second_call = subject.random_string
      expect(first_call).not_to eq(second_call)
    end
  end
end
