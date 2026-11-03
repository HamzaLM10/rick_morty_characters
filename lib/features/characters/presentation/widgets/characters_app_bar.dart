import 'package:flutter/material.dart';

/// Normal title bar that turns into a search field when the search icon
/// is pressed. It only reports user actions; it knows nothing about the
/// Bloc or the auth layer.
class CharactersAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CharactersAppBar({
    super.key,
    required this.onQueryChanged,
    this.onSignOut,
  });

  final ValueChanged<String> onQueryChanged;
  final VoidCallback? onSignOut;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CharactersAppBar> createState() => _CharactersAppBarState();
}

class _CharactersAppBarState extends State<CharactersAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() => _isSearching = true);
  }

  void _stopSearch() {
    _controller.clear();
    widget.onQueryChanged('');
    setState(() => _isSearching = false);
  }

  void _clearText() {
    _controller.clear();
    widget.onQueryChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSearching) {
      return AppBar(
        title: const Text('Characters'),
        actions: [
          IconButton(onPressed: _startSearch, icon: const Icon(Icons.search)),
          if (widget.onSignOut != null)
            IconButton(
              onPressed: widget.onSignOut,
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout),
            ),
        ],
      );
    }

    final foreground = Theme.of(context).colorScheme.onPrimary;

    return PopScope(
      // The system back button closes the search instead of leaving the app.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _stopSearch();
      },
      child: AppBar(
        leading: IconButton(
          onPressed: _stopSearch,
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          cursorColor: foreground,
          style: TextStyle(color: foreground, fontSize: 18),
          decoration: InputDecoration(
            hintText: 'Search characters...',
            hintStyle: TextStyle(color: foreground.withValues(alpha: 0.6)),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            widget.onQueryChanged(value);
            setState(() {});
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(onPressed: _clearText, icon: const Icon(Icons.close)),
        ],
      ),
    );
  }
}