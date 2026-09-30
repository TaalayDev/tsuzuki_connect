import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum GameNotificationType { info, success, warning, error }

void showGameNotification(
  BuildContext context, {
  required String message,
  GameNotificationType type = GameNotificationType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  _GameNotificationManager.show(context, message: message, type: type, duration: duration);
}

class _NotificationData {
  const _NotificationData({required this.id, required this.message, required this.type, required this.duration});

  final int id;
  final String message;
  final GameNotificationType type;
  final Duration duration;
}

class _GameNotificationManager {
  static final List<_NotificationData> _notifications = [];
  static OverlayEntry? _entry;
  static OverlayState? _overlay;
  static int _nextId = 0;

  static void show(
    BuildContext context, {
    required String message,
    required GameNotificationType type,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    if (_overlay != null && _overlay != overlay) {
      _entry?.remove();
      _entry = null;
      _notifications.clear();
    }
    _overlay = overlay;

    _notifications.insert(0, _NotificationData(id: _nextId++, message: message, type: type, duration: duration));
    if (_notifications.length > 3) {
      _notifications.removeRange(3, _notifications.length);
    }

    _entry ??= OverlayEntry(
      builder: (context) => _NotificationStack(notifications: List.unmodifiable(_notifications), onDismiss: _remove),
    );
    if (!_entry!.mounted) overlay.insert(_entry!);
    _entry!.markNeedsBuild();
  }

  static void _remove(int id) {
    _notifications.removeWhere((notification) => notification.id == id);
    if (_notifications.isEmpty) {
      _entry?.remove();
      _entry = null;
      _overlay = null;
    } else {
      _entry?.markNeedsBuild();
    }
  }
}

class _NotificationStack extends StatelessWidget {
  const _NotificationStack({required this.notifications, required this.onDismiss});

  final List<_NotificationData> notifications;
  final ValueChanged<int> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 14, right: 14, left: 14),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width < 420 ? 330 : 380),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final notification in notifications)
                Padding(
                  key: ValueKey(notification.id),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _NotificationCard(notification: notification, onDismiss: () => onDismiss(notification.id)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  const _NotificationCard({required this.notification, required this.onDismiss});

  final _NotificationData notification;
  final VoidCallback onDismiss;

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  Timer? _timer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 190),
    );
    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.22, -0.12), end: Offset.zero).animate(curve);
    _controller.forward();
    _timer = Timer(widget.notification.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    _timer?.cancel();
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _NotificationStyle.forType(widget.notification.type);
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: Semantics(
          liveRegion: true,
          label: widget.notification.message,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 11, 8, 11),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: style.color.withValues(alpha: 0.28)),
                boxShadow: AppShadows.glass,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [style.color.withValues(alpha: 0.28), style.color.withValues(alpha: 0.11)],
                      ),
                    ),
                    child: Icon(style.icon, size: 21, color: style.color),
                  ),
                  const SizedBox(width: 11),
                  Flexible(
                    child: Text(
                      widget.notification.message,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.japaneseFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brownDark,
                      ).copyWith(height: 1.25),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: _dismiss,
                    icon: Icon(Icons.close_rounded, size: 18, color: AppColors.brownDark.withValues(alpha: 0.55)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationStyle {
  const _NotificationStyle(this.color, this.icon);

  final Color color;
  final IconData icon;

  static _NotificationStyle forType(GameNotificationType type) => switch (type) {
    GameNotificationType.info => const _NotificationStyle(AppColors.purple, Icons.info_outline_rounded),
    GameNotificationType.success => const _NotificationStyle(AppColors.greenDark, Icons.check_rounded),
    GameNotificationType.warning => const _NotificationStyle(AppColors.orange, Icons.priority_high_rounded),
    GameNotificationType.error => const _NotificationStyle(Color(0xFFC65C67), Icons.error_outline_rounded),
  };
}
