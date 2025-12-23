# Clear existing data
Car.destroy_all

# Create sample cars
cars_data = [
  {
    brand: "BMW",
    model: "M4 Competition",
    year: 2024,
    price_per_day: 299.99,
    description: "Доживејте го совршениот спој на луксуз и перформанси со BMW M4 Competition. Оваа зафатлива купе има twin-turbo V6 мотор кој произведува 503 коњски сили, напреден M xDrive погон на сите тркала, и прецизно изработен ентериер со премиум материјали. Без разлика дали се возите низ градот или се справувате со кривулести патишта, M4 Competition обезбедува незаборавно искуство во возењето.",
    image_url: "https://images.unsplash.com/photo-1555215695-3004980ad54e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK1234AB"
  },
  {
    brand: "Mercedes-Benz",
    model: "AMG GT 63 S",
    year: 2024,
    price_per_day: 459.99,
    description: "Mercedes-AMG GT 63 S 4MATIC+ е ремек-дело на германското инженерство. Со својот рачно изработен 4.0-литарски V8 biturbo мотор кој произведува 630 коњски сили, оваа четириврата купе ги комбинира трковните перформанси со секојдневната употребливост. Луксузниот ентериер има Nappa кожа, карбонски влакна и најсовремена технологија.",
    image_url: "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK5678CD"
  },
  {
    brand: "Audi",
    model: "RS6 Avant",
    year: 2023,
    price_per_day: 349.99,
    description: "Audi RS6 Avant докажува дека семејните автомобили можат да бидат возбудливи. Овој високо-перформантен караван има 4.0-литарски twin-turbo V8 кој произведува 591 коњска сила, quattro погон на сите тркала, и просторен ентериер кој е совршен и за секојдневни патувања и за викенд излети. Тоа е врвниот спој на практичност и перформанси.",
    image_url: "https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK9012EF"
  },
  {
    brand: "Porsche",
    model: "911 Turbo S",
    year: 2024,
    price_per_day: 599.99,
    description: "Иконичниот Porsche 911 Turbo S го претставува врвот на спортското автомобилско инженерство. Со својот twin-turbo flat-six мотор кој произведува 640 коњски сили и PDK трансмисија, обезбедува спиротивачко забрзување и прецизно управување. Вечниот дизајн и луксузниот ентериер прават секоја возба специјална.",
    image_url: "https://images.unsplash.com/photo-1544636331-e26879cd4d9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK3456GH"
  },
  {
    brand: "Lamborghini",
    model: "Huracán EVO",
    year: 2023,
    price_per_day: 799.99,
    description: "Lamborghini Huracán EVO е суперавтомобил кој бара внимание. Неговиот природно аспириран 5.2-литарски V10 мотор произведува 630 коњски сили и опојувачка звучна слика. Со својот остар агуларен дизајн, напредна аеродинамика и технологија инспирирана од тркалиштето, Huracán EVO обезбедува незаборавно искуство во возењето.",
    image_url: "https://images.unsplash.com/photo-1544636331-e26879cd4d9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK7890IJ"
  },
  {
    brand: "Tesla",
    model: "Model S Plaid",
    year: 2024,
    price_per_day: 399.99,
    description: "Tesla Model S Plaid го редефинира тоа што електричното возило може да биде. Со својот три-моторен систем кој произведува над 1,000 коњски сили, забрзува од 0-100 км/ч за помалку од 2 секунди. Минималистичкиот ентериер има 17-инчен допирен екран, премиум материјали и најсовремена autopilot технологија.",
    image_url: "https://images.unsplash.com/photo-1560958089-b8a1929cea89?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK2345KL"
  },
  {
    brand: "Ferrari",
    model: "F8 Tributo",
    year: 2023,
    price_per_day: 899.99,
    description: "Ferrari F8 Tributo е прослава на наследството на V8 моторот. Овој суперавтомобил со среден мотор има 3.9-литарски twin-turbo V8 кој произведува 710 коњски сили. Со својот зафатлив италијански дизајн, напредна аеродинамика и технологија изведена од тркалиштето, F8 Tributo нуди чисто и возбудливо искуство во возењето.",
    image_url: "https://images.unsplash.com/photo-1583121274602-3e2820c69888?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK6789MN"
  },
  {
    brand: "Rolls-Royce",
    model: "Ghost",
    year: 2024,
    price_per_day: 999.99,
    description: "Rolls-Royce Ghost го отелотворува луксузот и рафинираноста. Погонуван од 6.75-литарски twin-turbo V12 мотор, обезбедува неприсилни перформанси во шепотлива тишина. Рачно изработениот ентериер има најфини материјали, и секој детал е педантно дизајниран за да обезбеди врвно луксузно искуство.",
    image_url: "https://images.unsplash.com/photo-1563720223-b29d5d3131d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK0123OP"
  },
  {
    brand: "Bentley",
    model: "Continental GT",
    year: 2023,
    price_per_day: 549.99,
    description: "Bentley Continental GT е grand tourer кој ги комбинира британскиот луксуз со импресивни перформанси. Неговиот 6.0-литарски twin-turbo W12 мотор произведува 626 коњски сили, додека ентериерот има рачно изработена кожа, вистински дрвени фурнири и дијамантски прошиени седишта. Совршен за далечински турнеи во врвен комфор.",
    image_url: "https://images.unsplash.com/photo-1549399937-673d50ac8516?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
    available: true,
    registration_plate_number: "SK4567QR"
  }
]

cars_data.each do |car_data|
  Car.create!(car_data)
  puts "Created car: #{car_data[:brand]} #{car_data[:model]}"
end

puts "Successfully created #{Car.count} cars!"
