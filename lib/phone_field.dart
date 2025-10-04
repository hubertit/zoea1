import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'constants/theme.dart';

class PhoneField<T> extends StatelessWidget{
  final TextEditingController? controller;
  final Country country;
  final void Function(Country country) callback;
  final FormFieldValidator<String>? validator;

  const PhoneField({super.key, this.controller, required this.country, required this.callback, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: TextInputType.phone,
      cursorColor: kBlack,
      decoration: InputDecoration(
        prefixIcon: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 64),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                country.flagEmoji,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Flexible(
                child: Text(
                  " +${country.phoneCode}",
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        hintText: "Enter your phone number",
      ),
    );
  }

}