import 'dart:async';

import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  /// Value changed callback for search input field
  final ValueChanged<String> onSearchInput;

  ///  Search input decoration config
  final SearchInputDecorationConfig decorationConfig;

  ///  Search input config
  final SearchInputConfig inputConfig;

  final TextEditingController? editController;

  const SearchInput({
    super.key,
    required this.onSearchInput,
    required this.decorationConfig,
    required this.inputConfig,
    this.editController,
  });

  @override
  State<StatefulWidget> createState() => SearchInputState();
}

class SearchInputState extends State<SearchInput> {
  late final TextEditingController editController;

  Timer? debouncer;

  bool hasSearchEntry = false;

  @override
  void initState() {
    super.initState();
    editController = widget.editController ??
        TextEditingController(text: widget.inputConfig.initialValue ?? '');
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer?.cancel();
    }

    debouncer = Timer(const Duration(seconds: 1), () {
      if (editController.text.isNotEmpty) {
        setState(() {
          hasSearchEntry = true;
        });
      }
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          // bottom shadow using Color.fromRGBO instead of withOpacity
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.18), // <- replaced
            offset: const Offset(0, 6),
            blurRadius: 14,
            spreadRadius: 0,
          ),
          // subtle top highlight (also replaced)
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.9), // <- replaced
            offset: const Offset(0, -1),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: widget.inputConfig.keyboardType,
        focusNode: widget.inputConfig.focusNode,
        textAlignVertical: widget.inputConfig.textAlignVertical,
        autofocus: widget.inputConfig.autofocus,
        style: widget.inputConfig.style,
        textCapitalization: widget.inputConfig.textCapitalization,
        textAlign: widget.inputConfig.textAlign,
        textDirection: widget.inputConfig.textDirection,
        showCursor: widget.inputConfig.showCursor,
        decoration: InputDecoration(
          label: widget.decorationConfig.label,
          labelText: widget.decorationConfig.labelText,
          labelStyle: widget.decorationConfig.labelStyle,
          helperText: widget.decorationConfig.helperText,
          helperStyle: widget.decorationConfig.helperStyle,
          helperMaxLines: widget.decorationConfig.helperMaxLines,
          hintText: widget.decorationConfig.hintText,
          hintStyle: widget.decorationConfig.hintStyle,
          hintTextDirection: widget.decorationConfig.hintTextDirection,
          hintFadeDuration: widget.decorationConfig.hintFadeDuration,
          hintMaxLines: widget.decorationConfig.hintMaxLines,
          prefixIcon: widget.decorationConfig.prefixIcon ??
              const Icon(
                Icons.search,
              ),
          prefixIconConstraints: widget.decorationConfig.prefixIconConstraints,
          prefixIconColor: widget.decorationConfig.prefixIconColor,
          prefixText: widget.decorationConfig.prefixText,
          prefixStyle: widget.decorationConfig.prefixStyle,
          suffixIcon: hasSearchEntry
              ? GestureDetector(
                  child: widget.decorationConfig.suffixIcon ??
                      const Icon(Icons.clear),
                  onTap: () {
                    editController.clear();
                    setState(() {
                      hasSearchEntry = false;
                    });
                  },
                )
              : null,
          suffixIconConstraints: widget.decorationConfig.suffixIconConstraints,
          suffixIconColor: widget.decorationConfig.suffixIconColor,
          suffixText: widget.decorationConfig.suffixText,
          suffixStyle: widget.decorationConfig.suffixStyle,
          errorBorder: widget.decorationConfig.errorBorder,
          focusedBorder: widget.decorationConfig.focusedBorder,
          focusedErrorBorder: widget.decorationConfig.focusedErrorBorder,
          disabledBorder: widget.decorationConfig.disabledBorder,
          enabledBorder: widget.decorationConfig.enabledBorder,
          border: widget.decorationConfig.border ?? InputBorder.none,
          isDense: widget.decorationConfig.isDense,
          filled: widget.decorationConfig.filled,
          fillColor:
              widget.decorationConfig.fillColor ?? Theme.of(context).canvasColor,
          contentPadding: widget.decorationConfig.contentPadding,
          enabled: widget.decorationConfig.enabled,
          constraints: widget.decorationConfig.constraints,
        ),
        controller: editController,
        onChanged: (value) {
          setState(() {
            hasSearchEntry = value.isNotEmpty;
          });
        },
      ),
    );
  }
}
