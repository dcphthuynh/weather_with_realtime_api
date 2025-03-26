import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_with_realtime_api/blocs/weather_bloc.dart';
import 'package:weather_with_realtime_api/blocs/weather_state.dart';
import '../blocs/weather_event.dart';
import 'location_screen.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dispatch event asynchronously to avoid build method issues
    Future.microtask(
        () => context.read<WeatherBloc>().add(FetchWeatherByLocation()));

    return Scaffold(
      body: Center(
        child: BlocListener<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoaded) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationScreen(),
                ),
              );
            }
          },
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
