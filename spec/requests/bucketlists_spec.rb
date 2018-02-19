require "rails_helper"

RSpec.describe "Bucketlists API", type: :request do
  let(:user) { create(:user) }
  let!(:bucketlists) { create_list(:bucketlist, 10, created_by: user.id) }
  let(:bucketlist_id) { bucketlists.first.id }

  let(:headers) { valid_headers }

  describe "GET /bucketlists" do
    before { get "/bucketlists", params: {}, headers: headers }

    it "returns bucketlists" do
      expect(json).not_to be_empty
      expect(json.size).to eq(3)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "Get /bucketlists/:id" do
    before do
      get "/bucketlists/#{bucketlist_id}",
          params: {},
          headers: headers
    end

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
      let(:bucketlist_id) { 30 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Bucketlist with 'id'=30/)
      end
    end
  end

  describe "POST /bucketlists" do
    # valid payload
    let(:valid_attributes) do
      { title: "Learn Elm", created_by: user.id.to_s }.to_json
    end

    context "when the request is valid" do
      before do
        post "/bucketlists",
             params: valid_attributes,
             headers: headers
      end

      it "creates a bucketlist" do
        expect(json["title"]).to eq("Learn Elm")
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) { { title: nil }.to_json }
      before do
        post "/bucketlists",
             params: invalid_attributes,
             headers: headers
      end

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a validation failure message" do
        expect(response.body).
          to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  describe "PUT /bucketlists/:id" do
    let(:valid_attributes) { { title: "Shopping" }.to_json }

    context "when the record exists" do
      before do
        put "/bucketlists/#{bucketlist_id}",
            params: valid_attributes,
            headers: headers
      end

      it "updates the record" do
        expect(response.body).not_to be_empty
      end

      it "returns status code 204" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE /bucketlists/:id" do
    before do
      delete "/bucketlists/#{bucketlist_id}",
             params: {},
             headers: headers
    end

    it "returns status code 204" do
      expect(response).to have_http_status(200)
    end

    it "returns success message" do
      expect(response.body).to match(/{\"message\":\"Successfully deleted you bucketlist\"}/)
    end
  end
end
