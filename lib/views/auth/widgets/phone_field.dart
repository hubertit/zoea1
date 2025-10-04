import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../constants/theme.dart';

class PhoneField<T> extends StatelessWidget {
  final TextEditingController? controller;
  final Country country;
  final void Function(Country country) callback;
  final FormFieldValidator<String>? validator;
  final bool enabled;

  const PhoneField({
    super.key,
    this.controller,
    required this.country,
    required this.callback,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF4D4D4D) : const Color(0xFFE0E0E0);
    
    return Row(
      children: [
        InkWell(
          onTap: enabled
              ? () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: true,
                    onSelect: callback,
                  );
                }
              : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF23242B) : Colors.white,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  country.flagEmoji,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '+${country.phoneCode}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: TextFormField(
            controller: controller,
            validator: validator,
            enabled: enabled,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              hintText: 'Enter your phone number',
              hintStyle: TextStyle(
                color: isDark ? const Color(0xFFB3B3B3) : const Color(0xFF616161),
              ),
              filled: true,
              fillColor: isDark ? const Color(0xFF23242B) : Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Theme.of(context).primaryColor : borderColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
