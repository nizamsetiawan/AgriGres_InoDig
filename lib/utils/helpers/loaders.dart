import 'package:agrigres/utils/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:agrigres/utils/constraints/colors.dart';
import 'package:agrigres/utils/helpers/helper_functions.dart';

class TLoaders {
  static hideSnackBar() {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
    }
  }

  /// Safely close GetX snackbar if it exists
  static void closeGetSnackbar() {
    try {
      // Check if snackbar is actually open before trying to close
      if (Get.isSnackbarOpen == true) {
        try {
          Get.closeCurrentSnackbar();
        } catch (e) {
          // Controller might not be initialized if we used ScaffoldMessenger
          // This is safe to ignore - the exception is caught and handled
          TLoggerHelper.debug('GetX snackbar controller not initialized, likely using ScaffoldMessenger: $e');
        }
      }
    } catch (e) {
      // Ignore error if snackbar is not open or controller not initialized
      TLoggerHelper.debug('No snackbar to close or controller not initialized: $e');
    }
  }
  
  /// Close both GetX snackbar and ScaffoldMessenger snackbar
  static void closeAllSnackbars() {
    // Close GetX snackbar
    closeGetSnackbar();
    
    // Close ScaffoldMessenger snackbar
    try {
      final context = Get.context;
      if (context != null) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e) {
      // Ignore if context is not available
      TLoggerHelper.debug('Could not close ScaffoldMessenger snackbar: $e');
    }
  }
  
  /// Safely navigate back without causing snackbar errors
  static void safeBack({bool closeOverlays = false}) {
    // Close snackbars first
    closeAllSnackbars();
    
    // Small delay to ensure snackbars are closed
    Future.delayed(const Duration(milliseconds: 50), () {
      try {
        Get.back(closeOverlays: closeOverlays);
      } catch (e) {
        TLoggerHelper.error('Error during safe back navigation', e);
        // Fallback to regular back if Get.back fails
        try {
          Get.back();
        } catch (_) {
          // Ignore if it still fails
        }
      }
    });
  }

  static customToast({required message}) {
    if (Get.context == null) {
      TLoggerHelper.debug('Context is null, cannot show toast: $message');
      return;
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          elevation: 0,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: THelperFunctions.isDarkMode(Get.context!) ? TColors.darkerGrey.withOpacity(0.9) : TColors.grey.withOpacity(0.9),
          ),
          child: Center(child: Text(message, style: Theme.of(Get.context!).textTheme.labelLarge)),
        )
        )
    );
    TLoggerHelper.debug(message);
  }

  static successSnackBar({required title, message = '', duration = 3}) {
    // Always use addPostFrameCallback to ensure overlay is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add small delay to ensure overlay is fully initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessSnackBar(title, message, duration);
      });
    });
  }

  static void _showSuccessSnackBar(String title, String message, int duration) {
    // Always use root context to ensure snackbar appears even from dialogs/bottom sheets
    final rootContext = Get.key.currentContext ?? Get.context;
    
    if (rootContext == null) {
      TLoggerHelper.debug('Context not available, cannot show snackbar: $title - $message');
      return;
    }
    
    // Always use ScaffoldMessenger to avoid GetX snackbar controller issues
    // Use root context to ensure snackbar appears even when called from dialogs/bottom sheets
    try {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.check, color: TColors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: TColors.success,
          duration: Duration(seconds: duration),
          margin: const EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
        ),
      );
      TLoggerHelper.debug('Success snackbar shown via ScaffoldMessenger: $title - $message');
    } catch (e) {
      TLoggerHelper.error('Failed to show snackbar via ScaffoldMessenger', e);
    }
  }

  static warningSnackBar({required title,message = ''}) {
    // Always use addPostFrameCallback to ensure overlay is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add small delay to ensure overlay is fully initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        _showWarningSnackBar(title, message);
      });
    });
  }

  static void _showWarningSnackBar(String title, String message) {
    // Always use root context to ensure snackbar appears even from dialogs/bottom sheets
    final rootContext = Get.key.currentContext ?? Get.context;
    
    if (rootContext == null) {
      TLoggerHelper.debug('Context not available, cannot show snackbar: $title - $message');
      return;
    }
    
    // Always use ScaffoldMessenger to avoid GetX snackbar controller issues
    // Use root context to ensure snackbar appears even when called from dialogs/bottom sheets
    try {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.warning_2, color: TColors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: TColors.info,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        ),
      );
      TLoggerHelper.debug('Warning snackbar shown via ScaffoldMessenger: $title - $message');
    } catch (e) {
      TLoggerHelper.error('Failed to show snackbar vi ScafoldMessenger', e);
    }
  }

  static errorSnackBar({required title,message = ''}) {
    // Always use addPostFrameCallback to ensure overlay is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add small delay to ensure overlay is fully initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        _showErrorSnackBar(title, message);
      });
    });
  }

  static void _showErrorSnackBar(String title, String message) {
    // Always use root context to ensure snackbar appears even from dialogs/bottom sheets
    final rootContext = Get.key.currentContext ?? Get.context;
    
    if (rootContext == null) {
      TLoggerHelper.debug('Context not available, cannot show snackbar: $title - $message');
      return;
    }
    
    // Always use ScaffoldMessenger to avoid GetX snackbar controller issues
    // Use root context to ensure snackbar appears even when called from dialogs/bottom sheets
    try {
      ScaffoldMessenger.of(rootContext).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Iconsax.warning_2, color: TColors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: TColors.error,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
        ),
      );
      TLoggerHelper.debug('Error snackbar shown via ScaffoldMessenger: $title - $message');
    } catch (e) {
      TLoggerHelper.error('Failed to show snackbar via ScaffoldMessenger', e);
    }
  }
}