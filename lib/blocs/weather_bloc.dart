// weather_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '/services/weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherModel weatherModel;

  WeatherBloc(this.weatherModel) : super(WeatherInitial()) {
    on<FetchWeatherByLocation>(_onFetchWeatherByLocation);
    on<FetchWeatherByCity>(_onFetchWeatherByCity);
  }

  Future<void> _onFetchWeatherByLocation(
    FetchWeatherByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weatherData = await weatherModel.getLocationWeather();
      _emitWeatherLoaded(weatherData, emit);
    } catch (e) {
      emit(WeatherError('Failed to fetch weather data'));
    }
  }

  Future<void> _onFetchWeatherByCity(
    FetchWeatherByCity event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weatherData = await weatherModel.getCityWeather(event.cityName);
      _emitWeatherLoaded(weatherData, emit);
    } catch (e) {
      emit(WeatherError('Failed to fetch weather data'));
    }
  }

  void _emitWeatherLoaded(dynamic weatherData, Emitter<WeatherState> emit) {
    if (weatherData == null) {
      emit(WeatherError('Unable to get weather data'));
      return;
    }
    final double temp = weatherData['main']['temp'];
    final condition = weatherData['weather'][0]['id'];
    emit(WeatherLoaded(
      temperature: temp.toInt(),
      cityName: weatherData['name'],
      weatherIcon: weatherModel.getWeatherIcon(condition),
      weatherMessage: weatherModel.getMessage(temp.toInt()),
    ));
  }
}
