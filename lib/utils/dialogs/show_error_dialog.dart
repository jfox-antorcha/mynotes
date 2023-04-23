import 'package:flutter/material.dart';
import 'package:mynotes/utils/dialogs/generic_dialog.dart';

Future<void> showErrorMessage(
  BuildContext context,
  String message,
) {
  return genericDialog(
      context: context,
      title: 'An error occurred',
      content: message,
      optionsBuilder: () => {'OK': null});
}
