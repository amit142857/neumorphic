import 'package:flutter/material.dart';
import '../core/neu_shape.dart';
import '../core/neu_theme.dart';
import 'neu_container.dart';

/// A neumorphic text field featuring a recessed input trough, focus transitions,
/// floating label support, and prefix/suffix icon slots.
class NeuTextField extends StatefulWidget {
  /// Creates a [NeuTextField].
  const NeuTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.borderRadius,
    this.baseColor,
    this.accentColor,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
  });

  /// Controller for text input.
  final TextEditingController? controller;

  /// Optional FocusNode.
  final FocusNode? focusNode;

  /// Optional label displayed above the field.
  final String? labelText;

  /// Hint text displayed when field is empty.
  final String? hintText;

  /// Subtitle helper message.
  final String? helperText;

  /// Error message displayed below the field.
  final String? errorText;

  /// Leading icon or widget.
  final Widget? prefixIcon;

  /// Trailing icon or widget.
  final Widget? suffixIcon;

  /// Whether text is obscured (for passwords).
  final bool obscureText;

  /// The keyboard type.
  final TextInputType? keyboardType;

  /// The action button on the virtual keyboard.
  final TextInputAction? textInputAction;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when submitted.
  final ValueChanged<String>? onSubmitted;

  /// Whether user can interact.
  final bool enabled;

  /// Whether to auto-focus.
  final bool autofocus;

  /// Corner radius.
  final BorderRadiusGeometry? borderRadius;

  /// Surface background color.
  final Color? baseColor;

  /// Accent highlight color when focused.
  final Color? accentColor;

  /// Maximum lines.
  final int? maxLines;

  /// Minimum lines.
  final int? minLines;

  /// Text style for input content.
  final TextStyle? style;

  /// Padding around the editable text area.
  final EdgeInsetsGeometry contentPadding;

  @override
  State<NeuTextField> createState() => _NeuTextFieldState();
}

class _NeuTextFieldState extends State<NeuTextField> {
  late FocusNode _focusNode;
  bool _isInternalFocusNode = false;

  late TextEditingController _controller;
  bool _isInternalController = false;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _isInternalFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }
    _isFocused = _focusNode.hasFocus;
    _focusNode.addListener(_handleFocusChange);

    if (widget.controller == null) {
      _controller = TextEditingController();
      _isInternalController = true;
    } else {
      _controller = widget.controller!;
    }
    _controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(covariant NeuTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (_isInternalFocusNode) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
        _isInternalFocusNode = true;
      } else {
        _focusNode = widget.focusNode!;
        _isInternalFocusNode = false;
      }
      _isFocused = _focusNode.hasFocus;
      _focusNode.addListener(_handleFocusChange);
    }

    if (widget.controller != oldWidget.controller) {
      if (_isInternalController) {
        _controller.removeListener(_handleTextChange);
        _controller.dispose();
      }
      if (widget.controller == null) {
        _controller = TextEditingController();
        _isInternalController = true;
      } else {
        _controller = widget.controller!;
        _isInternalController = false;
      }
      _controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_isInternalFocusNode) {
      _focusNode.dispose();
    }
    _controller.removeListener(_handleTextChange);
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  void _handleTextChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final accent = widget.accentColor ?? theme.accentColor;
    final isDark = theme.isDark;
    final hasError = widget.errorText != null;

    final effectiveRadius = widget.borderRadius ?? theme.borderRadius;

    final borderColor = hasError
        ? Colors.redAccent
        : (_isFocused ? accent : null);

    final border = borderColor != null
        ? Border.all(color: borderColor, width: 1.5)
        : null;

    final textColor = isDark ? Colors.white70 : Colors.black87;
    final labelColor = hasError
        ? Colors.redAccent
        : (_isFocused ? accent : (isDark ? Colors.white54 : Colors.black54));

    final effectiveStyle = widget.style ??
        TextStyle(
          color: textColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
        );

    final hintColor = isDark ? Colors.white30 : Colors.black38;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
            child: Text(
              widget.labelText!,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: labelColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
        Opacity(
          opacity: widget.enabled ? 1.0 : 0.5,
          child: NeuContainer(
            shape: NeuShape.pressed,
            borderRadius: effectiveRadius,
            baseColor: widget.baseColor ?? theme.baseColor,
            depth: _isFocused ? 4.0 : 2.5,
            border: border,
            padding: widget.contentPadding,
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: IconTheme(
                      data: IconThemeData(
                        color: _isFocused ? accent : (isDark ? Colors.white54 : Colors.black45),
                        size: 20.0,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  ),
                ],
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (widget.hintText != null && _controller.text.isEmpty)
                        Text(
                          widget.hintText!,
                          style: effectiveStyle.copyWith(color: hintColor),
                        ),
                      EditableText(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: effectiveStyle,
                        cursorColor: accent,
                        backgroundCursorColor: Colors.transparent,
                        obscureText: widget.obscureText,
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        autofocus: widget.autofocus,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        readOnly: !widget.enabled,
                      ),
                    ],
                  ),
                ),
                if (widget.suffixIcon != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: IconTheme(
                      data: IconThemeData(
                        color: _isFocused ? accent : (isDark ? Colors.white54 : Colors.black45),
                        size: 20.0,
                      ),
                      child: widget.suffixIcon!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 4.0),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                fontSize: 11.5,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ] else if (widget.helperText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 6.0, top: 4.0),
            child: Text(
              widget.helperText!,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
