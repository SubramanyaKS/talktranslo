import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextCard extends StatefulWidget {
  const TextCard({
    super.key,
    required this.controller,
    required this.hint,
    required this.onCopy,
    required this.onSpeak,
    required this.editable,
    this.onClear,
    this.onPaste,
    this.onShare,
    this.onMicTap,
    this.isListening = false,
    this.isFavorite = false,
    this.onFavorite,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onCopy;
  final VoidCallback onSpeak;
  final bool editable;
  final VoidCallback? onClear;
  final VoidCallback? onPaste;
  final VoidCallback? onShare;
  final VoidCallback? onMicTap;
  final bool isListening;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant TextCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null && data.text!.isNotEmpty) {
      widget.controller.text = data.text!;
      if (widget.onPaste != null) widget.onPaste!();
    }
  }

  void _handleClear() {
    widget.controller.clear();
    if (widget.onClear != null) widget.onClear!();
  }

  void _handleShare() {
    if (widget.onShare != null) {
      widget.onShare!();
    } else {
      widget.onCopy();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Input / Display Field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: widget.editable
                ? TextField(
                    controller: widget.controller,
                    minLines: 4,
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.45,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: theme.hintColor.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Container(
                    constraints: const BoxConstraints(minHeight: 90),
                    alignment: Alignment.topLeft,
                    child: SelectableText(
                      widget.controller.text.isEmpty
                          ? widget.hint
                          : widget.controller.text,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.45,
                        color: widget.controller.text.isEmpty
                            ? theme.hintColor.withValues(alpha: 0.7)
                            : colorScheme.onSurface,
                        fontStyle: widget.controller.text.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ),
          ),

          const Divider(height: 1, thickness: 0.6),

          // Bottom Action Toolbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: [
                // Live Character Counter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "${widget.controller.text.length} chars",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                const Spacer(),

                // Action: Voice Dictation (Only if editable & onMicTap provided)
                if (widget.editable && widget.onMicTap != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    icon: Icon(
                      widget.isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      size: 21,
                      color: widget.isListening
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    tooltip: widget.isListening ? 'Stop listening' : 'Dictate with voice',
                    onPressed: widget.onMicTap,
                  ),

                // Action: Paste (Only if editable)
                if (widget.editable)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(Icons.paste_rounded, size: 20),
                    tooltip: 'Paste from clipboard',
                    color: colorScheme.onSurfaceVariant,
                    onPressed: _handlePaste,
                  ),

                // Action: Clear (Only if editable & has text)
                if (widget.editable && hasText)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(Icons.clear_rounded, size: 20),
                    tooltip: 'Clear text',
                    color: colorScheme.onSurfaceVariant,
                    onPressed: _handleClear,
                  ),

                // Action: Speak
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                  tooltip: 'Listen pronunciation',
                  color: hasText ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  onPressed: hasText ? widget.onSpeak : null,
                ),

                // Action: Copy
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(6),
                  icon: const Icon(Icons.copy_rounded, size: 20),
                  tooltip: 'Copy to clipboard',
                  color: hasText ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  onPressed: hasText ? widget.onCopy : null,
                ),

                // Action: Favorite / Star (Only if not editable & callback provided)
                if (!widget.editable && widget.onFavorite != null)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    icon: Icon(
                      widget.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 22,
                      color: widget.isFavorite ? Colors.amber.shade700 : colorScheme.onSurfaceVariant,
                    ),
                    tooltip: widget.isFavorite ? 'Saved to phrases' : 'Save to phrasebook',
                    onPressed: hasText ? widget.onFavorite : null,
                  ),

                // Action: Share (Only if not editable)
                if (!widget.editable)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(6),
                    icon: const Icon(Icons.share_rounded, size: 20),
                    tooltip: 'Share translation',
                    color: hasText ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    onPressed: hasText ? _handleShare : null,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
