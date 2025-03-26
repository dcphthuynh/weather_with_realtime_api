// weather_state.dart
import 'package:equatable/equatable.dart';

class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final int temperature;
  final String cityName;
  final String weatherIcon;
  final String weatherMessage;

  const WeatherLoaded({
    required this.temperature,
    required this.cityName,
    required this.weatherIcon,
    required this.weatherMessage,
  });

  @override
  List<Object> get props =>
      [temperature, cityName, weatherIcon, weatherMessage];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
