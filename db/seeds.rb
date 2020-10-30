# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(email: "admin@kavau.syndikat.org", name: "Kavau", first_name: "Admin", role: "admin",
  login: "admin", password: "Bitte-sofort-ändern!", password_confirmation: "Bitte-sofort-ändern!")