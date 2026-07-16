import 'dart:async';

import 'package:flutter/material.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key});

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  final List<_CookingTimer> _timers = [];
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) => _tick());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _tick() {
    var changed = false;
    final now = DateTime.now();

    for (final timer in _timers.where((timer) => timer.isRunning)) {
      final milliseconds = timer.endsAt!.difference(now).inMilliseconds;
      final seconds = milliseconds <= 0 ? 0 : (milliseconds / 1000).ceil();
      final remaining = Duration(seconds: seconds);

      if (timer.remaining != remaining) {
        timer.remaining = remaining;
        changed = true;
      }

      if (seconds == 0) {
        timer.endsAt = null;
        changed = true;
      }
    }

    if (changed && mounted) {
      setState(() {});
    }
  }

  Future<void> _showAddTimerDialog() async {
    final nameController = TextEditingController();
    final minutesController = TextEditingController();
    final secondsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final timer = await showDialog<_CookingTimer>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Timer'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g. Pasta',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minutesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Minutes'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: secondsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Seconds'),
                        validator: (_) {
                          final minutes =
                              int.tryParse(minutesController.text) ?? 0;
                          final seconds =
                              int.tryParse(secondsController.text) ?? 0;
                          if (minutes < 0 || seconds < 0 || seconds > 59) {
                            return 'Use 0–59';
                          }
                          if (minutes == 0 && seconds == 0) {
                            return 'Add time';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                final minutes = int.tryParse(minutesController.text) ?? 0;
                final seconds = int.tryParse(secondsController.text) ?? 0;
                final duration = Duration(minutes: minutes, seconds: seconds);
                Navigator.pop(
                  context,
                  _CookingTimer(
                    name: nameController.text.trim().isEmpty
                        ? 'Timer ${_timers.length + 1}'
                        : nameController.text.trim(),
                    duration: duration,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (timer != null && mounted) {
      setState(() {
        _timers.add(timer);
      });
    }

    // Let the dialog's closing animation release its text fields first.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    nameController.dispose();
    minutesController.dispose();
    secondsController.dispose();
  }

  void _toggleTimer(_CookingTimer timer) {
    setState(() {
      if (timer.isRunning) {
        timer.endsAt = null;
      } else {
        if (timer.remaining == Duration.zero) {
          timer.remaining = timer.duration;
        }
        timer.endsAt = DateTime.now().add(timer.remaining);
      }
    });
  }

  void _resetTimer(_CookingTimer timer) {
    setState(() {
      timer.remaining = timer.duration;
      if (timer.isRunning) {
        timer.endsAt = DateTime.now().add(timer.duration);
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final minuteText = minutes.toString().padLeft(2, '0');
    final secondText = seconds.toString().padLeft(2, '0');
    return hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minuteText:$secondText'
        : '$minuteText:$secondText';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text(
          'Timers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 106, 23),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTimerDialog,
        tooltip: 'Add timer',
        backgroundColor: const Color.fromARGB(255, 5, 106, 23),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: _timers.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 64,
                      color: Color(0xFF056A17),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No timers yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap + to create a cooking timer.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: _timers.length,
              itemBuilder: (context, index) {
                final timer = _timers[index];
                final isFinished = timer.remaining == Duration.zero;

                return Card(
                  color: const Color(0xFFFDF6EC),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                timer.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  setState(() => _timers.remove(timer)),
                              tooltip: 'Delete ${timer.name}',
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                        Text(
                          _formatDuration(timer.remaining),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: isFinished
                                ? Theme.of(context).colorScheme.error
                                : const Color(0xFF03390D),
                          ),
                        ),
                        if (isFinished)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text('Time is up!'),
                          ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: () => _toggleTimer(timer),
                              icon: Icon(
                                timer.isRunning
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              label: Text(timer.isRunning ? 'Pause' : 'Start'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _resetTimer(timer),
                              icon: const Icon(Icons.replay),
                              label: const Text('Reset'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _CookingTimer {
  final String name;
  final Duration duration;
  Duration remaining;
  DateTime? endsAt;

  _CookingTimer({required this.name, required this.duration})
    : remaining = duration;

  bool get isRunning => endsAt != null;
}
