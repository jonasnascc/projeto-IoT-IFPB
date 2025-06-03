import 'package:flutter/material.dart';

import '../../../core/core.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(bool) onVisibilityChanged;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.onVisibilityChanged,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.instance.screenHeight * 0.08,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: widget.controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          labelText: 'Senha',
          hintText: 'Senha',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(19),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(19),
          ),
          prefixIcon: const Icon(
            Icons.admin_panel_settings_outlined,
            color: Colors.white,
          ),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
              widget.onVisibilityChanged(_isPasswordVisible);
            },
            focusNode: FocusNode(skipTraversal: true),
            child: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
