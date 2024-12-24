import 'package:auth/app/http/controllers/auth_controller.dart';
import 'package:auth/app/http/controllers/user_controller.dart';
import 'package:auth/app/http/middleware/authenticate.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.group(() {
      Router.get('me', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);
  }
}
