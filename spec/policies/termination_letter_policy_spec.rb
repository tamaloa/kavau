require 'rails_helper'

RSpec.describe TerminationLetterPolicy do
  subject { TerminationLetterPolicy.new(user, letter) }
  let(:letter) { FactoryGirl.build(:termination_letter) }

  context "for an admin" do
    let(:user){ create :admin }
    permits :all
  end

  context "for an accountant" do
    let(:user){ create :accountant }
    permits :all 
  end

  context "for a non privileged user" do
    let(:user){ create :user }
    permits :none
  end

  context "a termination letter exists" do
    before(:each){ FactoryGirl.create(:termination_letter) }

    context "for an admin" do
      let(:user){ create :admin }
      permits [:index, :show, :update, :edit, :destroy]
    end

    context "for an accountant" do
      let(:user){ create :accountant }
      permits [:index, :show, :update, :edit, :destroy]
    end

  end
end
