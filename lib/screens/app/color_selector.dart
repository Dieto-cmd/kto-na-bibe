import 'package:flutter/material.dart';

class ColorSelector extends StatefulWidget {
  final Color? initialColor;
  final Function(Color) onColorSelected;
  const ColorSelector({
    super.key,
    this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  final List<Color> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.brown,
  ];

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _colors.map((color) {
        final isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedColor = color);
            widget.onColorSelected(color);
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: isSelected
                ? Icon(Icons.check, color: Colors.white, size: 30)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
