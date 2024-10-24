import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mock_firebase_auth/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widget_key.dart';
import 'auth_providers.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    final auth = ref.watch(firebaseAuthProvider);
    return ProfileScreen(
      key: WidgetKey.profileScreen,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      providers: authProviders,
      auth: auth,
    );
  }
}
