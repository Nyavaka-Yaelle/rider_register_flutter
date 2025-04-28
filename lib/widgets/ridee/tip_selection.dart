import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class TipSelection extends StatefulWidget {
  final List<int> tipAmounts;
  final Function(int) onTipSelected;

  const TipSelection({
    Key? key,
    required this.tipAmounts,
    required this.onTipSelected,
  }) : super(key: key);

  @override
  State<TipSelection> createState() => _TipSelectionState();
}

class _TipSelectionState extends State<TipSelection> {
  int _selectedTip = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: List.generate(widget.tipAmounts.length, (index) {
        final tipAmount = widget.tipAmounts[index];
        return ChoiceChip(
          label: Text('$tipAmount'),
          selected: _selectedTip == index,
          onSelected: (isSelected) {
            setState(() {
              _selectedTip = index;
              widget.onTipSelected(tipAmount);
            });
          },
          selectedColor: scheme.secondaryContainer,
        );
      }),
    );
  }
}
