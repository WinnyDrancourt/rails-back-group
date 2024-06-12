require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { double('User', id: 1, email: 'user@example.com') }
  let(:product) do double('Product', id: 1, title: 'Sample Product', price: 100.0, description: 'Sample Description', user_id: user.id, as_json: { 'user'=>{ 'email'=>user.email } })
  end

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "when user_id is provided" do
      it "returns products for the specified user" do
        allow(Product).to receive(:where).with(user_id: user.id.to_s).and_return([ product ])
        get :index, params: { user_id: user.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end

    context "when user_id is not provided" do
      it "returns all products" do
        allow(Product).to receive(:all).and_return([ product ])
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
  end

  describe "GET #show" do
    before do
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
    end

    it "returns the product with user email" do
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
    end
  end

  describe "POST #create" do
    before do
      allow(user).to receive_message_chain(:products, :build).and_return(product)
      allow(product).to receive(:image).and_return(double('image', attach: nil))
      allow(product).to receive(:to_model).and_return(product)
      allow(product).to receive(:model_name).and_return(ActiveModel::Name.new(Product))
    allow(product).to receive(:persisted?).and_return(true)
    end

    context "when product is successfully created" do
      before do
        allow(product).to receive(:save).and_return(true)
      end

      it "creates a new product" do
        post :create, params: { product: { title: 'New Product', price: 200.0, description: 'New Description', user_id: user.id } }
        expect(response).to have_http_status(:created)
      end
    end

    context "when product creation fails" do
      before do
        allow(product).to receive(:save).and_return(false)
        allow(product).to receive_message_chain(:errors, :full_messages).and_return([ 'Error' ])
      end

      it "returns an error" do
        post :create, params: { product: { title: 'New Product', price: 200.0, description: 'New Description', user_id: user.id } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    before do
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
    end

    context "when update is successful" do
      before do
        allow(product).to receive(:update).and_return(true)
      end

      it "updates the product" do
        patch :update, params: { id: product.id, product: { title: 'Updated Title' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "when update fails" do
      before do
        allow(product).to receive(:update).and_return(false)
        allow(product).to receive_message_chain(:errors, :full_messages).and_return([ 'Error' ])
      end

      it "returns an error" do
        patch :update, params: { id: product.id, product: { title: 'Updated Title' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
      allow(product).to receive(:destroy!)
    end

    it "destroys the product" do
      delete :destroy, params: { id: product.id }
      expect(response).to have_http_status(:no_content)
    end
  end

  describe "Authorization" do
    before do
      allow(Product).to receive(:find).with(product.id.to_s).and_return(product)
      allow(controller).to receive(:current_user).and_return(double('User', id: 2))
    end

    it "returns unauthorized error if user is not the owner" do
      patch :update, params: { id: product.id, product: { title: 'Updated Title' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
