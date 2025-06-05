import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/core/widgets/app_text_field.dart';
import 'package:mobile/core/widgets/logo_widget.dart';
import 'package:mobile/features/authentication/presentation/registration/registration_screen.dart';
import 'package:mobile/features/authentication/presentation/shared/widgets/app_password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/images/particle_bg.svg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(
                      alpha: 0.4,
                    ), // Use theme surface color with transparency
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LogoWidget(),
                      SizedBox(height: 32),
                      Text(
                        'Login to your Account',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onSurface, // Use theme text color
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            "Don't have an account?",
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
                                  builder: (context) =>
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: colorScheme.secondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10, // Adjust vertical position from top
                  right: 10, // Adjust horizontal position from right
                  child: TextButton(
                    // Using TextButton for a subtle look
                    onPressed: () {
                      print('Skip button pressed!');
                      // Example: Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                      // );
                    },
                    child: Text(
                      'Skip',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface, // Or colorScheme.primary
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 24,
              thickness: 1,
              color: colorScheme.outline.withAlpha(70),
            ),
            Expanded(
              child: Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    AppTextField(label: 'Email'),
                    SizedBox(height: 32),
                    AppPasswordField(label: 'Password'),
                    SizedBox(height: 32),
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
                        'Login',
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      children: <Widget>[
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 24,
                              ),
                              minimumSize: const Size(0, 50),
                            ),
                            label: const Text('Google'),
                            icon: const FaIcon(FontAwesomeIcons.google),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          // Make the second button expand
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 24,
                              ),
                              minimumSize: const Size(0, 50),
                            ),
                            label: const Text('Facebook'),
                            icon: const FaIcon(FontAwesomeIcons.facebook),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: Text(
                '© 2025 Essor. All rights reserved.',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
