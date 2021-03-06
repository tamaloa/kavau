class BalanceLetterPdf < CompositePdf
  def initialize(balance)
    @balance = balance
    @letter = get_template
    @creditor = balance.creditor
    super
  end

  private
  def build_parts
    covering_letter
    balance_page(@balance)
    interest_certificate_page([@balance])
  end

  def template
    @template
  end

  def get_template
    @template = BalanceLetter.find_by(year: @balance.date.year)
    raise MissingLetterTemplateError.new(BalanceLetter, @balance.date.year) unless @template
    @template
  end
end
