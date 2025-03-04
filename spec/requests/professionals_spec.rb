RSpec.describe "/professionals", type: :request do
  let(:valid_attributes) {
    { name: "Dr. Smith", email: "dr.smith@example.com", password: "password", isProfessional: true }
  }

  let(:invalid_attributes) {
    { name: "", email: "invalid-email", password: "", isProfessional: true }
  }

  describe "GET /index" do
    it "renders a successful response and lists only professionals" do
      professional = User.create! valid_attributes
      non_professional = User.create!(valid_attributes.merge(isProfessional: false))

      get professionals_url
      expect(response).to be_successful
      expect(response.body).to include(professional.name)
      expect(response.body).not_to include(non_professional.name)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      professional = User.create! valid_attributes
      get professional_url(professional)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_professional_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      professional = User.create! valid_attributes
      get edit_professional_url(professional)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Professional (User with isProfessional: true)" do
        expect {
          post professionals_url, params: { user: valid_attributes }
        }.to change(User.where(isProfessional: true), :count).by(1)
      end

      it "redirects to the created professional" do
        post professionals_url, params: { user: valid_attributes }
        expect(response).to redirect_to(professional_url(User.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Professional" do
        expect {
          post professionals_url, params: { user: invalid_attributes }
        }.not_to change(User, :count)
      end

      it "renders a response with 422 status" do
        post professionals_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    let(:new_attributes) {
      { name: "Updated Name" }
    }

    it "updates the requested professional" do
      professional = User.create! valid_attributes
      patch professional_url(professional), params: { user: new_attributes }
      professional.reload
      expect(professional.name).to eq("Updated Name")
    end

    it "redirects to the professional" do
      professional = User.create! valid_attributes
      patch professional_url(professional), params: { user: new_attributes }
      professional.reload
      expect(response).to redirect_to(professional_url(professional))
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested professional" do
      professional = User.create! valid_attributes
      expect {
        delete professional_url(professional)
      }.to change(User, :count).by(-1)
    end

    it "redirects to the professionals list" do
      professional = User.create! valid_attributes
      delete professional_url(professional)
      expect(response).to redirect_to(professionals_url)
    end
  end
end