class TerminationLetterPolicy < LetterPolicy
  def create?
    return false unless user.admin? || user.accountant?
    !TerminationLetter.any?
  end

  def create_pdfs?
    false
  end

  def get_pdfs?
    false
  end
end

