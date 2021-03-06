class InterestSpanPresenter < BasePresenter
  def name
    CreditAgreement.human_attribute_name :interest
  end

  def klass
    'interest'
  end

  def date
    ''
  end

  def span
    "#{I18n.l(start_date)} - #{I18n.l(end_date)}"
  end

  def base_amount
    h.number_to_currency @model.base_amount
  end

  def calculation
    "#{interest_days} / #{days_in_year} x #{h.number_to_percentage(interest_rate)} x #{base_amount}"
  end

  def amount
    h.number_to_currency(@model.amount)
  end
end
