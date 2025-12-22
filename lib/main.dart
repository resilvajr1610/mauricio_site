import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MauricioDollenzApp());
}

class MauricioDollenzApp extends StatelessWidget {
  const MauricioDollenzApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827)),
      useMaterial3: true,
      textTheme: GoogleFonts.montserratTextTheme(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAURÍCIO DOLLENZ',
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F1A),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0B0F1A)),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<Map<String, dynamic>> _strings;

  @override
  void initState() {
    super.initState();
    _strings = _loadStrings();
  }

  Future<Map<String, dynamic>> _loadStrings() async {
    final raw = await rootBundle.loadString('assets/texts/pt_BR.json');
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  final _scroll = ScrollController();
  final _keys = {
    'home': GlobalKey(),
    'sobre': GlobalKey(),
    'palestra': GlobalKey(),
    'servicos': GlobalKey(),
    'rider': GlobalKey(),
    'clientes': GlobalKey(),
    'contato': GlobalKey(),
  };

  void _goTo(String id) {
    final key = _keys[id];
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _strings,
      builder: (context, snap) {
        final s = snap.data ?? const {};

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final isMobile = w < 840;
            final contentMax = isMobile ? w : 1100.0;

            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: _TopBar(
                  isMobile: isMobile,
                  onNav: _goTo,
                  title: (s['page01_name'] ?? 'Maurício Dollenz').toString(),
                ),
              ),
              body: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    _ImageBox(
                      asset: 'assets/embedded_images/capa.png',
                      fallback: 'assets/embedded_images/capa.png',
                    ),
                    _HeroSection(
                      key: _keys['home'],
                      maxWidth: contentMax,
                      name: (s['page01_name'] ?? '').toString(),
                      roles: (s['page01_roles'] ?? '').toString(),
                      headline: (s['page02_headline'] ?? '').toString(),
                      isMobile: isMobile,
                    ),
                    _Section(
                      key: _keys['sobre'],
                      title: (s['page03_title'] ?? 'Apresentação').toString(),
                      maxWidth: contentMax,
                      child: _TwoCol(
                        isMobile: isMobile,
                        left: _CardBox(
                          child: Text(
                            (s['page03_body'] ?? '').toString(),
                            style: const TextStyle(
                                color: Color(0xFFD1D5DB), height: 1.5),
                          ),
                        ),
                        right: _ImageBox(
                          asset: 'assets/embedded_images/p03_img01.jpeg',
                          fallback: 'assets/pages_png/page_03.png',
                        ),
                      ),
                    ),
                    _Section(
                      key: _keys['palestra'],
                      title: (s['page04_title'] ?? 'Palestra').toString(),
                      maxWidth: contentMax,
                      child: _TwoCol(
                        isMobile: isMobile,
                        left: _ImageBox(
                          asset: 'assets/photos/palestra_microfone_HD.png',
                          fallback: 'assets/embedded_images/p04_img01.jpeg',
                        ),
                        right: _CardBox(
                          child: Text(
                            (s['page04_body'] ?? '').toString(),
                            style: const TextStyle(
                                color: Color(0xFFD1D5DB), height: 1.5),
                          ),
                        ),
                      ),
                    ),
                    _Section(
                      key: _keys['servicos'],
                      title: 'Serviços',
                      subtitle: 'Formatos e apresentações',
                      maxWidth: contentMax,
                      child: _ServicesGrid(
                        isMobile: isMobile,
                        leftTitle:
                            (s['page05_left_title'] ?? 'Mestre de Cerimônia')
                                .toString(),
                        leftItems: (s['page05_left_items'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const [],
                        centerTitle:
                            (s['page05_center_title'] ?? 'Mágico').toString(),
                        centerItems: (s['page05_center_items'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const [],
                        rightTitle: (s['page05_right_title'] ?? 'Comediante')
                            .toString(),
                        rightItems: (s['page05_right_items'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const [],
                        themeTitle:
                            (s['page05_theme_title'] ?? 'Temas').toString(),
                        themeItems: (s['page05_theme_items'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const [],
                      ),
                    ),
                    _Section(
                      key: _keys['rider'],
                      title: (s['page06_title'] ?? 'Rider Técnico').toString(),
                      subtitle: (s['page06_subtitle'] ?? '').toString(),
                      maxWidth: contentMax,
                      child: _TwoCol(
                        isMobile: isMobile,
                        left: _CardBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...((s['page06_items'] as List?)
                                          ?.map((e) => e.toString())
                                          .toList() ??
                                      const [])
                                  .map((t) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('• ',
                                                style: TextStyle(
                                                    color: Color(0xFF93C5FD))),
                                            Expanded(
                                              child: Text(t,
                                                  style: const TextStyle(
                                                      color: Color(0xFFD1D5DB),
                                                      height: 1.35)),
                                            ),
                                          ],
                                        ),
                                      )),
                              const SizedBox(height: 12),
                              Text(
                                (s['page06_note'] ?? '').toString(),
                                style: const TextStyle(
                                    color: Color(0xFF9CA3AF), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        right: _ImageBox(
                          asset: 'assets/pages_png/page_06.png',
                          fallback: 'assets/embedded_images/p06_img01.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    _Section(
                      key: _keys['clientes'],
                      title: (s['page08_title'] ?? 'Parceiros e clientes')
                          .toString(),
                      maxWidth: contentMax,
                      child: _LogosGrid(isMobile: isMobile),
                    ),
                    _Section(
                      key: _keys['contato'],
                      title: 'Redes',
                      maxWidth: contentMax,
                      child: _SocialRow(
                        labels: (s['page09_labels'] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            const ['YouTube', 'Instagram'],
                      ),
                    ),
                    _Footer(
                      text: (s['page10_text'] ?? '').toString(),
                      maxWidth: contentMax,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool isMobile;
  final void Function(String id) onNav;
  final String title;

  const _TopBar({
    required this.isMobile,
    required this.onNav,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Início', 'home'),
      ('Sobre', 'sobre'),
      ('Palestra', 'palestra'),
      ('Serviços', 'servicos'),
      ('Rider', 'rider'),
      ('Clientes', 'clientes'),
      ('Contato', 'contato'),
    ];

    return AppBar(
      elevation: 0,
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      actions: isMobile
          ? [
              IconButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: const Color(0xFF0F172A),
                  showDragHandle: true,
                  builder: (_) => ListView(
                    children: items
                        .map((it) => ListTile(
                              title: Text(it.$1,
                                  style: const TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pop(context);
                                onNav(it.$2);
                              },
                            ))
                        .toList(),
                  ),
                ),
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
              const SizedBox(width: 8),
            ]
          : [
              ...items.map((it) => TextButton(
                    onPressed: () => onNav(it.$2),
                    child: Text(it.$1,
                        style: const TextStyle(color: Color(0xFFE5E7EB))),
                  )),
              const SizedBox(width: 12),
            ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final double maxWidth;
  final String name;
  final String roles;
  final String headline;
  final bool isMobile;

  const _HeroSection({
    super.key,
    required this.maxWidth,
    required this.name,
    required this.roles,
    required this.headline,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B0F1A), Color(0xFF111827)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16, isMobile ? 24 : 48, 16, isMobile ? 28 : 56),
            child: _TwoCol(
              isMobile: isMobile,
              left: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roles,
                    style: const TextStyle(
                        color: Color(0xFF93C5FD), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 36 : 56,
                      height: 1.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    headline,
                    style: TextStyle(
                      color: const Color(0xFFE5E7EB),
                      fontSize: isMobile ? 16 : 18,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _PillButton(
                        label: 'Ver vídeos',
                        onTap: () =>
                            _launch('https://www.youtube.com/@MauricioDollenz'),
                      ),
                      _PillButton(
                        label: 'Instagram',
                        onTap: () => _launch(
                            'https://www.instagram.com/mauriciodollenz/'),
                        outlined: true,
                      ),
                    ],
                  ),
                ],
              ),
              right: _ImageBox(
                asset:
                    'assets/photos/A_digital_photograph_of_a_light-skinned_performer_.png',
                fallback: 'assets/embedded_images/p01_img01.jpeg',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;

  const _PillButton({
    required this.label,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = outlined ? Colors.transparent : const Color(0xFF2563EB);
    final border =
        outlined ? const BorderSide(color: Color(0xFF334155)) : BorderSide.none;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
              color:
                  border == BorderSide.none ? Colors.transparent : border.color,
              width: 1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final double maxWidth;

  const _Section({
    super.key,
    required this.title,
    required this.child,
    required this.maxWidth,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800),
              ),
              if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(subtitle!,
                    style: const TextStyle(color: Color(0xFF9CA3AF))),
              ],
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _TwoCol extends StatelessWidget {
  final bool isMobile;
  final Widget left;
  final Widget right;

  const _TwoCol({
    required this.isMobile,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left,
          const SizedBox(height: 14),
          right,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 18),
        Expanded(child: right),
      ],
    );
  }
}

class _CardBox extends StatelessWidget {
  final Widget child;

  const _CardBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: child,
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String asset;
  final String fallback;
  final BoxFit fit;

  const _ImageBox({
    required this.asset,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.asset(
          asset,
          fit: fit,
          errorBuilder: (_, __, ___) => Image.asset(fallback, fit: fit),
        ),
      ),
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final bool isMobile;

  final String leftTitle;
  final List<String> leftItems;

  final String centerTitle;
  final List<String> centerItems;

  final String rightTitle;
  final List<String> rightItems;

  final String themeTitle;
  final List<String> themeItems;

  const _ServicesGrid({
    required this.isMobile,
    required this.leftTitle,
    required this.leftItems,
    required this.centerTitle,
    required this.centerItems,
    required this.rightTitle,
    required this.rightItems,
    required this.themeTitle,
    required this.themeItems,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ServiceCard(title: leftTitle, items: leftItems, icon: Icons.campaign),
      _ServiceCard(
          title: centerTitle, items: centerItems, icon: Icons.auto_awesome),
      _ServiceCard(title: rightTitle, items: rightItems, icon: Icons.mic),
      _ServiceCard(
          title: themeTitle, items: themeItems, icon: Icons.business_center),
    ];

    if (isMobile) {
      return Column(
        children: cards
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: c,
                ))
            .toList(),
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: cards
          .map((c) => SizedBox(
                width: 520,
                child: c,
              ))
          .toList(),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;

  const _ServiceCard({
    required this.title,
    required this.items,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF93C5FD)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: Color(0xFF93C5FD))),
                    Expanded(
                        child: Text(t,
                            style: const TextStyle(color: Color(0xFFD1D5DB)))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _LogosGrid extends StatelessWidget {
  final bool isMobile;

  const _LogosGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final logos = [
      'assets/embedded_images/absolut.png',
      'assets/embedded_images/allianz.png',
      'assets/embedded_images/br.png',
      'assets/embedded_images/coca.png',
      'assets/embedded_images/comedy.png',
      'assets/embedded_images/costa.png',
      'assets/embedded_images/disney.png',
      'assets/embedded_images/ford.png',
      'assets/embedded_images/globo.png',
      'assets/embedded_images/google.png',
      'assets/embedded_images/itau.png',
      'assets/embedded_images/mastercard.png',
      'assets/embedded_images/mercedes.png',
      'assets/embedded_images/sbt.png',
      'assets/embedded_images/tim.jpg',
      'assets/embedded_images/toyota.png',
    ];

    final cols = isMobile ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 16 / 9,
      ),
      itemBuilder: (context, i) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1F2937)),
          ),
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Image.asset(
              logos[i],
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  color: Color(0xFF6B7280)),
            ),
          ),
        );
      },
    );
  }
}

class _SocialRow extends StatelessWidget {
  final List<String> labels;

  const _SocialRow({required this.labels});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _SocialCard(
            label: labels.isNotEmpty ? labels[0] : 'YouTube',
            url: 'https://www.youtube.com/@MauricioDollenz'),
        _SocialCard(
            label: labels.length > 1 ? labels[1] : 'Instagram',
            url: 'https://www.instagram.com/mauriciodollenz/'),
      ],
    );
  }
}

class _SocialCard extends StatelessWidget {
  final String label;
  final String url;

  const _SocialCard({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launch(url),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1F2937)),
        ),
        child: Row(
          children: [
            const Icon(Icons.open_in_new, color: Color(0xFF93C5FD)),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String text;
  final double maxWidth;

  const _Footer({required this.text, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 38, 16, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF1F2937)),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFE5E7EB), height: 1.35),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: avoid_print
    print('Não foi possível abrir: $url');
  }
}
