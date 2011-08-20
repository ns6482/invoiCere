# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
r1 = Role.new()
r1.id =1
r1.name = 'Admin'
r1.save

r2 = Role.new()
r2.id =2
r2.name = 'Standard'
r2.save

r3 = Role.new() 
r3.id =3
r3.name = 'Viewer'
r3.save

r4 = Role.new()
r4.id = 4
r4.name = 'Client'
r4.save
