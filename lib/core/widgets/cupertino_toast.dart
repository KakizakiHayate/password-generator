import 'dart:async';

import 'package:flutter/cupertino.dart';

/// Cupertino スタイルのトースト通知を表示する
///
/// Material の SnackBar に相当する簡易フィードバック。
/// 2秒後に自動で消える。
void showCupertinoToast(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _CupertinoToast(
      message: message,
      isError: isError,
      onDismiss: entry.remove,
    ),
  );

  overlay.insert(entry);
}

class _CupertinoToast extends StatefulWidget {
  const _CupertinoToast({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  @override
  State<_CupertinoToast> createState() => _CupertinoToastState();
}

class _CupertinoToastState extends State<_CupertinoToast> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 16,
      right: 16,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isError
                ? CupertinoColors.destructiveRed
                : CupertinoColors.activeGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
            child: Text(widget.message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
