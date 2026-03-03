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
    const months = [
      'янв', 'фев', 'мар', 'апр', 'май', 'июн',
      'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'
    ];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}.';
  }

  Map<String, dynamic> _getAqiInfo(int usEpaIndex) {
    switch (usEpaIndex) {
      case 1:
        return {'label': 'Хорошее', 'color': const Color(0xFF4CAF50), 'emoji': '😊'};
      case 2:
        return {'label': 'Умеренное', 'color': const Color(0xFFFFEB3B), 'emoji': '🙂'};
      case 3:
        return {'label': 'Нездоровое для чувствительных', 'color': const Color(0xFFFF9800), 'emoji': '😐'};
      case 4:
        return {'label': 'Нездоровое', 'color': const Color(0xFFF44336), 'emoji': '😷'};
      case 5:
        return {'label': 'Очень нездоровое', 'color': const Color(0xFF9C27B0), 'emoji': '🤢'};
      case 6:
        return {'label': 'Опасное', 'color': const Color(0xFF7B1FA2), 'emoji': '☠️'};
      default:
        return {'label': 'Нет данных', 'color': Colors.grey, 'emoji': '❓'};
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
    final airQuality = current['air_quality'];

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
                        errorBuilder: (_, __, ___) =>
                            const Text('☁️', style: TextStyle(fontSize: 36)),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${current['temp_c'].toStringAsFixed(1)}°C',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
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

                      Text(
                        'Ощущается: ${current['feelslike_c'].toStringAsFixed(1)}°C',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),

                      Text(
                        'Влажность: ${current['humidity']}%',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),

                      Text(
                        'Ветер: ${current['wind_kph']} км/ч',
                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (airQuality != null) _buildAirQualityCard(airQuality),

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
              mainAxisExtent: 190,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),

            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final day = forecast[index];
              final dayInfo = day['day'];

              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        _getDayName(day['date']),
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Image.network(
                        'https:${dayInfo['condition']['icon']}',
                        width: 36,
                        height: 36,
                        errorBuilder: (_, __, ___) =>
                            const Text('☁️',
                                style: TextStyle(fontSize: 28)),
                      ),

                      Text(
                        dayInfo['condition']['text'],
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        '${dayInfo['maxtemp_c'].toStringAsFixed(1)}°/${dayInfo['mintemp_c'].toStringAsFixed(1)}°',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text('💧',
                              style: TextStyle(fontSize: 10)),
                              
                          Flexible(
                            child: Text(
                              ' ${dayInfo['avghumidity'].toStringAsFixed(0)}%',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const Text('💨',
                              style: TextStyle(fontSize: 10)),

                          Flexible(
                            child: Text(
                              ' ${dayInfo['maxwind_kph'].toStringAsFixed(1)} км/ч',

                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
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

  Widget _buildAirQualityCard(Map<String, dynamic> aqi) {
    final int aqiIndex = (aqi['us-epa-index'] as num?)?.toInt() ?? 0;
    final aqiInfo = _getAqiInfo(aqiIndex);
    final Color aqiColor = aqiInfo['color'] as Color;
    final String aqiLabel = aqiInfo['label'] as String;
    final String aqiEmoji = aqiInfo['emoji'] as String;

    final double pm25 = (aqi['pm2_5'] as num?)?.toDouble() ?? 0;
    final double pm10 = (aqi['pm10'] as num?)?.toDouble() ?? 0;
    final double co = (aqi['co'] as num?)?.toDouble() ?? 0;
    final double no2 = (aqi['no2'] as num?)?.toDouble() ?? 0;
    final double o3 = (aqi['o3'] as num?)?.toDouble() ?? 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const Icon(Icons.air, color: Color(0xFF1565C0), size: 22),

                const SizedBox(width: 8),

                const Text(
                  'Качество воздуха',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

              ],
            ),

            const SizedBox(height: 14),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: aqiColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: aqiColor.withOpacity(0.4)),
              ),
              child: Row(
                children: [

                  Text(aqiEmoji, style: const TextStyle(fontSize: 28)),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        aqiLabel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: aqiColor,
                        ),
                      ),

                      Text(
                        'Индекс EPA: $aqiIndex / 6',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),

                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.0,
              children: [
                _pollutantTile('PM2.5', '${pm25.toStringAsFixed(1)} µg/m³'),
                _pollutantTile('PM10', '${pm10.toStringAsFixed(1)} µg/m³'),
                _pollutantTile('CO', '${co.toStringAsFixed(1)} µg/m³'),
                _pollutantTile('NO₂', '${no2.toStringAsFixed(1)} µg/m³'),
                _pollutantTile('O₃', '${o3.toStringAsFixed(1)} µg/m³'),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _pollutantTile(String name, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            name,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0)),
          ),

          Text(
            value,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          
        ],
      ),
    );
  }
}