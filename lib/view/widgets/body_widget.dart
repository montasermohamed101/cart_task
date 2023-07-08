import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {

  String? image;
  String? title;
  String? description;
  int? quantity;
  Widget? addIcon;
  Widget? removeIcon;

  BodyWidget(
      {
       required this.image,
        required this.title,
        required this.description,
        required this.quantity,
        required this.addIcon,
        required this.removeIcon,
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:Image.network(image!,height: 90,width: 90,),
      title: Text(title ?? ''),
      subtitle: Text(description ?? ''),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          addIcon!,
          Text('$quantity'),
          removeIcon!,
        ],
      ),
    );
  }
}
