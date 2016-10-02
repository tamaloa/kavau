require 'rails_helper'

RSpec.describe CreditAgreementPolicy do
  context "new credit agreement" do
    let(:klass){ CreditAgreementPolicy}
    subject { CreditAgreementPolicy.new(user, credit_agreement) }
    let(:credit_agreement) { FactoryGirl.create(:credit_agreement) }

    context "for an admin" do
      let(:user){ create :admin }
      permits :all

      it "all attributes are permitted" do
        expect(subject.permitted_params).to contain_exactly(:amount, :interest_rate, :cancellation_period, :account_id, :number, :valid_from, :terminated_at)
      end
    end

    context "for an accountant" do
      let(:user){ create :accountant }
      permits :all

      it "all attributes are permitted" do
        expect(subject.permitted_params).to contain_exactly(:amount, :interest_rate, :cancellation_period, :account_id, :number, :valid_from, :terminated_at)
      end
    end

    context "for a non privileged user" do
      let(:user){ create :user }
      permits [:index]
    end
  end

  context "credit_agreement with payments" do
    subject { CreditAgreementPolicy.new(user, credit_agreement) }
    let(:credit_agreement) { FactoryGirl.create(:credit_agreement, :with_payment) }

    context "for an admin" do
      let(:user){ create :admin }
      permits :all, except: [:delete, :destroy]
      it "all attributes are permitted" do
        expect(subject.permitted_params).to contain_exactly(:amount, :interest_rate, :cancellation_period, :account_id, :number, :valid_from, :terminated_at)
      end
    end

    context "for an accountant" do
      let(:user){ create :accountant }
      permits :all, except: [:delete, :destroy]
      it "the attributes :interest_rate, :account_id and :valid_from are forbidden" do
        expect(subject.permitted_params).to contain_exactly(:amount, :cancellation_period, :number, :terminated_at)
      end
    end

    context "for a non privileged user" do
      let(:user){ create :user }
      permits [:index]
    end
  end
end
