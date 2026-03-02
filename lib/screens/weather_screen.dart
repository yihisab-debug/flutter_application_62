import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  final String cityQuery;
  final String cityName;

  const WeatherScreen({super.key, required this.cityQuery, required this.cityName});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final data = await WeatherService.getCurrentWeather(widget.cityQuery);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _getDayName(String dateStr) {
    final date = DateTime.parse(dateStr);
    const days = ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'];
    const months = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}.';
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const Icon(Icons.error_outline, size: 64, color: Colors.red),

                      const SizedBox(height: 16),

                      Text('Ошибка: $_error'),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _loadWeather();
                        },
                        child: const Text('Повторить'),
                      ),

                    ],
                  ),
                )
              : _buildWeatherContent(),
    );
  }

  Widget _buildWeatherContent() {
    final current = _weatherData!['current'];
    final location = _weatherData!['location'];
    final forecast = _weatherData!['forecast']['forecastday'] as List;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    '${location['name']}, ${location['country']}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [

                      Image.network(
                        'https:${current['condition']['icon']}',
                        width: 48,
                        height: 48,
                        errorBuilder: (_, __, ___) => const Text('☁️', style: TextStyle(fontSize: 36)),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${current['temp_c'].toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    current['condition']['text'],
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('Ощущается: ${current['feelslike_c'].toStringAsFixed(1)}°C',
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),

                      Text('Влажность: ${current['humidity']}%',
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),

                      Text('Ветер: ${current['wind_kph']} км/ч',
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),

                    ],
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Прогноз на 7 дней',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 175,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),

            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final day = forecast[index];
              final dayInfo = day['day'];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        _getDayName(day['date']),
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      Image.network(
                        'https:${dayInfo['condition']['icon']}',
                        width: 36,
                        height: 36,
                        errorBuilder: (_, __, ___) => const Text('☁️', style: TextStyle(fontSize: 28)),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        dayInfo['condition']['text'],
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${dayInfo['maxtemp_c'].toStringAsFixed(1)}° / ${dayInfo['mintemp_c'].toStringAsFixed(1)}°',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text('💧', style: TextStyle(fontSize: 10)),

                          Text(
                            ' ${dayInfo['avghumidity'].toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text('💨', style: TextStyle(fontSize: 10)),

                          Text(
                            ' ${dayInfo['maxwind_kph'].toStringAsFixed(1)} км/ч',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),

                        ],
                      ),
                      
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}