import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_ui_kit/flutter_neumorphic_ui_kit.dart';

void main() {
  runApp(const NeuKitShowcaseApp());
}

class NeuKitShowcaseApp extends StatefulWidget {
  const NeuKitShowcaseApp({super.key});

  @override
  State<NeuKitShowcaseApp> createState() => _NeuKitShowcaseAppState();
}

class _NeuKitShowcaseAppState extends State<NeuKitShowcaseApp> {
  bool _isDarkMode = false;
  double _globalDepth = 4.0;
  double _globalDistance = 4.0;
  double _globalIntensity = 0.65;
  double _lightAngle = 225.0; // degrees (225° = top-left light source)
  Color _baseSurface = NeuColors.defaultLightSurface;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _baseSurface = _isDarkMode
          ? NeuColors.defaultDarkSurface
          : NeuColors.defaultLightSurface;
    });
  }

  Offset _calculateLightSourceOffset(double angleDegrees) {
    final radians = angleDegrees * math.pi / 180.0;
    return Offset(math.cos(radians), math.sin(radians));
  }

  @override
  Widget build(BuildContext context) {
    final lightOffset = _calculateLightSourceOffset(_lightAngle);

    final neuTheme = NeuThemeData(
      baseColor: _baseSurface,
      accentColor:
          _isDarkMode ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6),
      lightSource: lightOffset,
      depth: _globalDepth,
      distance: _globalDistance,
      intensity: _globalIntensity,
    );

    return MaterialApp(
      title: 'Flutter Neumorphic UI Kit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: _baseSurface,
        fontFamily: 'Roboto',
      ),
      home: NeuTheme(
        data: neuTheme,
        child: ShowcaseHome(
          isDarkMode: _isDarkMode,
          onToggleTheme: _toggleTheme,
          globalDepth: _globalDepth,
          globalDistance: _globalDistance,
          globalIntensity: _globalIntensity,
          lightAngle: _lightAngle,
          baseSurface: _baseSurface,
          onUpdateCustomizer: (depth, distance, intensity, angle, color) {
            setState(() {
              _globalDepth = depth;
              _globalDistance = distance;
              _globalIntensity = intensity;
              _lightAngle = angle;
              if (color != null) {
                _baseSurface = color;
              }
            });
          },
        ),
      ),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.globalDepth,
    required this.globalDistance,
    required this.globalIntensity,
    required this.lightAngle,
    required this.baseSurface,
    required this.onUpdateCustomizer,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final double globalDepth;
  final double globalDistance;
  final double globalIntensity;
  final double lightAngle;
  final Color baseSurface;
  final void Function(
    double depth,
    double distance,
    double intensity,
    double angle,
    Color? color,
  ) onUpdateCustomizer;

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);

    return Scaffold(
      backgroundColor: theme.baseColor,
      appBar: NeuAppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.accentColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _currentIndex == 0
                  ? 'Neumorphic UI Kit'
                  : _currentIndex == 1
                      ? 'Live Lighting Lab'
                      : 'Smart Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: theme.isDark ? Colors.white : const Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: NeuIconButton(
              size: 40.0,
              icon: Icon(
                widget.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                size: 20,
                color: theme.accentColor,
              ),
              onPressed: widget.onToggleTheme,
              tooltip: widget.isDarkMode ? 'Light Mode' : 'Dark Mode',
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const ComponentsGalleryView(),
          CustomizerLabView(
            depth: widget.globalDepth,
            distance: widget.globalDistance,
            intensity: widget.globalIntensity,
            angle: widget.lightAngle,
            baseColor: widget.baseSurface,
            onChanged: widget.onUpdateCustomizer,
          ),
          const DashboardSampleView(),
        ],
      ),
      bottomNavigationBar: NeuBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          NeuBottomNavItem(
            icon: Icon(Icons.widgets_outlined),
            activeIcon: Icon(Icons.widgets_rounded),
            label: 'Kit',
          ),
          NeuBottomNavItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune_rounded),
            label: 'Playground',
          ),
          NeuBottomNavItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: COMPONENTS GALLERY
// -----------------------------------------------------------------------------
class ComponentsGalleryView extends StatefulWidget {
  const ComponentsGalleryView({super.key});

  @override
  State<ComponentsGalleryView> createState() => _ComponentsGalleryViewState();
}

