# Clear existing data
Car.destroy_all

# Create sample cars
cars_data = [
  {
    brand: "BMW",
    model: "M4 Competition",
    year: 2024,
    price_per_day: 299.99,
    description: "Experience the perfect blend of luxury and performance with the BMW M4 Competition. This stunning coupe features a twin-turbo V6 engine producing 503 horsepower, advanced M xDrive all-wheel drive, and a meticulously crafted interior with premium materials. Whether you're cruising through the city or attacking winding roads, the M4 Competition delivers an unforgettable driving experience.",
    image_url: "https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Mercedes-Benz",
    model: "AMG GT 63 S",
    year: 2024,
    price_per_day: 459.99,
    description: "The Mercedes-AMG GT 63 S 4MATIC+ is a masterpiece of German engineering. With its handcrafted 4.0-liter V8 biturbo engine delivering 630 horsepower, this four-door coupe combines race-bred performance with everyday usability. The luxurious interior features Nappa leather, carbon fiber accents, and cutting-edge technology.",
    image_url: "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Audi",
    model: "RS6 Avant",
    year: 2023,
    price_per_day: 349.99,
    description: "The Audi RS6 Avant proves that family cars can be thrilling. This high-performance wagon features a 4.0-liter twin-turbo V8 producing 591 horsepower, quattro all-wheel drive, and a spacious interior that's perfect for both daily commutes and weekend getaways. It's the ultimate blend of practicality and performance.",
    image_url: "https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Porsche",
    model: "911 Turbo S",
    year: 2024,
    price_per_day: 599.99,
    description: "The iconic Porsche 911 Turbo S represents the pinnacle of sports car engineering. With its twin-turbo flat-six engine producing 640 horsepower and PDK transmission, it delivers breathtaking acceleration and precision handling. The timeless design and luxurious interior make every drive special.",
    image_url: "https://images.unsplash.com/photo-1544636331-e26879cd4d9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Lamborghini",
    model: "Huracán EVO",
    year: 2023,
    price_per_day: 799.99,
    description: "The Lamborghini Huracán EVO is a supercar that demands attention. Its naturally aspirated 5.2-liter V10 engine produces 630 horsepower and an intoxicating soundtrack. With its sharp angular design, advanced aerodynamics, and race-inspired technology, the Huracán EVO delivers an unforgettable driving experience.",
    image_url: "https://images.unsplash.com/photo-1544636331-e26879cd4d9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Tesla",
    model: "Model S Plaid",
    year: 2024,
    price_per_day: 399.99,
    description: "The Tesla Model S Plaid redefines what an electric vehicle can be. With its tri-motor setup producing over 1,000 horsepower, it accelerates from 0-60 mph in under 2 seconds. The minimalist interior features a 17-inch touchscreen, premium materials, and cutting-edge autopilot technology.",
    image_url: "https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Ferrari",
    model: "F8 Tributo",
    year: 2023,
    price_per_day: 899.99,
    description: "The Ferrari F8 Tributo is a celebration of the V8 engine heritage. This mid-engine supercar features a 3.9-liter twin-turbo V8 producing 710 horsepower. With its stunning Italian design, advanced aerodynamics, and race-derived technology, the F8 Tributo offers an pure and exhilarating driving experience.",
    image_url: "https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "McLaren",
    model: "720S",
    year: 2023,
    price_per_day: 759.99,
    description: "The McLaren 720S represents British engineering excellence. Its 4.0-liter twin-turbo V8 produces 710 horsepower and is paired with a lightweight carbon fiber chassis. The dihedral doors, active aerodynamics, and telepathic handling make the 720S one of the most advanced supercars ever created.",
    image_url: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Rolls-Royce",
    model: "Ghost",
    year: 2024,
    price_per_day: 999.99,
    description: "The Rolls-Royce Ghost epitomizes luxury and refinement. Powered by a 6.75-liter twin-turbo V12 engine, it delivers effortless performance in whisper-quiet comfort. The hand-crafted interior features the finest materials, and every detail is meticulously designed to provide the ultimate luxury experience.",
    image_url: "https://images.unsplash.com/photo-1563720223-b29d5d3131d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  },
  {
    brand: "Bentley",
    model: "Continental GT",
    year: 2023,
    price_per_day: 549.99,
    description: "The Bentley Continental GT is a grand tourer that combines British luxury with impressive performance. Its 6.0-liter twin-turbo W12 engine produces 626 horsepower, while the interior features handcrafted leather, real wood veneers, and diamond-quilted seats. Perfect for long-distance touring in supreme comfort.",
    image_url: "https://images.unsplash.com/photo-1549399937-673d50ac8516?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true
  }
]

cars_data.each do |car_data|
  Car.create!(car_data)
  puts "Created car: #{car_data[:brand]} #{car_data[:model]}"
end

puts "Successfully created #{Car.count} cars!"
