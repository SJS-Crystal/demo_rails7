# spec/helpers/order_helper_spec.rb
require 'rails_helper'

RSpec.describe OrderHelper, type: :helper do
  describe '#order_status' do
    let(:order) { instance_double("Order", status: status) }

    context 'when status is :pending_approval' do
      let(:status) { 'pending_approval' }

      it 'returns a warning badge with the humanized status' do
        expect(helper.order_status(order)).to eq(
          '<div class="badge badge-warning badge-lg">Pending Approval</div>'
        )
      end
    end

    context 'when status is :issued' do
      let(:status) { 'issued' }

      it 'returns an info badge with the humanized status' do
        expect(helper.order_status(order)).to eq(
          '<div class="badge badge-info badge-lg">Issued</div>'
        )
      end
    end

    context 'when status is :active' do
      let(:status) { 'active' }

      it 'returns a success badge with the humanized status' do
        expect(helper.order_status(order)).to eq(
          '<div class="badge badge-success badge-lg">Active</div>'
        )
      end
    end

    context 'when status is :canceled' do
      let(:status) { 'canceled' }

      it 'returns a secondary badge with the humanized status' do
        expect(helper.order_status(order)).to eq(
          '<div class="badge badge-secondary badge-lg">Canceled</div>'
        )
      end
    end

    context 'when status is :rejected' do
      let(:status) { 'rejected' }

      it 'returns a danger badge with the humanized status' do
        expect(helper.order_status(order)).to eq(
          '<div class="badge badge-danger badge-lg">Rejected</div>'
        )
      end
    end
  end
end
