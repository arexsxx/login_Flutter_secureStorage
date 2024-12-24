import 'package:vania/vania.dart';

class UserController extends Controller {
  Future<Response> index() async {
    Map? user = Auth().user();
    user?.remove('password');
    return Response.json(user);
  }
}

final UserController userController = UserController();
