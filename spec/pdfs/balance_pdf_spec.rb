require 'rails_helper'

RSpec.describe BalancePdf do
  include ActionView::Helpers::NumberHelper

  before :each do
    @creditor = create :person, name: 'Meier', first_name: 'Albert', title: 'Dr.',
      street_number: 'Strasse 1', zip: '79100', city: 'Freiburg'
    @project_address = create :project_address, :with_legals, :with_contacts, name: 'Das Projekt',
      street_number: 'Weg 1', zip: '7800', city: "Städtl", email: 'info@example.org', phone: 'PhoneNumber' 
    @account = create :account, address: @project_address, bank: 'DiBaDu', default: true
    @credit_agreement = create :credit_agreement, account: @account, creditor: @creditor
    create :deposit, amount: 1000, credit_agreement: @credit_agreement, date: Date.today.end_of_year.prev_year
    @deposit = create :deposit, amount: 2000, credit_agreement: @credit_agreement, date: Date.today.beginning_of_year.next_day(30)
    @balance = create :balance, credit_agreement: @credit_agreement, date: Date.today.end_of_year
    @letter = create :balance_letter, year: Date.today.year, content: 'Covering Letter', subject: 'TheSubject'
    @pdf = BalancePdf.new(@balance)
  end

  it "has the right content" do
    page_analysis = PDF::Inspector::Page.analyze(@pdf.render)
    expect(page_analysis.pages.size).to eq(3)

    ### FIRST PAGE: covering letter
    text_analysis = page_analysis.pages[0][:strings]
    #address_field
    expect(text_analysis).to include("Das Projekt GmbH, Weg 1, 7800 Städtl")
    expect(text_analysis).to include("Dr. Albert Meier")
    expect(text_analysis).to include("Strasse 1")
    expect(text_analysis).to include("79100 Freiburg")
    expect(text_analysis).to include("Deutschland")

    #main part
    expect(text_analysis).to include(I18n.l(Date.today))
    expect(text_analysis).to include("Betreff:")
    expect(text_analysis).to include(" TheSubject")
    expect(text_analysis).to include("Covering Letter")

    #footer
    expect(text_analysis).to include("Das Projekt GmbH")
    expect(text_analysis).to include(" Sitz: City | Court RegistragionNumber | Steuernummer: TaxNumber")
    expect(text_analysis).to include("Geschäftsführung:")
    expect(text_analysis).to include(" Vorname Test Name")
    expect(text_analysis).to include("Bankverbindung:")
    expect(text_analysis).to include(" DiBaDu | BIC: GENODEF1S02 | IBAN: RO49 AAAA 1B31 0075 9384 0000")

    ### SECOND PAGE: balance
    text_analysis = page_analysis.pages[1][:strings]
    #address_field
    expect(text_analysis).to include("Das Projekt GmbH, Weg 1, 7800 Städtl")
    expect(text_analysis).to include("Dr. Albert Meier")
    expect(text_analysis).to include("Strasse 1")
    expect(text_analysis).to include("79100 Freiburg")
    expect(text_analysis).to include("Deutschland")

    #main part
    expect(text_analysis).to include("Kreditvertrag Nr #{@credit_agreement.id} - Jahresabschluss #{@balance.date.year}")
    expect(text_analysis).to include("Datum")
    expect(text_analysis).to include("Zinstage")
    expect(text_analysis).to include("Zinsberechnung")
    expect(text_analysis).to include("Betrag")
    expect(text_analysis).to include(I18n.l(Date.today.prev_year.end_of_year))
    expect(text_analysis).to include(number_to_currency(1000))
    expect(text_analysis).to include('31')
    expect(text_analysis).to include("31 / 365 x 2,00% x 1.000,00 €")
    expect(text_analysis).to include("1,70 €")
    expect(text_analysis).to include("Einzahlung")
    expect(text_analysis).to include("2.000,00 €")
    expect(text_analysis).to include("334")
    expect(text_analysis).to include("334 / 365 x 2,00% x 3.000,00 €")
    expect(text_analysis).to include("54,90 €")
    expect(text_analysis).to include("Saldo")
    expect(text_analysis).to include("Zinsen")
    expect(text_analysis).to include(I18n.l(Date.today.end_of_year))
    expect(text_analysis).to include("3.056,60 €")

    #footer
    expect(text_analysis).to include("Das Projekt GmbH")
    expect(text_analysis).to include(" Sitz: City | Court RegistragionNumber | Steuernummer: TaxNumber")
    expect(text_analysis).to include("Geschäftsführung:")
    expect(text_analysis).to include(" Vorname Test Name")
    expect(text_analysis).to include("Bankverbindung:")
    expect(text_analysis).to include(" DiBaDu | BIC: GENODEF1S02 | IBAN: RO49 AAAA 1B31 0075 9384 0000")

    ### THIRD PAGE: interest certificate
    text_analysis = page_analysis.pages[2][:strings]
    #address_field
    expect(text_analysis).to include("Das Projekt GmbH, Weg 1, 7800 Städtl")
    expect(text_analysis).to include("Dr. Albert Meier")
    expect(text_analysis).to include("Strasse 1")
    expect(text_analysis).to include("79100 Freiburg")
    expect(text_analysis).to include("Deutschland")

    #main part
    expect(text_analysis).to include(I18n.l(Date.today))
    expect(text_analysis).to include("Zinsbescheinigung für das Jahr 2015")
    expect(text_analysis).to include("Dr. Albert Meier hat der Das Projekt GmbH einen zinsgünstigen Direktkredit zur Verfügung")
    expect(text_analysis).to include("gestellt, zur Unterstützung der sozialen Zwecke des selbstorganisiserten")
    expect(text_analysis).to include("Mietshausprojektes LAMA")
    expect(text_analysis).to include("Kreditvertrag-Nr")
    expect(text_analysis).to include("Zinssatz")
    expect(text_analysis).to include("Jahreszinsbetrag #{@balance.date.year}")
    expect(text_analysis).to include(@credit_agreement.id.to_s)
    expect(text_analysis).to include("2,00% p.a.")
    expect(text_analysis).to include("56,60 €")
    expect(text_analysis).to include("Wir bedanken uns für die Unterstützung.")
    expect(text_analysis).to include("Das Projekt GmbH")

    #footer
    expect(text_analysis).to include("Das Projekt GmbH")
    expect(text_analysis).to include(" Sitz: City | Court RegistragionNumber | Steuernummer: TaxNumber")
    expect(text_analysis).to include("Geschäftsführung:")
    expect(text_analysis).to include(" Vorname Test Name")
    expect(text_analysis).to include("Bankverbindung:")
    expect(text_analysis).to include(" DiBaDu | BIC: GENODEF1S02 | IBAN: RO49 AAAA 1B31 0075 9384 0000")
  end
end
