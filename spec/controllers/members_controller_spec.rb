require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "POST #create" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      @campaign = create(:campaign, user: @current_user)
      @member_attributes = attributes_for(:member, campaign_id: @campaign.id)
      post :create, params: {member: @member_attributes}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "Create member with right attributes" do
      expect(Member.last.campaign).to eql(@campaign)
      expect(Member.last.name).to eql(@member_attributes[:name])
      expect(Member.last.email).to eql(@member_attributes[:email])
    end

    it "Create member with associated campaign" do
      expect(Member.last.campaign.user).to eql(@current_user)
      expect(Member.last.campaign.title).to eql(@campaign.title)
      expect(Member.last.campaign.description).to eql(@campaign.description)
    end

    it "Member belongs to campaign" do
      post :create, params: {member: @member_attributes}
      expect(response).to have_http_status(:unprocessable_entity)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body['email'][0]).to eql("member already belongs to campaign")
    end

    #it "User cannot insert a member" do
    #  campaign = create(:campaign)
    #  @member_attributes = attributes_for(:member, campaign_id: campaign.id)
    #  post :create, params: {member: @member_attributes}
    #  expect(response).to have_http_status(:forbidden)
    #nd
  end

  describe "DELETE #destroy" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign: campaign)
    end

    it "member was deleted" do
      delete :destroy, params: {id: @member.id}
      expect(response).to have_http_status(:success)
      #expect(@campaign.members.where(id: @member.id).present?).to be true
    end

    it "Member not found" do
      @id = Member.last.id + 1;
      delete :destroy, params: {id: @id}
      expect(response).to redirect_to('/')
    end

    #it "User cannot delete a member" do
    #  @request.env["devise.mapping"] = Devise.mappings[:user]
    #  @user = FactoryBot.create(:user)
    #  sign_in @user
    #  delete :destroy, params: {id: @member.id}
    #  expect(response).to have_http_status(:forbidden)
    #end
  end

  describe "PUT #update" do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
      @campaign = create(:campaign, user: @current_user)
      @member = create(:member, campaign: @campaign)
      @new_member_attributes = attributes_for(:member)
    end

    it "Member updated" do
      put :update, params: {id: @member.id, member: @new_member_attributes}
      expect(response).to have_http_status(:success)
    end

    #it "Email exists" do
    #  member_attributes = attributes_for(:member)
    #  member_attributes[:email] = FFaker::Internet.email
    #  put :update, params: {id: @member.id, member: member_attributes}
    #  expect(response).to have_http_status(:unprocessable_entity)
    #end
  end
end
