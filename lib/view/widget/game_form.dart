import 'package:flutter/material.dart';
import '../../domain/models/game.dart';

class GameForm extends StatefulWidget {
  const GameForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Game? initial;
  final String submitLabel;
  final void Function(String title, GameStatus status) onSubmit;

  @override
  State<GameForm> createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late GameStatus _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _status = widget.initial?.status ?? GameStatus.backlog;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_titleController.text, _status);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul game',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Judul tidak boleh kosong'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<GameStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: GameStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.label),
                      ))
                  .toList(),
              onChanged: (s) {
                if (s != null) setState(() => _status = s);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _handleSubmit,
              child: Text(widget.submitLabel),
            ),
          ],
        ),
      ),
    );
  }
}