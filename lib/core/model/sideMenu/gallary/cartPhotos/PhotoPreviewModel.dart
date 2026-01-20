class PhotoPreviewVM {
  final int serNo;
  final int? photoSerNo; // used ONLY in cart cancel
  final String imageUrl;
  final String btnTxt;

  const PhotoPreviewVM({
    required this.serNo,
    required this.imageUrl,
    required this.btnTxt,
    this.photoSerNo,
  });

  bool get isRequested =>
      btnTxt.toLowerCase().contains('request') ||
      btnTxt.toLowerCase().contains('requested');

  bool get canCancel => btnTxt.toLowerCase().contains('cancel');
}
