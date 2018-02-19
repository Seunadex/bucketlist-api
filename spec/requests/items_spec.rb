require "rails_helper"

RSpec.describe "Items API" do
  let(:user) { create(:user) }
  let!(:bucketlist) { create(:bucketlist, created_by: user.id) }
  let!(:items) { create_list(:item, 20, bucketlist_id: bucketlist.id) }
  let(:bucketlist_id) { bucketlist.id }
  let(:id) { items.first.id }
  let(:headers) { valid_headers }

  describe "GET /bucketlists/:bucketlist_id/items" do
    before do
      get "/bucketlists/#{bucketlist_id}/items",
          params: {},
          headers: headers
    end
  end

  describe "GET /bucketlists/:bucketlist_id/items/:id" do
    before do
      get "/bucketlists/#{bucketlist_id}/items/#{id}",
          params: {},
          headers: headers
    end
  end

  describe "POST /bucketlists/:bucketlist_id/items" do
    let(:valid_attributes) { { name: "Visit Narnia" }.to_json }

    context "when request attributes are valid" do
      before do
        post "/bucketlists/#{bucketlist_id}/items",
             params: valid_attributes,
             headers: headers
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when an invalid request" do
      before do
        post "/bucketlists/#{bucketlist_id}/items",
             params: {},
             headers: headers
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a failure message" do
        expect(response.body).
          to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe "PUT /bucketlists/:bucketlist_id/items/:id" do
    let(:valid_attributes) { { name: "Mozart" }.to_json }

    before do
      put "/bucketlists/#{bucketlist_id}/items/#{id}",
          params: valid_attributes,
          headers: headers
    end

    context "when item exists" do
      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end

      it "updates the item" do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Mozart/)
      end
    end

    context "when the item does not exist" do
      let(:id) { 0 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe "DELETE /bucketlists/:id" do
    before do
      delete "/bucketlists/#{bucketlist_id}/items/#{id}",
             params: {},
             headers: headers
    end

    it "returns status code 204" do
      expect(response).to have_http_status(200)
    end
  end
end
