import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskInputField extends StatefulWidget {
  const TaskInputField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.placeholder = 'Task description',
    this.maxLength = 200,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 3,
  });

  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final int maxLength;
  final bool enabled;
  final int minLines;
  final int maxLines;

  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update controller if the initialValue changed and it's different from current text
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          'Task ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ClonesColors.tertiary.withValues(alpha: 0.3),
                width: 0.5,
              ),
              gradient: LinearGradient(
                colors: [
                  ClonesColors.primary.withValues(alpha: 0.05),
                  ClonesColors.tertiary.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: TextField(
              style: theme.textTheme.bodyMedium,
              autocorrect: false,
              controller: _controller,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              focusNode: _focusNode,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              inputFormatters: [
                LengthLimitingTextInputFormatter(widget.maxLength),
              ],
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.placeholder,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ClonesColors.secondary.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: ClonesColors.primary.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: ClonesColors.tertiary.withValues(alpha: 0.2),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
