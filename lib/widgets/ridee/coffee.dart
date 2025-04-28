import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/ridee/tip_selection.dart';

class Coffee extends StatefulWidget {
  const Coffee({
    this.isExtended = false,
    required this.onTap,
    this.tipAmounts = const [0, 1000, 2000, 3000, 4000],
    this.selectedAmount = 0,
    this.onAmountSelected,
    super.key,
  });

  final bool isExtended;
  final VoidCallback onTap;
  final List<int> tipAmounts;
  final int selectedAmount;
  final ValueChanged<int>? onAmountSelected;

  @override
  State<Coffee> createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  int _selectedAmount = 0;

  @override
  void initState() {
    super.initState();
    _selectedAmount = widget.selectedAmount;
  }

  void _handleTipSelected(int selectedTip) {
    setState(() {
      _selectedAmount = selectedTip;
      print("select" + _selectedAmount.toString());
    });
    if (widget.onAmountSelected != null) {
      widget.onAmountSelected!(selectedTip);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExtended
        ? Container(
            width: 344.v,
            margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: scheme.surfaceBright,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Text(
                  'Rezime maivana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 14,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10.v,
                  ),
                ),
                SizedBox(height: 12.h),
                TipSelection(
                  tipAmounts: widget.tipAmounts,
                  onTipSelected: _handleTipSelected,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          )
        : Column(
            children: [
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  'Rezima maivana ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 14.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.10.v,
                  ),
                ),
              ),
              SizedBox(height: 70.h),
            ],
          );
  }
}

class TipBadge extends StatelessWidget {
  const TipBadge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.v,
        vertical: 6.h,
      ),
      child: Text(
        '1000',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.10.v,
        ),
      ),
    );
  }
}
