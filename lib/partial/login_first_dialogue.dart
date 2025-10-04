// import 'package:flutter/material.dart';
// import 'package:tarama/super_base.dart';
//
// class LoginFirstDialog extends StatefulWidget {
//   const LoginFirstDialog({super.key});
//
//   @override
//   State<LoginFirstDialog> createState() => _LoginFirstDialogState();
// }
//
// class _LoginFirstDialogState extends Superbase<LoginFirstDialog> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Delete Account"),
//       content:const Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(40.0),
//             child: Center(
//               child: CircularProgressIndicator(),
//             ),
//           )
//         ],
//       )
//           : Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Are you sure , you want to delete your account forever ?",
//             style: Theme.of(context).textTheme.bodyMedium,
//           )
//         ],
//       ),
//       actions: _loading
//           ? null
//           : [
//         TextButton(onPressed: goBack, child: const Text("No")),
//         TextButton.icon(
//             icon: const Icon(Icons.delete_forever),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             onPressed: deleteAccount,
//             label: const Text("Delete")),
//       ],
//     );
//   }
// }
