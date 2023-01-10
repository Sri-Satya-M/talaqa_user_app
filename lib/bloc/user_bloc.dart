import 'package:alsan_app/repository/user_repo.dart';
import 'package:flutter/cupertino.dart';

class UserBloc with ChangeNotifier {
  final _userRepo = UserRepo();

  String username='';

  Future sendOTP({body}) {
    return _userRepo.sendOTP(body: body);
  }

  Future verifyOTP({body}) {
    return _userRepo.verifyOTP(body: body);
  }

}
