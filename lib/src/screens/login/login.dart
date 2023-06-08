import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../bloc/blocs.dart';
import '../../bloc/utils/request_status.dart';
import '../../repos/repos.dart';
import '../../shared/widgets/app_text_form_field.dart';
import '../../theme/app_typography.dart';

class Login extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };
  final _authCubit = AuthCubit();
  final _appRepository = AppRepository();
  final _routerRepository = RouterRepository();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Form (
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Login', style: AppTypography.h3),
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
            onPressed: () => context.go('/signup'),
            child: const Text('Don\'t have an account?'),
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
    await _authCubit.login(email: data['email']!, password: data['password']!);
    if (_authCubit.state.requestStatus == RequestStatus.succeed) {
      _routerRepository.navigate('/');
    } else {
      _appRepository.showToastr(message: _authCubit.state.error!);
    }
  }
}