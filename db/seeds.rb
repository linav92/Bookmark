# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# require 'faker'

20.times do |i|
    title = Faker::Kpop.girl_groups + (i + 1).to_s
    Kind.create!(title: title)
end

10.times do |i|
    title = Faker::Kpop.solo + (i + 1).to_s
    is_public = [true, false].sample
    Seed = Category.create!(title: title, is_public: is_public)
    10.times do |j|
        title = Faker::Kpop.solo + (j + 1).to_s
        is_public = [true, false].sample
        category_id = Seed.id
        Category.create!(title: title, is_public: is_public, category_id: category_id)
    end
end

categories = Category.all
kinds = Kind.all

10.times do |i|
  title = Faker::Hipster.word + (i + 1).to_s
  url = Faker::Internet.url
  Bookmark.create!(title: title, url: url)
end

Bookmark.all.each do |b|
  3.times do 
    BookmarkCategory.create!(bookmark: b, category: categories.sample)
    BookmarkKind.create!(bookmark: b, kind: kinds.sample)
  end
end
