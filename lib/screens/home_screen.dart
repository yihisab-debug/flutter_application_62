import 'package:flutter/material.dart';
import 'weather_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> _popularCities = [
    {'name': 'Ош', 'query': 'Osh'},
    {'name': 'Бишкек', 'query': 'Bishkek'},
    {'name': 'Ысык-Кол', 'query': 'Issyk-Kul'},
    {'name': 'Лондон', 'query': 'London'},
    {'name': 'Нью-Йорк', 'query': 'New York'},
  ];

  void _navigateToWeather(String cityQuery, String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherScreen(cityQuery: cityQuery, cityName: cityName),
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
          children: [

            const SizedBox(height: 24),

            const Text('⛅', style: TextStyle(fontSize: 48)),

            const SizedBox(height: 8),

            const Text(
              'Прогноз погоды',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              'Найдите любой город или выберите из списка',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите город...',

                prefixIcon: const Icon(Icons.search, color: Colors.grey),

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

            const SizedBox(height: 32),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 160,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),

              itemCount: _popularCities.length,
              itemBuilder: (context, index) {
                final city = _popularCities[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          city['name']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'Посмотреть погоду и прогноз',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton.icon(
                          onPressed: () => _navigateToWeather(city['query']!, city['name']!),

                          icon: const Text('☁️', style: TextStyle(fontSize: 14)),

                          label: const Text('Смотреть погоду', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}