import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isEditMode;
  final VoidCallback? onEdit;
  final String editButtonText; // New parameter for edit button text

  const CustomTopBar({
    Key? key,
    this.isEditMode = false,
    this.onEdit,
    this.editButtonText = 'Rediger', // Default value is "Rediger"
  }) : super(key: key);

  @override
  _CustomTopBarState createState() => _CustomTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomTopBarState extends State<CustomTopBar> {
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'No user';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          Colors.transparent, // Make the AppBar background transparent
      elevation: 0, // Remove elevation to keep the AppBar flat
      toolbarHeight: 80,
      automaticallyImplyLeading: false, // This removes the back button
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.isEditMode)
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              else
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/${username ?? ''}.png'),
                  radius: 25,
                ),
              const SizedBox(width: 10),
              if (!widget.isEditMode)
                Text(
                  'Velkommen ${_capitalize(username ?? '')}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          ElevatedButton(
            onPressed: widget.isEditMode
                ? widget.onEdit ?? () {}
                : () {
                    Navigator.of(context)
                        .pop(); // This will pop the current route
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.isEditMode ? widget.editButtonText : 'Log ud',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