class _ComponentsGalleryViewState extends State<ComponentsGalleryView> {
  bool _switchVal = true;
  double _sliderVal = 0.65;
  bool? _checkboxVal = true;
  int _radioVal = 1;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final textStyle = TextStyle(
      color: theme.isDark ? Colors.white70 : const Color(0xFF334155),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      children: [
        _buildSectionHeader('Buttons & Tactile Feedback'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            NeuButton(
              onPressed: () {},
              child: const Text('Flat Elevation'),
            ),
            NeuButton(
              shape: NeuShape.convex,
              onPressed: () {},
              child: const Text('Convex Dome'),
            ),
            NeuButton(
              shape: NeuShape.concave,
              onPressed: () {},
              child: const Text('Concave Dish'),
            ),
            const NeuButton(
              onPressed: null,
              child: Text('Disabled'),
            ),
            NeuIconButton(
              icon: Icon(Icons.thumb_up_rounded, color: theme.accentColor),
              onPressed: () {},
            ),
            NeuIconButton(
              shape: NeuShape.convex,
              icon: Icon(Icons.bolt_rounded, color: theme.accentColor),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildSectionHeader('Form Controls'),
        const SizedBox(height: 14),
        NeuCard(
          bevel: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tactile Switch', style: textStyle),
                  NeuSwitch(
                    value: _switchVal,
                    onChanged: (val) => setState(() => _switchVal = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Slider (${(_sliderVal * 100).toInt()}%)',
                      style: textStyle),
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeuSlider(
                      value: _sliderVal,
                      onChanged: (val) => setState(() => _sliderVal = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  NeuCheckbox(
                    value: _checkboxVal,
                    onChanged: (val) => setState(() => _checkboxVal = val),
                  ),
                  const SizedBox(width: 12),
                  Text('Checkbox (Tap to toggle)', style: textStyle),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  NeuRadio<int>(
                    value: 1,
                    groupValue: _radioVal,
                    onChanged: (val) => setState(() => _radioVal = val!),
                  ),
                  const SizedBox(width: 8),
                  Text('Option A', style: textStyle),
                  const SizedBox(width: 24),
                  NeuRadio<int>(
                    value: 2,
                    groupValue: _radioVal,
                    onChanged: (val) => setState(() => _radioVal = val!),
                  ),
                  const SizedBox(width: 8),
                  Text('Option B', style: textStyle),
                ],
              ),
              const SizedBox(height: 20),
              NeuTextField(
                controller: _textController,
                labelText: 'Neumorphic Input',
                hintText: 'Type to test inset clipping...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: const Icon(Icons.mic_none_rounded),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _buildSectionHeader('Progress & Indicators'),
        const SizedBox(height: 14),
        NeuCard(
          child: Column(
            children: [
              NeuProgressBar(value: _sliderVal),
              const SizedBox(height: 16),
              const NeuProgressBar(value: null), // Indeterminate
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NeuCircularProgress(
                    value: _sliderVal,
                    child: Text(
                      '${(_sliderVal * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: theme.accentColor,
                      ),
                    ),
                  ),
                  const NeuCircularProgress(value: null),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Builder(
      builder: (context) {
        final theme = NeuTheme.of(context);
        return Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: theme.isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: LIVE LIGHTING PLAYGROUND
// -----------------------------------------------------------------------------
class CustomizerLabView extends StatelessWidget {
  const CustomizerLabView({
    super.key,
    required this.depth,
    required this.distance,
    required this.intensity,
    required this.angle,
    required this.baseColor,
    required this.onChanged,
  });

  final double depth;
  final double distance;
  final double intensity;
  final double angle;
  final Color baseColor;
  final void Function(
    double depth,
    double distance,
    double intensity,
    double angle,
    Color? color,
  ) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final textStyle = TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.w600,
      color: theme.isDark ? Colors.white70 : const Color(0xFF475569),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      children: [
        Center(
          child: NeuContainer(
            width: 140,
            height: 140,
            shape: NeuShape.convex,
            borderRadius: BorderRadius.circular(32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wb_sunny_rounded,
                      size: 36, color: theme.accentColor),
                  const SizedBox(height: 6),
                  Text(
                    '${angle.toInt()}° Light',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: theme.isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        NeuCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Light Direction Angle (${angle.toInt()}°)',
                  style: textStyle),
              NeuSlider(
                min: 0,
                max: 360,
                value: angle,
                onChanged: (val) =>
                    onChanged(depth, distance, intensity, val, null),
              ),
              const SizedBox(height: 14),
              Text('Elevation Depth (${depth.toStringAsFixed(1)})',
                  style: textStyle),
              NeuSlider(
                min: 0,
                max: 12,
                value: depth,
                onChanged: (val) =>
                    onChanged(val, distance, intensity, angle, null),
              ),
              const SizedBox(height: 14),
              Text('Shadow Distance (${distance.toStringAsFixed(1)}px)',
                  style: textStyle),
              NeuSlider(
                min: 1,
                max: 15,
                value: distance,
                onChanged: (val) =>
                    onChanged(depth, val, intensity, angle, null),
              ),
              const SizedBox(height: 14),
              Text('Contrast Intensity (${(intensity * 100).toInt()}%)',
                  style: textStyle),
              NeuSlider(
                min: 0.1,
                max: 1.0,
                value: intensity,
                onChanged: (val) =>
                    onChanged(depth, distance, val, angle, null),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Surface Base Palette',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: theme.isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorSwatch(const Color(0xFFE0E5EC), 'Soft Gray'),
            _colorSwatch(const Color(0xFFE4DCD3), 'Clay'),
            _colorSwatch(const Color(0xFFE2E2F0), 'Mist'),
            _colorSwatch(const Color(0xFF24272C), 'Slate'),
            _colorSwatch(const Color(0xFF191B1F), 'Midnight'),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _colorSwatch(Color color, String name) {
    final isSelected = baseColor == color;
    return GestureDetector(
      onTap: () => onChanged(depth, distance, intensity, angle, color),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: const Color(0xFF3B82F6), width: 3)
                  : Border.all(color: Colors.black12, width: 1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 3: SMART HOME DASHBOARD SAMPLE
// -----------------------------------------------------------------------------
class DashboardSampleView extends StatefulWidget {
  const DashboardSampleView({super.key});

  @override
  State<DashboardSampleView> createState() => _DashboardSampleViewState();
}

class _DashboardSampleViewState extends State<DashboardSampleView> {
  double _temp = 22.5;
  bool _livingRoomLight = true;
  bool _acActive = true;
  bool _isPlaying = true;

  @override
  Widget build(BuildContext context) {
    final theme = NeuTheme.of(context);
    final isDark = theme.isDark;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      children: [
        // Welcome Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back,',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                Text(
                  'Living Sanctuary',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            NeuIconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Quick Stats Row
        Row(
          children: [
            Expanded(
              child: NeuCard(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.bolt_rounded,
                        color: theme.accentColor, size: 26),
                    const SizedBox(height: 8),
                    const Text('Energy',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text(
                      '3.8 kWh',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: NeuCard(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.water_drop_rounded,
                        color: Colors.cyanAccent.shade700, size: 26),
                    const SizedBox(height: 8),
                    const Text('Humidity',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text(
                      '48%',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Climate Control Card
        NeuCard(
          bevel: true,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.ac_unit_rounded, color: Colors.lightBlue),
                      SizedBox(width: 10),
                      Text(
                        'Climate Control',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  NeuSwitch(
                    value: _acActive,
                    onChanged: (val) => setState(() => _acActive = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              NeuCircularProgress(
                value: (_temp - 16.0) / 14.0,
                size: 110,
                strokeWidth: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_temp.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text('Cooling',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              NeuSlider(
                min: 16.0,
                max: 30.0,
                value: _temp,
                onChanged: _acActive ? (v) => setState(() => _temp = v) : null,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Smart Media Player
        NeuCard(
          child: Column(
            children: [
              Row(
                children: [
                  NeuContainer(
                    width: 52,
                    height: 52,
                    shape: NeuShape.convex,
                    borderRadius: BorderRadius.circular(12),
                    child: Icon(Icons.music_note_rounded,
                        color: theme.accentColor),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ambient Horizons',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                        Text(
                          'Neumorphic Waves',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  NeuIconButton(
                    size: 38,
                    icon: Icon(
                      _livingRoomLight
                          ? Icons.lightbulb_rounded
                          : Icons.lightbulb_outline_rounded,
                      color: _livingRoomLight ? Colors.amber : Colors.grey,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _livingRoomLight = !_livingRoomLight),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const NeuProgressBar(value: 0.42),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeuIconButton(
                    size: 44,
                    icon: const Icon(Icons.skip_previous_rounded),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 20),
                  NeuIconButton(
                    size: 54,
                    shape: NeuShape.convex,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: theme.accentColor,
                      size: 28,
                    ),
                    onPressed: () => setState(() => _isPlaying = !_isPlaying),
                  ),
                  const SizedBox(width: 20),
                  NeuIconButton(
                    size: 44,
                    icon: const Icon(Icons.skip_next_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
