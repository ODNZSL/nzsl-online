# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

not_found_page = Page.create!(title: 'Page not found', template: 'home')
Setting.create!(key: :"404", value: not_found_page.id)

help_page = Page.create!(title: "Help page", template: 'standard')
Setting.create!(key: "help", value: help_page.id)
