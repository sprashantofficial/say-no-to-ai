import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/local_stats_service.dart';
import '../../../shared/providers.dart';

class SubmissionScreen extends ConsumerStatefulWidget {
  const SubmissionScreen({super.key, required this.problemId});

  final String problemId;

  @override
  ConsumerState<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends ConsumerState<SubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _approachController = TextEditingController();
  final _edgeCasesController = TextEditingController();
  String? _dataStructure;
  String? _timeComplexity;

  static const _dsOptions = ['Array', 'HashMap', 'Stack', 'Queue', 'Tree', 'Graph', 'DP'];
  static const _tcOptions = ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)', 'O(n²)', 'O(2^n)'];

  @override
  void dispose() {
    _approachController.dispose();
    _edgeCasesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submission')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _approachController,
              minLines: 6,
              maxLines: 10,
              decoration: const InputDecoration(labelText: 'Approach'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Approach is required';
                if (value.trim().length < 20) return 'Approach must be at least 20 characters';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _dataStructure,
              items: _dsOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _dataStructure = value),
              validator: (value) => value == null ? 'Data Structure is required' : null,
              decoration: const InputDecoration(labelText: 'Data Structure'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _timeComplexity,
              items: _tcOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => _timeComplexity = value),
              validator: (value) => value == null ? 'Time Complexity is required' : null,
              decoration: const InputDecoration(labelText: 'Time Complexity'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _edgeCasesController,
              decoration: const InputDecoration(labelText: 'Edge Cases'),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Edge Cases are required' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                ref.read(submissionStateProvider.notifier).update((state) => {
                      ...state,
                      widget.problemId: {
                        'approach': _approachController.text.trim(),
                        'dataStructure': _dataStructure,
                        'timeComplexity': _timeComplexity,
                        'edgeCases': _edgeCasesController.text.trim(),
                        'hintsUsed': 0,
                      }
                    });
                await ref.read(localStatsServiceProvider).incrementAttemptAndUpdateStreak();
                if (!mounted) return;
                context.go('/problem/${widget.problemId}/reveal');
              },
              child: const Text('Submit and Reveal'),
            ),
          ],
        ),
      ),
    );
  }
}
