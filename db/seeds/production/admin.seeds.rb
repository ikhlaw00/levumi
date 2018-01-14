# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


u = User.create(name: "Administrator", email: ENV['admin_email'], password: ENV['admin_password'], password_confirmation: ENV['admin_password'], capabilities: "admin")
if u.save
  STDOUT.puts "Admin account created!"
else
  STDOUT.puts "Something went wrong!"
end

