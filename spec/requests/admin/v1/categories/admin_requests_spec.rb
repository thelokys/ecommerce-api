require 'rails_helper'

RSpec.describe "Admin::V1::Categories as :admin", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let!(:categories) { create_list(:category, 5) }
    let(:url) { "/admin/v1/categories" }

    it "should return all Categories" do
      get url, headers: auth_header(user)
      expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name))
    end

    it "should return status 200 success" do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST: /categories" do
    let(:url) { "/admin/v1/categories" }

    context "with valid params" do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      it "adds a new Category" do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by(1)
      end

      it "should return last added category" do
        post url, headers: auth_header(user), params: category_params
        expected_category = Category.last.as_json(only: %i(id name))
        expect(body_json['category']).to eq expected_category
      end

      it "should return status 201 created" do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil) }.to_json
      end

      it "should not add a new category" do
        expect do
          post url, headers: auth_header(user), params: category_invalid_params
        end.to_not change(Category, :count)
      end

      it "should return error messages" do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(body_json['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable_entity status" do
        post url, headers: auth_header(user), params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    context "With valid params" do
      let(:new_name) { "my new Category" }
      let(:category_params) { {category: { name: new_name }}.to_json }

      it "updates Category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq(new_name)
      end

      it "returns updated category" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect_category = category.as_json(only: %i(id name))
        expect(body_json["category"]).to eq(expect_category)
      end

      it "returns success category" do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:created)
      end
    end

    context "With invalid params" do

      let(:category_invalid_params) do
        { category: attributes_for(:category, name: nil)  }.to_json
      end

      it "does not update category" do
        old_name = category.name
        patch url, headers: auth_header(user),params: category_invalid_params
        category.reload
        expect(category.name).to eq(old_name)
      end

      it "returns error messages" do
        patch url, headers: auth_header(user),params: category_invalid_params
        expect(body_json["errors"]["fields"]).to have_key("name")
      end

      it "returns unprocessable_entity status" do
        patch url, headers: auth_header(user),params: category_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "DELETE /categories/:id" do
      let!(:category) { create(:category) }
      let(:url) { "/admin/v1/categories/#{category.id}" }

      it "removes Category" do
        expect do
          delete url, headers: auth_header(user)
        end.to change(Category, :count).by(-1)
      end

      it "returns success status" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end

      it "does not retunr any body content" do
        delete url, headers: auth_header(user)
        expect(body_json).to_not be_present
      end

      it "removes all associated product categories" do
        product_categories = create_list(:product_category, 3, category: category)
        delete url, headers: auth_header(user)

        expected_product_categories = ProductCategory.where(
          :id => product_categories.map(&:id)
        )
        expect(expected_product_categories).to eq []
      end
    end
  end
end
