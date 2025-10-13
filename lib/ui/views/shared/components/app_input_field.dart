import 'package:clones_desktop/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.placeholder = 'App name',
    this.maxLength = 60,
    this.enabled = true,
    this.showIcon = false,
    this.iconUrl,
  });

  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final int maxLength;
  final bool enabled;
  final bool showIcon;
  final String? iconUrl;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
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
  void didUpdateWidget(AppInputField oldWidget) {
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
          'App',
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
                  ClonesColors.primary.withValues(alpha: 0.1),
                  ClonesColors.tertiary.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                if (widget.showIcon && widget.iconUrl != null) ...[
                  Positioned(
                    left: 10,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          'http://127.0.0.1:19847/proxy-image?url=${Uri.encodeComponent('https://www.google.com/s2/favicons?domain=${widget.iconUrl}&sz=32')}',
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.apps,
                            size: 16,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                TextField(
                  style: theme.textTheme.bodyMedium,
                  autocorrect: false,
                  controller: _controller,
                  enabled: widget.enabled,
                  onChanged: widget.onChanged,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.maxLength),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.placeholder,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.5,
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
                    contentPadding: const EdgeInsets.only(left: 35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
