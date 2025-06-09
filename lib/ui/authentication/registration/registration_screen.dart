import 'package:flutter/material.dart';
import 'package:mobile/ui/core/widgets/app_text_field.dart';
import 'package:mobile/ui/core/widgets/logo_widget.dart';
import 'package:mobile/ui/authentication/login/login_screen.dart';
import 'package:mobile/ui/authentication/shared/widgets/app_password_field.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LogoWidget(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            48,
          ), // height of the bottom section
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.infinity,
            height: 48,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Register', style: textTheme.headlineLarge),
                const SizedBox(height: 12),
                Text(
                  'Please fill out the following form to register.',
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 32),
                Column(
                  spacing: 24,
                  children: [
                    AppTextField(label: 'Name'),
                    AppTextField(label: 'Email'),
                    AppPasswordField(label: 'Password'),
                    AppPasswordField(label: 'Confirm Password'),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    //TODO
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: colorScheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: colorScheme.onPrimary),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have account?",
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(
                        alpha: 0.8,
                      ), // Slightly muted theme color
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
