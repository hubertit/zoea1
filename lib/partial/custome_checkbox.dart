import 'package:flutter/material.dart';

class CustomRadio extends StatelessWidget{
  final String title;
  final String value;
  final String? groupValue;
  final Function(String? value)? onCheck;
  const CustomRadio({super.key, required this.title,required this.value, this.groupValue, this.onCheck});

  @override
  Widget build(BuildContext context) {

    var checked = value == groupValue;
    var color = checked ? Theme.of(context).primaryColor : Colors.grey.shade400;
    return Material(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: color
        )
    ),
      child: InkWell(
        onTap: (){
          onCheck?.call(value);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color
                  ),
                  color: checked ? color : null,
                  shape: BoxShape.circle
                ),
                child: checked ? const Icon(Icons.check,color: Colors.white,size: 19,) : null,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(title,style: const TextStyle(
                  fontWeight: FontWeight.w600
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}