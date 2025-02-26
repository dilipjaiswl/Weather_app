import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../secret.dart';
import '../weather_component/additional_info_item.dart';
import '../weather_component/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late double temp;           //late : you need to assign it before build fn called if you r using it

 // bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String,dynamic>> getCurrentWeather() async {
    print("api called");
    try {
      // setState(() {
      //   isLoading = true;
      // });
      String cityName = "London";
      final response = await http.get(Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=${OpenWeatherApiKey.forecast}'));
      // print(response.body);
      final data = jsonDecode(response.body);

      if (data["cod"] == '200') {
        // or
        // if(int.parse(data["cod"])==200)
        //  if(response.statusCode ==200)
        // {
        //   final Map<String,dynamic> data= jsonDecode(response.body);
        //   print(data["list"][0]["main"]["temp"]);

        // setState(() {
        //   temp = (data["list"][0]["main"]["temp"] - 273.15);
        //   isLoading = false;
        // });
        //temp = (data["list"][0]["main"]["temp"] - 273.15);
        return data ;
      } else {
        throw "Unexpected error";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build Called");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
              });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body:  FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          // print(snapshot);
          // print(snapshot.runtimeType);
          if(snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: const CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return Text(snapshot.hasError.toString());
          }
          final data =snapshot.data!;
          // Current Weather
          final currentWeatherData =data["list"][0];
          final currentTemp=currentWeatherData["main"]["temp"];
          final currentSky =currentWeatherData["weather"][0]["main"];

          //Additional Information
          final currentHumidity=currentWeatherData["main"]["humidity"];
          final currentWindSpeed =currentWeatherData["wind"]["speed"];
          final currentPressure =currentWeatherData["main"]["pressure"];


          return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(19)),

                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp°K',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 40, fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                 currentSky =="Clouds" || currentSky =="Clear" ?Icons.cloud:Icons.cloudy_snowing,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currentSky,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Whether Forecast
                    Text(
                      "Hourly ForeCast",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       for(int i=0; i<39; i++)
                    //       HourlyForecastItem(
                    //           time: data["list"][i+1]["dt"].toString(),
                    //           icon: data["list"][i+1]["weather"][0]["main"]=="Clouds" || data["list"][i+1]["weather"][0]["main"]=="Rain"? Icons.cloud:Icons.sunny,
                    //           temperature: data["list"][i+1]["main"]["temp"].toString(),
                    //       ),
                          // HourlyForecastItem(
                          //     time: "10:00",
                          //     icon: Icons.sunny,
                          //     temperature: "305.17"),
                          // HourlyForecastItem(
                          //     time: "11:00",
                          //     icon: Icons.cloud,
                          //     temperature: "307.18"),
                          // HourlyForecastItem(
                          //     time: "12:00",
                          //     icon: Icons.sunny,
                          //     temperature: "278.13"),
                          // HourlyForecastItem(
                          //     time: "01:00",
                          //     icon: Icons.cloud,
                          //     temperature: "307.13"),
                          // HourlyForecastItem(
                          //     time: "02:00",
                          //     icon: Icons.sunny_snowing,
                          //     temperature: "309.13"),
                        // ],
                   //   ),
                 //   ),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 39,
                          itemBuilder: (context,index){
                          final hourlyForecast =data["list"][index+1];
                          final hourlySky =data["list"][index+1]["weather"][0]["main"];
                          final hourlyTemperature =data["list"][index+1]["main"]["temp"];
                          final time =DateTime.parse(hourlyForecast["dt_txt"]);
                           return HourlyForecastItem(
                               time:DateFormat("j").format(time),
                               icon:hourlySky=="Clouds" || hourlySky=="Rain"? Icons.cloud:Icons.sunny,
                               temperature:hourlyTemperature.toString(),
                           );
                          }
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Additional Information
                    Text(
                      "Additional Information",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            value: currentHumidity.toString()),
                        AdditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            value: currentWindSpeed.toString(),
                        ),
                        AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: "Pressure",
                            value: currentPressure.toString()
                        )
                      ],
                    )
                  ],
                ),
              );
          },
      ),
    );
  }
}
