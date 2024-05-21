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
    name: 'Padel 2000 (Antwerpen)',
    address: 'Filip Williotstraat 1, 2600 Antwerpen, Belgium',
    price: 20,
    times: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'],
    imageUrl: 'assets/padel2000.jpeg',
  ),
  Location(
    name: 'Pacma (Maaseik)',
    address: 'Slachthuislaan 29, 2060 Antwerpen, Belgium',
    price: 18,
    times: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'],
    imageUrl: 'assets/pacma.jpg',
  ),
  Location(
    name: 'Ter Eiken (Edegem)',
    address: 'Julius de Geyterstraat 133, 2000 Antwerpen, Belgium',
    price: 22,
    times: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'],
    imageUrl: 'assets/ter_eiken.jpg',
  ),
  Location(
    name: 'Garrincha (Hoboken)',
    address: 'Lageweg 356, 2660 Antwerpen, Belgium',
    price: 18,
    times: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'],
    imageUrl: 'assets/garincha.jpg',
  ),
  Location(
    name: 'Antwerp Padelclub (Berchem)',
    address: 'Zonnestroomstraat 2A, 2020 Antwerpen, Belgium',
    price: 20,
    times: ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'],
    imageUrl: 'assets/berchem.jpg',
  ),
];
