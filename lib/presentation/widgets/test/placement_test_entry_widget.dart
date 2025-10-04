import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuzuki_connect/core/utils/extensions.dart';
import 'package:tsuzuki_connect/providers/sound_controller.dart';

/// Widget that shows the placement test option
/// Can be added to home screen, settings, or first-time user flow
class PlacementTestEntryWidget extends ConsumerWidget {
  final bool isCompact;

  const PlacementTestEntryWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCompact) {
      return _buildCompactCard(context, ref);
    }
    return _buildFullCard(context, ref);
  }

  Widget _buildFullCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToTest(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: context.theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Placement Test',
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'プレースメントテスト',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Take a quick test with Tanaka-sensei to determine your Japanese language level. This helps us customize your learning experience!',
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '5-10 minutes',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.quiz,
                    size: 16,
                    color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '10 questions',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.2,
          end: 0,
          duration: 400.ms,
        );
  }

  Widget _buildCompactCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.assignment,
            color: context.theme.colorScheme.primary,
          ),
        ),
        title: const Text('Placement Test'),
        subtitle: const Text('Determine your Japanese level'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _navigateToTest(context, ref),
      ),
    );
  }

  void _navigateToTest(BuildContext context, WidgetRef ref) {
    ref.read(soundControllerProvider.notifier).playClick();
    context.push('/placement-test');
  }
}

/// Dialog to show before starting the placement test
class PlacementTestDialog extends ConsumerWidget {
  const PlacementTestDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.assignment,
            color: context.theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Placement Test'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanaka-sensei will guide you through a quick assessment to determine your Japanese language level.',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            context,
            Icons.schedule,
            'Duration',
            '5-10 minutes',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.quiz,
            'Questions',
            '10 adaptive questions',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            context,
            Icons.language,
            'Levels',
            'JLPT N5 to N1',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: context.theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Don\'t worry if some questions seem difficult. We use this to find your perfect starting point!',
                    style: context.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(soundControllerProvider.notifier).playClick();
            Navigator.pop(context, false);
          },
          child: const Text('Maybe Later'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(soundControllerProvider.notifier).playClick();
            Navigator.pop(context, true);
          },
          child: const Text('Start Test'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Helper function to show placement test dialog
Future<void> showPlacementTestDialog(BuildContext context, WidgetRef ref) async {
  final shouldStart = await showDialog<bool>(
    context: context,
    builder: (context) => const PlacementTestDialog(),
  );

  if (shouldStart == true && context.mounted) {
    context.push('/placement-test');
  }
}
