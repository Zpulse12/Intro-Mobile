class Location {
  final String name;
  final String address;
  final int price;
  final List<String> times;
  final String imageUrl;

  Location({
    required this.name,
    required this.address,
    required this.price,
    required this.times,
    required this.imageUrl,
  });
}

List<Location> locations = [
  Location(
    name: 'Antwerp Padelclub',
    address: 'Filip Williotstraat 1, 2600 Antwerpen, Belgium',
    price: 20,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/antwerpenCourt.jpg',
  ),
  Location(
    name: 'Garrincha Antwerpen Noord',
    address: 'Slachthuislaan 29, 2060 Antwerpen, Belgium',
    price: 18,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court2.jpg',
  ),
  Location(
    name: 'Tennis 7th Olympiad | Tennis & Padel',
    address: 'Julius de Geyterstraat 133, 2000 Antwerpen, Belgium',
    price: 22,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court3.jpg',
  ),
  Location(
    name: 'Garrincha Antwerpen Zuid',
    address: 'Lageweg 356, 2660 Antwerpen, Belgium',
    price: 18,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court4.jpg',
  ),
  Location(
    name: 'The Box Padel (Padel 2000)',
    address: 'Zonnestroomstraat 2A, 2020 Antwerpen, Belgium',
    price: 20,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court5.jpg',
  ),
  Location(
    name: 'Royal Antwerp Hockey Club',
    address: 'Middelheimlaan 50, 2020 Antwerpen, Belgium',
    price: 24,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court6.jpg',
  ),
  Location(
    name: 'Padel 4U2 Berchem',
    address: 'Grotesteenweg 91, 2600 Antwerpen, Belgium',
    price: 19,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court8.jpg',
  ),
  Location(
    name: 'TC Forest Hills',
    address: 'Grote Baan 11, 2260 Westerlo, Belgium',
    price: 21,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court9.jpg',
  ),
  Location(
    name: 'Padel Club Nivelles',
    address: 'Chaussée de Bruxelles 165, 1400 Nivelles, Belgium',
    price: 25,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court10.jpg',
  ),
  Location(
    name: 'Padel 2.0',
    address: 'Antwerpsesteenweg 79, 2630 Aartselaar, Belgium',
    price: 23,
    times: ['16:00', '16:30', '17:00', '17:30', '18:00'],
    imageUrl: 'assets/court11.jpg', 
  ),
];
