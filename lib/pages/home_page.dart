import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather.dart';
import 'package:weather_app_tutorial/consts.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String _selectedCity = 'Riyadh';

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  final List<String> _cities = [
    'Riyadh',
    'Jeddah',
    'Mecca',
    'Medina',
    'Dammam',
    'Khobar',
    'Dhahran',
    'Tabuk',
    'Buraidah',
    'Khamis Mushait',
    'Abha',
    'Hofuf',
    'Al-Mubarraz',
    'Hail',
    'Najran',
    'Jubail',
    'Al-Kharj',
    'Yanbu',
    'Al Qatif',
    'Al Khafji',
    'Al Jubail',
    'Taif',
    'Qatif',
    'Al Bahah',
    'Arar',
    'Sakakah',
    'Jizan',
    'Rabigh',
    'Khafji',
    'Ras Tanura'
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() {
    setState(() {
      _weather = null;
    });
    _wf.currentWeatherByCityName(_selectedCity).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PrayerTimes()));
        },
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        tooltip: 'مواعيد الصلاة',
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        child: const Icon(Icons.mosque),
      ),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showCityDropdown();
            },
            icon: const Icon(Icons.location_city_rounded),
          ),
        ],
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(child: _buildUI()),
        ],
      ),
    );
  }

  void _showCityDropdown() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          content: _cityDropdown(),
        );
      },
    );
  }

  Widget _cityDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.deepPurpleAccent,
          iconEnabledColor: Colors.white,
          value: _selectedCity,
          items: _cities.map((String city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(
                city,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCity = newValue!;
              _fetchWeather();
            });
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return Center(
        child: Lottie.asset('assets/lottie/weather_animation.json'),
      );
    }
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.05,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.03,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PrayerTimes extends StatefulWidget {
  @override
  _PrayerTimesState createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  Map<String, String>? _prayerTimes;
  @override
  void initState() {
    super.initState();

    fetchPrayerTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_prayerTimes != null) _buildPrayerTimes(),
          _prayerTimes == null
              ? Center(
                  child: Lottie.asset('assets/lottie/weather_animation.json'),
                )
              : const SizedBox(height: 0, width: 0),
        ]),
      ),
    );
  }

  Future<void> fetchPrayerTimes() async {
    setState(() {
      _prayerTimes = null;
    });
    final response = await http.get(
      Uri.parse(
          'http://api.aladhan.com/v1/timingsByCity?city=$_selectedCity&country=Saudi Arabia&method=2'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _prayerTimes = {
          'Fajr': data['data']['timings']['Fajr'],
          'Dhuhr': data['data']['timings']['Dhuhr'],
          'Asr': data['data']['timings']['Asr'],
          'Maghrib': data['data']['timings']['Maghrib'],
          'Isha': data['data']['timings']['Isha'],
        };
      });
    } else {
      throw Exception('Failed to load prayer times');
    }
  }

  Widget _buildPrayerTimes() {
    return Column(
      children: _prayerTimes!.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }
}
