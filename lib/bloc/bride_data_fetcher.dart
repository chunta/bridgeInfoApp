import 'dart:convert';
import 'package:bridge_info/model/bridge.dart';
import 'package:bridge_info/model/foot_bridge.dart';
import 'package:bridge_info/utility/model_unifier.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_http_cache_fix/dio_http_cache.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

/// An abstract class defining the interface for fetching bridge data.
///
/// This class serves as a contract for any implementation that provides data
/// about footbridges and bridges. Implementations should provide the actual
/// logic for fetching this data from a data source.
abstract class IBridgeDataFetcher {
  /// Fetches a list of footbridges.
  ///
  /// Returns a [Future] that resolves to a [List] of [Footbridge] objects.
  /// If there is no data or an error occurs, it may return `null`.
  Future<List<Footbridge>?> getFootbridges();

  /// Fetches a list of bridges.
  ///
  /// Returns a [Future] that resolves to a [List] of [Bridge] objects.
  /// If there is no data or an error occurs, it may return `null`.
  Future<List<Bridge>?> getBridges();
}

class BridgeDataFetcher implements IBridgeDataFetcher {
  static const int _retryCount = 3;
  static const Duration _cacheDuration = Duration(seconds: 30);
  static const Duration _firstRetryDelay = Duration(seconds: 1);
  static const Duration _secondRetryDelay = Duration(seconds: 2);
  static const Duration _thirdRetryDelay = Duration(seconds: 3);
  static const List<Duration> _retryDelays = [
    _firstRetryDelay,
    _secondRetryDelay,
    _thirdRetryDelay,
  ];

  final Dio _dio = Dio();
  final Logger _logger = Logger(printer: PrettyPrinter());

  BridgeDataFetcher() {
    _dio.httpClientAdapter = NativeAdapter(
        createCupertinoConfiguration: () =>
            URLSessionConfiguration.ephemeralSessionConfiguration());
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: print,
        retries: _retryCount,
        retryDelays: _retryDelays,
      ),
    );

    _dio.interceptors.add(DioCacheManager(CacheConfig(baseUrl: "http://tpnco.blob.core.windows.net")).interceptor);
  }

  @override
  Future<List<Bridge>?> getBridges() async {
    try {
      final response = await _dio.get(
          'https://tpnco.blob.core.windows.net/blobfs/Bridges.json',
          options: buildCacheOptions(_cacheDuration));
      _logger.i("code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 304) {
        _logger.d("Bridges data fetched successfully");
        if (response.data is String) {
          try {
            String formattedData =
                ModelUnifier.formatString(response.data as String);
            List<dynamic> data = jsonDecode(formattedData);
            List<Bridge> bridges =
                data.map((data) => Bridge.fromJson(data)).toList();
            return bridges;
          } catch (jsonError) {
            _logger.e("Failed to decode JSON: $jsonError");
            return null;
          }
        } else {
          _logger.e("Response data is not a string");
          return null;
        }
      } else {
        _logger.e("Failed to fetch bridges data: ${response.statusCode}");
        _handleError(response);
        return null;
      }
    } on DioException catch (e) {
      _handleException(e);
      return null;
    } catch (e) {
      _logger.e("Unexpected error occurred: $e");
      return null;
    }
  }

  @override
  Future<List<Footbridge>?> getFootbridges() async {
    try {
      final response = await _dio.get(
          'https://tpnco.blob.core.windows.net/blobfs/Footbridges.json',
          options: buildCacheOptions(_cacheDuration));
      if (response.statusCode == 200 || response.statusCode == 304) {
        _logger.d("Footbridges data fetched successfully");
        if (response.data is String) {
          try {
            String formattedData =
                ModelUnifier.formatString(response.data as String);
            List<dynamic> data = jsonDecode(formattedData);
            List<Footbridge> footbridges =
                data.map((data) => Footbridge.fromJson(data)).toList();
            return footbridges;
          } catch (jsonError) {
            _logger.e("Failed to decode JSON: $jsonError");
            return null;
          }
        } else {
          _logger.e("Response data is not a string");
          return null;
        }
      } else {
        _logger.e("Failed to fetch footbridges data: ${response.statusCode}");
        _handleError(response);
        return null;
      }
    } on DioException catch (e) {
      _handleException(e);
      return null;
    } catch (e) {
      _logger.e("Unexpected error occurred: $e");
      return null;
    }
  }

  void _handleError(Response response) {
    switch (response.statusCode) {
      case 400:
        _logger.e("Bad request. Please check the input.");
        break;
      case 401:
        _logger.e("Unauthorized. Please check your credentials.");
        break;
      case 404:
        _logger.e("Bridge not found. Please check the bridge ID.");
        break;
      case 500:
        _logger.e("Internal server error. Please try again later.");
        break;
      default:
        _logger.e("Unexpected error: ${response.statusCode}");
        break;
    }
  }

  void _handleException(Exception e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout) {
        _logger.e("Connection timed out. Please try again later.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        _logger.e("Receive timed out. Please try again later.");
      } else if (e.type == DioExceptionType.badResponse) {
        _logger.e("Received invalid status code: ${e.response?.statusCode}");
      } else {
        _logger.e("Unexpected error: $e");
      }
    } else {
      _logger.e("Unexpected error: $e");
    }
  }
}
