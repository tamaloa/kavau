class PaymentsController < ApplicationController
  include LoadAuthorized

  def edit
    respond_with @payment
  end

  def create
    @payment.save
    @credit_agreement = @payment.credit_agreement
    respond_with @payment, location: @payment.credit_agreement do |format|
      format.js { render :new }
    end
  end

  def update
    set_type if permitted_params[:type]
    @payment.update(permitted_params)
    respond_with @payment, location: @payment.credit_agreement
  end

  def destroy
    @payment.destroy
    respond_with @payment, location: @payment.credit_agreement
  end

  private
    def create_params
      permitted_params.merge(credit_agreement_id: params[:credit_agreement_id])
    end

    def set_type
      @payment = @payment.becomes(permitted_params[:type].constantize)
    end
end
