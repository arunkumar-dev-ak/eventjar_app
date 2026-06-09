import 'package:dio/dio.dart';
import 'package:eventjar/api/dio_client.dart';
import 'package:eventjar/global/store/user_store.dart';
import 'package:eventjar/model/google_calendar/google_calendar_connect_model.dart';
import 'package:eventjar/model/google_calendar/google_calendar_status_model.dart';
import 'package:eventjar/routes/route_name.dart';

import 'package:get/get.dart';

class GoogleCalendarApi {
  static final Dio _dio = DioClient().dio;

  static Future<GoogleCalendarStatusModel> getConnectionStatus() async {
    try {
      final response = await _dio.get('/google-calendar/status');

      if (response.statusCode == 200) {
        return GoogleCalendarStatusModel.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();

        Get.toNamed(RouteName.signInPage);
      }

      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<GoogleCalendarConnectModel> getConnectUrl() async {
    try {
      final response = await _dio.get('/google-calendar/mobile/connect');

      if (response.statusCode == 200) {
        return GoogleCalendarConnectModel.fromJson(response.data);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();

        Get.toNamed(RouteName.signInPage);
      }

      rethrow;
    } catch (err) {
      rethrow;
    }
  }

  static Future<void> disconnect() async {
    try {
      final response = await _dio.delete('/google-calendar/disconnect');

      if (response.statusCode == 200) {
        return;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: "something_went_wrong".tr,
      );
    } on DioException catch (err) {
      if (err.response?.statusCode == 401) {
        await UserStore.to.clearStore();

        Get.toNamed(RouteName.signInPage);
      }

      rethrow;
    } catch (err) {
      rethrow;
    }
  }
}
