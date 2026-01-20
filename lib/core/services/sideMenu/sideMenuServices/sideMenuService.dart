// class SideMenuService {
//   static Future<List<Menu>> getSideMenu({
//     required String token,
//     required String categoryId,
//   }) async {
//     final params = {
//       "token": token,
//       "CategoryId": categoryId,
//     };
//
//     final response = await APIServices().apiRequest(APIManager.menuList, params);
//
//     // تأكد إن فيه key اسمه "sideMenu" ورجعه List
//     final sideMenuJson = response["sideMenu"] as List<dynamic>? ?? [];
//
//     final sideMenuList = sideMenuJson
//         .map((menuJson) => Menu.fromJson(menuJson["Menu"]))
//         .toList();
//
//     return sideMenuList;
//   }
// }
