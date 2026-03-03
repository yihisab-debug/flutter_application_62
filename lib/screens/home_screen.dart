import 'package:flutter/material.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _countries = [
      {
      'country': 'Кыргызстан',
      'flag': '🇰🇬',
      'cities': [
        {'name': 'Бишкек', 'query': 'Bishkek'},
        {'name': 'Ош', 'query': 'Osh, Kyrgyzstan'},
        {'name': 'Ысык-Кол', 'query': 'Issyk-Kul'},
        {'name': 'Жалал-Абад', 'query': 'Jalal-Abad'},
      ],
    },
    {
      'country': 'Казахстан',
      'flag': '🇰🇿',
      'cities': [
        {'name': 'Алматы', 'query': 'Almaty'},
        {'name': 'Астана', 'query': 'Astana'},
        {'name': 'Шымкент', 'query': 'Shymkent'},
        {'name': 'Атырау', 'query': 'Atyrau'},
      ],
    },
    {
      'country': 'Россия',
      'flag': '🇷🇺',
      'cities': [
        {'name': 'Москва', 'query': 'Moscow'},
        {'name': 'Санкт-Петербург', 'query': 'Saint Petersburg'},
        {'name': 'Новосибирск', 'query': 'Novosibirsk'},
      ],
    },

  ];

  void _navigateToWeather(String cityQuery, String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            WeatherScreen(cityQuery: cityQuery, cityName: cityName),
      ),
    );
  }

  void _searchCity() {
    final city = _searchController.text.trim();
    if (city.isNotEmpty) {
      _navigateToWeather(city, city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Row(
          children: [

            Text('⛅', style: TextStyle(fontSize: 20)),

            SizedBox(width: 8),

            Text(
              'Погода',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),

          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),

            const Center(child: Text('⛅', style: TextStyle(fontSize: 48))),

            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Прогноз погоды',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 4),

            const Center(
              child: Text(
                'Найдите любой город или выберите из списка',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите город...',

                prefixIcon: const Icon(Icons.search, color: Colors.grey),

                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward,
                      color: Color(0xFF1565C0)),
                  onPressed: _searchCity,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1565C0)),
                ),

              ),
              onSubmitted: (_) => _searchCity(),
            ),

            const SizedBox(height: 28),

            ..._countries.map((countryData) {
              final cities =
                  countryData['cities'] as List<Map<String, String>>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Text(
                        countryData['flag'] as String,
                        style: const TextStyle(fontSize: 22),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        countryData['country'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 110,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),

                    itemCount: cities.length,
                    itemBuilder: (context, index) {
                      final city = cities[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _navigateToWeather(
                              city['query']!, city['name']!),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  city['name']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const Text(
                                  'Нажмите для просмотра',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton.icon(

                                    onPressed: () => _navigateToWeather(
                                        city['query']!, city['name']!),

                                    icon: const Text('☁️',
                                        style: TextStyle(fontSize: 11)),

                                    label: const Text(
                                      'Погода',
                                      style: TextStyle(fontSize: 12),

                                    ),

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF1565C0),

                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),

                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}