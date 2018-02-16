require "rails_helper"

RSpec.describe "Bucketlists API", type: :request do
  let!(:bucketlists) { create_list(:bucketlist, 10) }
  let(:bucketlist_id) { bucketlists.first.id }

  describe "GET /bucketlists" do
    before { get "/bucketlists" }

    it "returns bucketlists" do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "Get /bucketlists/:id" do
    before { get "/bucketlists/#{bucketlist_id}" }

    context "when the record exists" do
      it "return the todo" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(bucketlist_id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the record does not exist" do
      let(:bucketlist_id) { 100 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Bucketlist with 'id'=100/)
      end
    end
  end

  describe "POST /bucketlists" do
    # valid payload
    let(:valid_attributes) { { name: "Learn Elm", created_by: "1" } }

    context "when the request is valid" do
      before { post "/bucketlists", params: valid_attributes }

      it "creates a bucketlist" do
        expect(json["name"]).to eq("Learn Elm")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      before { post "/bucketlists", params: { name: "Foobar" } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation failure message" do
        expect(response.body).
          to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe "PUT /bucketlists/:id" do
    let(:valid_attributes) { { name: "Shopping" } }

    context "when the record exists" do
      before { put "/bucketlists/#{bucketlist_id}", params: valid_attributes }

      it "updates the record" do
        expect(response.body).to be_empty
      end

      it "returns status code 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE /bucketlists/:id" do
    before { delete "/bucketlists/#{bucketlist_id}" }

    it "returns status code 204" do
      expect(response).to have_http_status(204)
    end
  end
end
