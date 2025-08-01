import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => weatherapi();
}

class weatherapi extends State<Weather> {
  final TextEditingController cityController = TextEditingController();
  Map<String, dynamic> weather = {};
  bool isLoading = false;


  Future<void> searchWeather() async {
    final city = cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=91bbbde36bb4a636b2160e9720498ff9",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        weather = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        weather = {};
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("City not found")),
      );
    }
  }


  String getTemperature() {
    try {
      final tempKelvin = weather["main"]["temp"];
      final tempCelsius = double.parse(tempKelvin.toString()) - 273.15;
      return "${tempCelsius.toStringAsFixed(2)} °C";
    } catch (e) {
      return "N/A";
    }
  }

  String getHumidity() {
    try {
      return "${weather["main"]["humidity"]} %";
    } catch (e) {
      return "N/A";
    }
  }

  String getPressure() {
    try {
      return "${weather["main"]["pressure"]} hPa";
    } catch (e) {
      return "N/A";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: const Text("MY WEATHER APP",style: TextStyle(fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.blue.shade50,
      ),
      body:Stack(
        fit: StackFit.expand,
        children: [

        Image.asset(
        "assets/rain.png"
      ,
        fit: BoxFit.cover,
      ),





            SingleChildScrollView(
              child: Column(
                children: [



                  TextFormField(
                    controller: cityController,
                    decoration:
                    const InputDecoration(
                      hintText: "Enter City Name",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: searchWeather,
                    child: const Text("Get Weather"),
                  ),
                  const SizedBox(height: 24),
                  if (isLoading) const CircularProgressIndicator(),
                  if (weather.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("City: ${weather["name"]}", style: const TextStyle(fontSize: 15,color: Colors.white)),
                        const SizedBox(height: 10),
                        Text("Temperature: ${getTemperature()}", style: const TextStyle(fontSize: 15,color: Colors.white)),
                        const SizedBox(height: 10),
                        Text("Humidity: ${getHumidity()}", style: const TextStyle(fontSize: 15,color: Colors.white)),
                        const SizedBox(height: 10),
                        Text("Pressure: ${getPressure()}", style: const TextStyle(fontSize: 15,color: Colors.white)),
                     Container(
                       height: 300,
                       width: 400,
                       decoration: BoxDecoration(
                         image: DecorationImage(image: AssetImage("assets/sun.png.png"))
                       ),
                     )
                      ],
                    ),
                ],

              ),
            ),


])
    );

  }
}