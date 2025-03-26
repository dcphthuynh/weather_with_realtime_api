import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_with_realtime_api/blocs/weather_bloc.dart';
import 'package:weather_with_realtime_api/blocs/weather_event.dart';
import 'package:weather_with_realtime_api/blocs/weather_state.dart';
import '/screens/city_screen.dart';
import '/utilities/constants.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.read<WeatherBloc>().add(FetchWeatherByLocation());
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 40.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final typedText = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CityScreen()),
                      );
                      if (typedText != null) {
                        context
                            .read<WeatherBloc>()
                            .add(FetchWeatherByCity(typedText));
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is WeatherLoaded) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${state.temperature}°C',
                                style: kTempTextStyle,
                              ),
                              SizedBox(width: 20),
                              Text(
                                state.weatherIcon,
                                style: kConditionTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            '${state.weatherMessage} in ${state.cityName}',
                            textAlign: TextAlign.right,
                            style: kMessageTextStyle,
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is WeatherError) {
                    return Text(state.message);
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
