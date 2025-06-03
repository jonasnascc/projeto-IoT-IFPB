import 'package:flutter/material.dart';

import '../../../core/core.dart';

class CpfFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CpfFormField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<CpfFormField> createState() => _CpfFormFieldState();
}

class _CpfFormFieldState extends State<CpfFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.instance.screenHeight * 0.08,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: widget.controller,
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.white),
          labelText: 'CPF',
          hintText: 'CPF',
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
            Icons.person,
            color: Colors.white,
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    widget.controller.clear();
                  },
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                    size: 22,
                  ),
                )
              : null,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [Masks.instance.cpfMask],
      ),
    );
  }
}
