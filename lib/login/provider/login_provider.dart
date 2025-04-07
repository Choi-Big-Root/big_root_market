import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserCredential?>((ref) => null);
