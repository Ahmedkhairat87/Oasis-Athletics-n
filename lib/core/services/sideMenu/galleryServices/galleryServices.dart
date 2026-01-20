import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utilities/apiResponseHelper.dart';
import '../../../apiControl/apiManager.dart';
import '../../../apiControl/apiServiceProvider.dart';
import '../../../model/sideMenu/gallary/AddPhotoToCartResponse.dart';
import '../../../model/sideMenu/gallary/RemovePhotoResponse.dart';
import '../../../model/sideMenu/gallary/albumPhotos/AlbumPhotosResponse.dart';
import '../../../model/sideMenu/gallary/albumPhotos/PhotoData.dart';
import '../../../model/sideMenu/gallary/albumsModels/AlbumsDataResponse.dart';
import '../../../model/sideMenu/gallary/cartPhotos/CartPhotosResponse.dart';

class GalleryService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<AlbumsDataResponse?> getAlbums() async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await APIServices().apiRequest(
      APIManager.getGalleryAlbums,
      {"token": token},
    );

    final json = ApiResponseHelper.normalize(response);
    return AlbumsDataResponse.fromJson(json);
  }

  /// =====================
  /// GET ALBUM PHOTOS
  /// =====================
  static Future<List<PhotoData>> getAlbumPhotos(int eventSer) async {
    final token = await _getToken();
    if (token == null) return [];

    final response = await APIServices().apiRequest(
      APIManager.getAlbumsPhotos,
      {"token": token, "eventSer": eventSer},
    );

    final json = ApiResponseHelper.normalize(response);
    return AlbumPhotosResponse.fromJson(json).data ?? [];
  }

  /// =====================
  /// REQUEST PHOTO
  /// =====================
  static Future<AddPhotoToCartResponse?> requestPhoto({
    required int photoSerNo,
  }) async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await APIServices().apiRequest(
      APIManager.requestNewPhoto,
      {"token": token, "photoSerNo": photoSerNo},
    );

    final json = ApiResponseHelper.normalize(response);
    return AddPhotoToCartResponse.fromJson(json);
  }

  /// ==========================
  /// GET CART + HISTORY
  /// ==========================
  static Future<CartPhotosResponse?> getCartPhotos() async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await APIServices().apiRequest(APIManager.getCartPhotos, {
      'token': token,
    });

    final json = ApiResponseHelper.normalize(response);
    return CartPhotosResponse.fromJson(json);
  }

  /// =====================
  /// CANCEL REQUEST
  /// =====================
  static Future<RemovePhotoResponse?> cancelPhoto({required int serNo}) async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await APIServices().apiRequest(
      APIManager.cancelrequestedPhoto,
      {"token": token, "serNo": serNo},
    );

    final json = ApiResponseHelper.normalize(response);
    return RemovePhotoResponse.fromJson(json);
  }
}
