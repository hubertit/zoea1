import 'package:flutter/material.dart';
import 'package:zoea1/super_base.dart';
import 'constants/theme.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends Superbase<DeleteAccountDialog> {
  bool _loading = false;

  void deleteAccount() async {
    setState(() {
      _loading = true;
    });
    await ajax(
        url: "account/deleteAccount",
        method: "POST",
        onValue: (obj, url) {
          if (obj is Map && obj['code'] == 200) {
            logOut();
          }
        });
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Account"),
      content: _loading
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure , you want to delete your account forever ?",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
      actions: _loading
          ? null
          : [
              TextButton(onPressed: goBack, child: const Text("No")),
              TextButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  style: TextButton.styleFrom(foregroundColor: kGrayDark),
                  onPressed: deleteAccount,
                  label: const Text("Delete")),
            ],
    );
  }
}
