import 'package:material_ui/material_ui.dart';
import 'package:t_widgets/t_widgets.dart';

enum TMaterialThemeProviderType {
  system,
  light,
  dark;

  String get lable {
    if (this == light) return 'Light';
    if (this == dark) return 'Dark';
    return 'System';
  }

  static TMaterialThemeProviderType fromName(String type) {
    if (type == light.name) return light;
    if (type == dark.name) return dark;
    return system;
  }
}

class TMaterialThemeProvider extends StatefulWidget {
  /// use -> TMaterialThemeProviderChooser
  ///
  const TMaterialThemeProvider({
    super.key,
    required this.getTheme,
    required this.onChanged,
    required this.child,
    this.theme,
    this.darkTheme,
  });

  final Widget child;
  final TMaterialThemeProviderType Function() getTheme;
  final void Function(TMaterialThemeProviderType type) onChanged;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  @override
  State<TMaterialThemeProvider> createState() => _TMaterialThemeProviderState();

  static final themeTypeNotifier = ValueNotifier<TMaterialThemeProviderType>(
    .system,
  );
}

class _TMaterialThemeProviderState extends State<TMaterialThemeProvider>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    TMaterialThemeProvider.themeTypeNotifier.value = widget.getTheme();
    TMaterialThemeProvider.themeTypeNotifier.addListener(() {
      widget.onChanged(TMaterialThemeProvider.themeTypeNotifier.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (TMaterialThemeProvider.themeTypeNotifier.value == .system) {
      setState(() {});
    }
  }

  ThemeMode get currentThemeMode {
    final themeType = TMaterialThemeProvider.themeTypeNotifier.value;
    return switch (themeType) {
      .dark => .dark,
      .light => .light,
      _ => .system,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TMaterialThemeProvider.themeTypeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: widget.theme ?? ThemeData.light(),
          darkTheme: widget.darkTheme ?? ThemeData.dark(useMaterial3: true),
          themeMode: currentThemeMode,
          home: widget.child,
        );
      },
    );
  }
}

class TMaterialThemeProviderChooser extends StatefulWidget {
  const TMaterialThemeProviderChooser({super.key, this.onChanged});
  final void Function(TMaterialThemeProviderType type)? onChanged;

  @override
  State<TMaterialThemeProviderChooser> createState() =>
      _TMaterialThemeProviderChooserState();
}

class _TMaterialThemeProviderChooserState
    extends State<TMaterialThemeProviderChooser> {
  final items = TMaterialThemeProviderType.values
      .map((e) => DropdownMenuItem(value: e, child: Text(e.lable)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final col = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(
          alpha: .45,
        ),
        borderRadius: .circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Container(
              padding: .all(8),
              decoration: BoxDecoration(
                borderRadius: .circular(15),
                color: col.tertiaryContainer,
              ),
              child: Icon(
                Icons.palette_outlined,
                size: 22,
                color: col.onTertiaryContainer,
              ),
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Text(
                'Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            ValueListenableBuilder<TMaterialThemeProviderType>(
              valueListenable: TMaterialThemeProvider.themeTypeNotifier,
              builder: (context, value, child) {
                return DropdownButtonHideUnderline(
                  child: DropdownButton<TMaterialThemeProviderType>(
                    value: value,
                    items: items,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    dropdownColor: col.surfaceContainerHighest,
                    style: TextStyle(
                      color: col.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        TMaterialThemeProvider.themeTypeNotifier.value = value;
                        widget.onChanged?.call(value);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
