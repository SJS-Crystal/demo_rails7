require "rails_helper"

RSpec.describe Admin::ClientsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/clients").to route_to("admin/clients#index")
    end

    it "routes to #new" do
      expect(get: "/admin/clients/new").to route_to("admin/clients#new")
    end

    it "routes to #show" do
      expect(get: "/admin/clients/1").to route_to("admin/clients#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/clients/1/edit").to route_to("admin/clients#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/clients").to route_to("admin/clients#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/clients/1").to route_to("admin/clients#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/clients/1").to route_to("admin/clients#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/clients/1").to route_to("admin/clients#destroy", id: "1")
    end
  end
end
