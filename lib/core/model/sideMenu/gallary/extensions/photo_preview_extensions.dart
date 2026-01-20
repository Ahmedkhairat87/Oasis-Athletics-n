import '../albumPhotos/PhotoData.dart';
import '../cartPhotos/CartPhotoData.dart';
import '../cartPhotos/PhotoPreviewModel.dart';

extension AlbumPreviewExt on PhotoData {
  PhotoPreviewVM get previewVM => PhotoPreviewVM(
    serNo: serNo!.toInt(),
    imageUrl: sphoto ?? '',
    btnTxt: btnTxt ?? 'Request this photo',
  );
}

extension CartPreviewExt on CartPhotoData {
  PhotoPreviewVM get previewVM => PhotoPreviewVM(
    serNo: serNo!.toInt(),
    photoSerNo: photoSerNo?.toInt(),
    imageUrl: sphoto ?? '',
    btnTxt: btnTxt ?? 'Cancel Request',
  );
}
