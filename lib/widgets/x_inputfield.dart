import 'package:asteron_x/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType; // Optional keyboard type
  final int? maxLength; // Optional maximum input length
  final Icon? prefixIcon; // Optional prefix icon
  final Widget?
      suffixIcon; // Optional suffix icon (for example, for obscure text)

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.keyboardType,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    var inputFormatters = <TextInputFormatter>[
      FilteringTextInputFormatter.singleLineFormatter,
    ];

    // Handle specific number input
    if (keyboardType == TextInputType.number) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (keyboardType == TextInputType.text) {
      // Optional: You can add more specific input formatters for alphanumeric input
    }

    return SizedBox(
      height: 55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          maxLength: maxLength, // Apply maxLength if specified
          cursorColor: textPrimaryColor,
          maxLengthEnforcement: maxLength != null
              ? MaxLengthEnforcement.enforced
              : MaxLengthEnforcement.none, // Enforce maxLength if set
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: secondaryColor, // Change fill color to match background
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            prefixIcon: prefixIcon ?? null, // Optional prefix icon
            suffixIcon: suffixIcon ??
                null, // Optional suffix icon (e.g., eye icon for obscureText)
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(18.0), // Adjusted to match your design
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: keyboardType ??
              TextInputType
                  .text, // Default to TextInputType.text if not provided
          inputFormatters: inputFormatters, // Apply input formatters
        ),
      ),
    );
  }
}
