import 'package:flutter/material.dart';
import 'vremeApi.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  String cityName = "Ptuj";
  Map<String, dynamic>? weeklyWeatherData;

  // Pridobivanje tedenskega vremena
  void getWeeklyWeather() async {
    try {
      final data = await weatherService.fetchWeeklyWeather(cityName);
      setState(() {
        weeklyWeatherData = data;
      });
    } catch (e) {
      print("Problem pri pridobivanju vremena: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getWeeklyWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vremenska napoved - Ptuj")),
      body: weeklyWeatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  final List<dynamic> filteredData = weeklyWeatherData!['list']
                      .where((item) =>
                          item['dt_txt'] != null &&
                          item['dt_txt'].contains('12:00:00'))
                      .toList();

                  if (index >= filteredData.length) {
                    return const SizedBox();
                  }

                  final dayData = filteredData[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        "Datum: ${dayData['dt_txt'].split(' ')[0]}",
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Temperatura: ${dayData['main']['temp']} °C"),
                          Text("Opis: ${dayData['weather'][0]['description']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
