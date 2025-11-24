import 'package:copaw/utils/app_colors.dart';
import 'package:copaw/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static bool _isLoadingVisible = false;
  static bool get isLoadingVisible => _isLoadingVisible;

  /// Shows a loading dialog with a circular progress indicator and a loading text.
  /// The dialog is not dismissible by tapping outside.
  static void showLoading({
    required BuildContext context,
    required String loadingText,
  }) {
    if (_isLoadingVisible) {
      hideLoading(context: context);
    }
    _isLoadingVisible = true;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: AppColors.mainColor),
            SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  loadingText,
                  style: AppStyles.medium16Black,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    ).then((_) => _isLoadingVisible = false);
  }

  /// Hides the currently displayed loading dialog.
  /// It is assumed that a loading dialog is currently being shown.
  static void hideLoading({required BuildContext context}) {
    hideLoadingIfVisible(context: context);
  }

  static void hideLoadingIfVisible({required BuildContext context}) {
    if (!_isLoadingVisible) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    _isLoadingVisible = false;
  }

  static void hideLoadingWithNavigator(NavigatorState navigator) {
    if (!_isLoadingVisible) return;
    if (navigator.canPop()) {
      navigator.pop();
    }
    _isLoadingVisible = false;
  }

  /// Shows a message dialog with a title, message, and optional positive and negative actions.
  /// The dialog can be dismissed by tapping outside if `barrierDismissible` is true
  static void showMessage({
    required BuildContext context,
    required String message,
    String? title,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
    bool barrierDismissible = true,
  }) {
    List<Widget> actions = [];

    if (posActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            posAction?.call();
          },
          child: Text(posActionName, style: AppStyles.medium16Primary),
        ),
      );

      if (negActionName != null) {
        actions.add(
          TextButton(
            onPressed: () {
              negAction?.call();
              Navigator.pop(context);
            },
            child: Text(negActionName, style: AppStyles.medium16Primary),
          ),
        );
      }
    }
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message, style: AppStyles.medium16Black),
        title: Text(title ?? "", style: AppStyles.bold20Black),
        actions: actions,
      ),
    );
  }
}
