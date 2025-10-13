import 'package:clones_desktop/assets.dart';
import 'package:clones_desktop/ui/views/generate_factory/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GenerateFactoryTextFieldApp extends ConsumerStatefulWidget {
  const GenerateFactoryTextFieldApp({
    super.key,
    required this.appIdx,
  });

  final int appIdx;

  @override
  ConsumerState<GenerateFactoryTextFieldApp> createState() =>
      GenerateFactoryTextFieldAppState();
}

class GenerateFactoryTextFieldAppState
    extends ConsumerState<GenerateFactoryTextFieldApp> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    final generateFactory = ref.read(generateFactoryNotifierProvider);
    controller =
        TextEditingController(text: generateFactory.apps?[widget.appIdx].name);
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final generateFactoryNotifier =
        ref.watch(generateFactoryNotifierProvider.notifier);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: mediaQuery.size.width,
          child: Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              color:
                                  ClonesColors.tertiary.withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                ClonesColors.primary.withValues(alpha: 0.1),
                                ClonesColors.tertiary.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: TextField(
                            style: theme.textTheme.bodyMedium,
                            autocorrect: false,
                            controller: controller,
                            onChanged: (text) async {
                              generateFactoryNotifier.updateAppName(
                                widget.appIdx,
                                text,
                              );
                            },
                            focusNode: focusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(
                                60,
                              ),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: ClonesColors.secondary
                                      .withValues(alpha: 0.1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0.5,
                                  color: ClonesColors.primary
                                      .withValues(alpha: 0.1),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
