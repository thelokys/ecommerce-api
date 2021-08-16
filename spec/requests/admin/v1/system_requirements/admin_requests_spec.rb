require "rails_helper"

RSpec.describe "Admin V1 System Requirements as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    it "should return all system requirements" do
      get url, headers: auth_header(user)
      expect(body_json["system_requirements"]).to contain_exactly(
        *system_requirements.as_json(
          only: %i(id name operational_system storage processor memory video_board)
        )
      )
    end

    it "should return 200 (success) status" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }

    context "with valid params" do
      let(:system_requirement_params) {
        { system_requirement: attributes_for(:system_requirement) }.to_json
      }

      it "adds a new SystemRequirement" do
        expect do
          post url, headers: auth_header(user), params: system_requirement_params
        end.to change(SystemRequirement, :count).by(1)
      end

      it "returns last added SystemRequirement" do
        post url, headers: auth_header(user), params: system_requirement_params
        expected_system_requirement = SystemRequirement.last.as_json(
          only: %i(id name operational_system storage processor memory video_board)
        )
        expect(body_json["system_requirement"]).to eq expected_system_requirement
      end

      it "returns success status" do
        post url, headers: auth_header(user), params: system_requirement_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:system_requirement_invalid_params) do
        { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json
      end

      it "should not adds a new system requirement" do
        expect do
          post url, headers: auth_header(user), params: system_requirement_invalid_params
        end.to_not change(SystemRequirement, :count)
      end

      it "should return error message" do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "should return unprocessable_entity status" do
        post url, headers: auth_header(user), params: system_requirement_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end