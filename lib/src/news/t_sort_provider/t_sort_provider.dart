import 'package:flutter/material.dart';

import 'package:t_widgets/t_widgets.dart';

part 't_sort_item.dart';

class TSortProviderButton extends StatelessWidget {
  const TSortProviderButton({
    super.key,
    required this.value,
    required this.list,
    this.onApply,
    this.title,
    this.boxConstraints,
  });

  final List<TSortItem> list;
  final TSortItem value;
  final BoxConstraints? boxConstraints;
  final void Function(TSortItem item)? onApply;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: col.tertiaryContainer,
        foregroundColor: col.onTertiaryContainer,
      ),
      onPressed: () async {
        final res = await showModalBottomSheet<TSortItem>(
          context: context,
          builder: (context) => TSortProviderDialog(
            list: list,
            value: value,
            title: title,
            boxConstraints: boxConstraints,
          ),
        );
        if (res == null) return;
        onApply?.call(res);
      },
      icon: Icon(Icons.sort),
    );
  }
}

class TSortProviderDialog extends StatefulWidget {
  const TSortProviderDialog({
    super.key,
    required this.list,
    required this.value,
    this.boxConstraints,
    this.title,
  });
  final List<TSortItem> list;
  final TSortItem value;
  final String? title;
  final BoxConstraints? boxConstraints;
  @override
  State<TSortProviderDialog> createState() => _TSortProviderDialogState();
}

class _TSortProviderDialogState extends State<TSortProviderDialog> {
  late TSortItem item;

  @override
  void initState() {
    super.initState();
    item = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final col = context.colorScheme;
    final textTheme = context.textTheme;

    return ConstrainedBox(
      constraints:
          widget.boxConstraints ?? const BoxConstraints(minHeight: 500),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          spacing: 4,
          children: [
            // Header
            _header(col, textTheme),

            // Sort group
            sortGropWidget,

            SizedBox(height: 1),

            // Sort result
            sortResultWidgt,

            // Apply
            // applyWidget,
          ],
        ),
      ),
    );
  }

  SizedBox _header(ColorScheme col, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
        child: Row(
          children: [
            Container(
              padding: .all(5),
              decoration: BoxDecoration(
                borderRadius: .circular(10),
                color: col.surfaceContainerHighest,
              ),
              child: Icon(Icons.sort, color: col.onSurface),
            ),
            SizedBox(width: 10),
            Text(
              'Sort By',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get sortGropWidget {
    final col = context.colorScheme;

    return Container(
      padding: .symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.surfaceContainer,
        border: .all(color: col.outlineVariant),
      ),
      // clipBehavior: Clip.antiAlias,
      child: RadioGroup<TSortItem>(
        groupValue: item,
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            item = value;
          });
        },
        child: Column(
          spacing: 5,
          children: widget.list.map((e) {
            final selected = e == item;

            return Container(
              decoration: !selected
                  ? null
                  : BoxDecoration(
                      borderRadius: .circular(15),
                      color: col.surfaceContainerHigh,
                    ),
              child: RadioListTile<TSortItem>.adaptive(
                value: e,
                selected: selected,
                title: Text(
                  e.title,
                  style: TextStyle(
                    color: selected ? col.onSecondaryContainer : col.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                dense: true,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget get sortResultWidgt {
    final col = context.colorScheme;
    return Container(
      padding: .symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: col.surfaceContainer,
        border: .all(color: col.outlineVariant),
      ),
      child: RadioGroup<bool>(
        groupValue: item.isTrue,
        onChanged: (value) {
          if (value == null) return;

          setState(() {
            item = item.copyWith(isTrue: value);
          });
        },
        child: Column(
          children: [
            Container(
              decoration: !item.isTrue
                  ? null
                  : BoxDecoration(
                      borderRadius: .circular(15),
                      color: col.surfaceContainerHigh,
                    ),
              child: RadioListTile<bool>.adaptive(
                value: true,
                title: Text(item.trueTitle),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                dense: true,
              ),
            ),
            Container(
              decoration: item.isTrue
                  ? null
                  : BoxDecoration(
                      borderRadius: .circular(15),
                      color: col.surfaceContainerHigh,
                    ),
              child: RadioListTile<bool>.adaptive(
                value: false,
                title: Text(item.falseTitle),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                dense: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
