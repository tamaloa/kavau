class Person < Creditor
  strip_attributes

  validates :name, :first_name, :street_number, :zip, :city, :country_code, :salutation, presence: true
end
