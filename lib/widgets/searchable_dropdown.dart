// lib/widgets/searchable_dropdown.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchableDropdown extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final String? value;
  final Function(String) onChanged;
  final bool isSearchable;
  final bool allowManualEntry;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const SearchableDropdown({
    Key? key,
    required this.label,
    required this.hintText,
    required this.items,
    this.value,
    required this.onChanged,
    this.isSearchable = true,
    this.allowManualEntry = true,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Only handle focus changes for dropdown behavior
    // but don't auto-open on focus to prevent unwanted popups
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        // Only close dropdown when focus is lost
        // Don't auto-open on focus to improve smoothness
        _closeDropdown();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _openDropdown() {
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _closeDropdown() {
    if (_isOpen) {
      _isOpen = false;
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    // Add a small offset to prevent accidental closing when clicking near the edge
    final dropdownOffset = Offset(0.0, size.height + 2.0);

    return OverlayEntry(
      // Make sure overlay has highest z-index
      opaque: false,
      maintainState: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          List<String> filteredItems = widget.items;
          if (_searchQuery.isNotEmpty) {
            filteredItems = widget.items
                .where((item) =>
                    item.toLowerCase().contains(_searchQuery.toLowerCase()))
                .toList();
          }

          return Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: size.width,
            // Add GestureDetector to handle taps and prevent propagation
            child: GestureDetector(
              onTap: () {
                // Capture tap to prevent dropdown from closing
              },
              child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: dropdownOffset,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: filteredItems.length > 5
                      ? 250.0
                      : (filteredItems.length == 0)
                          ? 50.0
                          : filteredItems.length * 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      if (widget.isSearchable)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            // Remove autofocus to prevent keyboard popping up immediately
                            // autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: Icon(Icons.search, size: 20),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            // Add tap handling to prevent closing dropdown
                            onTap: () {
                              // Prevent event propagation to parent
                              // This keeps dropdown open when tapping the search field
                            },
                          ),
                        ),
                      Expanded(
                        child: filteredItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: widget.allowManualEntry
                                      ? const Text(
                                          'No matches found. You can type your own entry.')
                                      : const Text('No matches found.'),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    dense: true,
                                    title: Text(filteredItems[index]),
                                    onTap: () {
                                      widget.controller.text =
                                          filteredItems[index];
                                      widget.onChanged(filteredItems[index]);
                                      _closeDropdown();
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            onTap: _openDropdown, // Open dropdown on tap of the container
            child: IgnorePointer(
              ignoring: false, // Allow text field to be focused but we handle tap separately
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                // Remove onTap since parent InkWell handles it now
                readOnly: true, // Make it read-only to avoid keyboard popup
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: GestureDetector(
                onTap: () {
                  if (_isOpen) {
                    _closeDropdown();
                  } else {
                    _openDropdown();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/MainIcon.svg',
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
                ),
                onChanged: widget.onChanged,
                validator: widget.validator,
              ),
            ),
          ),
        ),
      ],
    );
  }
}