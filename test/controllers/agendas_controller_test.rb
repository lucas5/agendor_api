require 'rails_helper'

class AgendasControllerTest < ActionDispatch::IntegrationTest
  describe "GET show_agenda" do
    it "returns a 200" do
      get :show_agenda
      expect(response).to have_http_status(:ok)
    end
  end
end
