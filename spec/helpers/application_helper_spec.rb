require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#notice_classes' do
    it 'returns a hash of notice classes' do
      classes = helper.notice_classes

      expect(classes[:success]).to eq(:success)
      expect(classes[:error]).to eq(:danger)
      expect(classes[:alert]).to eq(:info)
    end
  end
end
