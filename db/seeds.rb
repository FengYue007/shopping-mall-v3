10.times do
  Product.create(
    title: Faker::Name.name,
    description: Faker::Lorem.paragraph(sentence_count: 10),
    price: Faker::Number.between(from: 10, to: 100)
  )
  puts "add a product"
end
