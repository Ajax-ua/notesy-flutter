import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notesy_flutter/src/repos/app_repository.dart';

import '../../bloc/blocs.dart';
import '../../bloc/utils/request_status.dart';
import '../../shared/widgets/app_text_form_field.dart';
import '../../theme/app_typography.dart';

class Signup extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  final _authCubit = AuthCubit();
  final _appRepository = AppRepository();

  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Form (
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Signup', style: AppTypography.h3),
          const SizedBox(height: 10),

          AppTextFormField(
            controller: controllers['email']!,
            outline: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                return "Please enter a valid email address";
              }
              return null;
            },
            label: 'Email',
          ),
          const SizedBox(height: 10),

          AppTextFormField(
            controller: controllers['password']!,
            label: 'Password',
            obscureText: true,
            outline: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return "Please enter at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 15),

          Center(child: ElevatedButton(
            onPressed: () async {
              await _submit(context);
            },
            child: const Text('Submit'),
          )),
          const SizedBox(height: 10),

          Center(child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.zero,
            ),
            onPressed: () => context.go('/login'),
            child: const Text('Already have an account?'),
          )),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_form.currentState!.validate()) {
      return;
    }

    final data = controllers.map((key, value) => MapEntry(key, value.text));
    await _authCubit.signup(email: data['email']!, password: data['password']!);
    if (_authCubit.state.requestStatus == RequestStatus.succeed) {
      _appRepository.navigate('/');
    } else {
      _appRepository.showToastr(message: _authCubit.state.error!);
    }
  }
}