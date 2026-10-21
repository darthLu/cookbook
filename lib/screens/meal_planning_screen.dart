import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/meal_plan_service.dart';
import '../services/recipe_firestore_service.dart';
import 'recipe_detail_screen.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});
  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  late Future<List<List<Recipe>>> _plan;
  final _service = MealPlanService.instance;

  @override
  void initState() {
    super.initState();
    _load();
    _service.addListener(_changed);
  }

  void _load() {
    _plan = Future.wait(MealPlanService.weekdays.map(_service.recipesFor));
  }

  void _changed() {
    if (mounted) setState(_load);
  }

  @override
  void dispose() {
    _service.removeListener(_changed);
    super.dispose();
  }

  Future<void> _open(Recipe recipe) async {
    final updated = await Navigator.push<Recipe>(
      context,
      MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)),
    );
    if (updated != null) await RecipeFirestoreService.updateRecipe(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF5F0E8),
    appBar: AppBar(
      title: const Text(
        'Meal Planning',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 106, 23),
      foregroundColor: Colors.white,
    ),
    body: FutureBuilder<List<List<Recipe>>>(
      future: _plan,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _changed,
              child: const Text('Could not load meal plan. Tap to retry.'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Long-press a recipe or use its calendar button to plan a meal.',
            ),
            const SizedBox(height: 16),
            for (var d = 0; d < MealPlanService.weekdays.length; d++)
              Card(
                color: const Color(0xFFFDF6EC),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          MealPlanService.weekdays[d],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      if (snapshot.data![d].isEmpty)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text('No recipes planned'),
                        ),
                      for (var i = 0; i < snapshot.data![d].length; i++)
                        ListTile(
                          title: Text(snapshot.data![d][i].name),
                          subtitle: Text(snapshot.data![d][i].cookTime),
                          onTap: () => _open(snapshot.data![d][i]),
                          trailing: IconButton(
                            tooltip:
                                'Remove ${snapshot.data![d][i].name} from ${MealPlanService.weekdays[d]}',
                            icon: const Icon(Icons.close),
                            onPressed: () async {
                              try {
                                await _service.remove(
                                  MealPlanService.weekdays[d],
                                  i,
                                );
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Could not remove meal. Please try again.',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      _DayNote(
                        key: ValueKey(MealPlanService.weekdays[d]),
                        day: MealPlanService.weekdays[d],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _DayNote extends StatefulWidget {
  final String day;
  const _DayNote({super.key, required this.day});

  @override
  State<_DayNote> createState() => _DayNoteState();
}

class _DayNoteState extends State<_DayNote> {
  late Future<String> _note;
  Future<void> _pendingSave = Future<void>.value();
  final _focus = FocusNode();
  String? _value;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _note = MealPlanService.instance.noteFor(widget.day);
    _focus.addListener(_focusChanged);
  }

  void _focusChanged() {
    if (!_focus.hasFocus && mounted && _editing) {
      setState(() => _editing = false);
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_focusChanged);
    _focus.dispose();
    super.dispose();
  }

  void _save(String value) {
    _value = value;
    _pendingSave = _pendingSave.then((_) async {
      try {
        await MealPlanService.instance.saveNote(widget.day, value);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Could not save your notes.'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () => _save(_value ?? value),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
    child: FutureBuilder<String>(
      future: _note,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return TextButton(
            onPressed: () => setState(() {
              _note = MealPlanService.instance.noteFor(widget.day);
            }),
            child: const Text('Could not load notes. Tap to retry.'),
          );
        }
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final value = _value ?? snapshot.data!;
        if (!_editing) {
          if (value.trim().isEmpty) {
            return Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: const Icon(Icons.edit_note),
                label: const Text('Add note'),
              ),
            );
          }
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(value),
            trailing: const Icon(Icons.edit_outlined, size: 18),
            onTap: () => setState(() => _editing = true),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFormField(
              key: ValueKey('${widget.day} note'),
              initialValue: value,
              focusNode: _focus,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              maxLength: 250,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _focus.unfocus(),
              onTapOutside: (_) => _focus.unfocus(),
              decoration: InputDecoration(
                labelText: '${widget.day} notes',
                hintText: 'Leftovers, takeout, dinner out…',
                border: const OutlineInputBorder(),
              ),
              onChanged: _save,
            ),
          ],
        );
      },
    ),
  );
}
