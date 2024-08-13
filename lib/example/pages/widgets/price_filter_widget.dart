import 'package:flutter/material.dart';

class PriceFilterWidet extends StatelessWidget {
  final String title;
  final ValueChanged<RangeValues>? onChanged;
  final double? minPrice;
  final double? maxPrice;

  final ValueNotifier<RangeValues> priceBoundRanges;

  const PriceFilterWidet({
    super.key,
    required this.title,
    required this.onChanged,
    required this.minPrice,
    required this.maxPrice,
    required this.priceBoundRanges,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [
        ValueListenableBuilder(
            valueListenable: priceBoundRanges,
            builder: (_, item, __) {
              final minValue = item.start;
              final maxValue = item.end;

              final values =
                  RangeValues(minPrice ?? minValue, maxPrice ?? maxValue);
              return Column(
                children: [
                  RangeSlider(
                    values: values,
                    onChanged: onChanged,
                    min: minValue,
                    max: maxValue,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${values.start}'),
                      Text('${values.end}'),
                    ],
                  )
                ],
              );
            }),
      ],
    );
  }
}
