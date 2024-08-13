import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter/material.dart';

class FilterWidet extends StatelessWidget {
  final FacetList facetsList;
  final String title;
  final VoidCallback? onChanged;

  const FilterWidet({
    super.key,
    required this.facetsList,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SelectableItem<Facet>>>(
      stream: facetsList.facets,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final selectableFacets = snapshot.data!;
        return ExpansionTile(
          title: Text(title),
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: selectableFacets.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final selectableFacet = selectableFacets[index];
                return CheckboxListTile(
                    value: selectableFacet.isSelected,
                    title: Text(
                        "${selectableFacet.item.value} (${selectableFacet.item.count})"),
                    onChanged: (_) {
                      facetsList.toggle(selectableFacet.item.value);
                      onChanged?.call();
                    });
              },
            )
          ],
        );
      },
    );
  }
}
