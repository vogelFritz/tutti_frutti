import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/models/sala.dart';

final salasProvider = StateProvider<List<Sala>>((_) => []);
