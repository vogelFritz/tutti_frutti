import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/models/user.dart';

final userProvider = StateProvider<User>((_) => User());
