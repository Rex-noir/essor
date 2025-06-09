import 'package:flutter/material.dart';
import 'package:mobile/core/ui/widgets/app_text_field.dart';

class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final ValueChanged<String>? onChanged;

  const AppPasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.onChanged,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late final TextEditingController _internalController;
  bool _obscure = true;

  bool get _usingInternalController => widget.controller == null;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_usingInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: _internalController,
      label: widget.label,
      obscureText: _obscure,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
