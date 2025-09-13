import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C5CE7),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );

    return MaterialApp(
      title: 'Shruti Debnath — Portfolio',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatelessWidget {
  PortfolioHome({super.key});

  // 👇 create a key for the Projects section
  final GlobalKey _projectsKey = GlobalKey();

  void _scrollToProjects() {
    final context = _projectsKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                title: const _Brand(),
                centerTitle: false,
                actions: isNarrow ? null : [const _NavBar()],
              ),

              // 👇 Pass scroll function into Hero section
              SliverToBoxAdapter(
                child: _HeroSection(
                  isNarrow: isNarrow,
                  onViewProjects: _scrollToProjects,
                ),
              ),

              const SliverToBoxAdapter(child: _SectionSpacer()),
              const SliverToBoxAdapter(child: _AboutMe()),
              const SliverToBoxAdapter(child: _SectionSpacer()),

              // 👇 assign the key here
              SliverToBoxAdapter(
                child: _ProjectsSection(key: _projectsKey),
              ),

              const SliverToBoxAdapter(child: _SectionSpacer()),
              const SliverToBoxAdapter(child: _SkillsSection()),
              const SliverToBoxAdapter(child: _SectionSpacer()),
              const SliverToBoxAdapter(child: _ContactSection()),
              const SliverToBoxAdapter(child: _Footer()),
            ],
          );
        },
      ),
      drawer: const _SideDrawer(),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          'Shruti Debnath',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _NavButton(label: 'About', targetKey: _AboutMe.keyValue),
      _NavButton(label: 'Projects', targetKey: _ProjectsSection.keyValue),
      _NavButton(label: 'Skills', targetKey: _SkillsSection.keyValue),
      _NavButton(label: 'Contact', targetKey: _ContactSection.keyValue),
      const SizedBox(width: 16),
    ]);
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final GlobalKey targetKey;

  const _NavButton({required this.label, required this.targetKey});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _scrollToKey(targetKey),
      child: Text(label),
    );
  }
}

class _SideDrawer extends StatelessWidget {
  const _SideDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(
                leading: Icon(Icons.info_outline), title: Text('About')),
            const ListTile(
                leading: Icon(Icons.work_outline), title: Text('Projects')),
            const ListTile(
                leading: Icon(Icons.bolt), title: Text('Skills')),
            const ListTile(
                leading: Icon(Icons.mail_outline), title: Text('Contact')),
            const Divider(),
            Wrap(spacing: 12, children: const [
              _SocialIcon(icon: Icons.linked_camera, url: 'https://linkedin.com'),
              _SocialIcon(icon: Icons.code, url: 'https://github.com'),
              _SocialIcon(
                  icon: Icons.alternate_email,
                  url: 'mailto:debnathshruti477@gmail.com'),
            ]),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isNarrow;
  final VoidCallback? onViewProjects; // 👈 new callback

  const _HeroSection({
    Key? key,
    required this.isNarrow,
    this.onViewProjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headline = Text(
      "Hi, I'm Shruti Debnath",
      style: Theme.of(context)
          .textTheme
          .headlineMedium
          ?.copyWith(fontWeight: FontWeight.bold),
    );

    final sub = Text(
      "Passionate about software engineering, databases, and UI/UX.\n"
      "Building mobile, web, and game projects.",
      style: Theme.of(context).textTheme.bodyLarge,
    );

    final cta = Row(
      children: [
        ElevatedButton(
          onPressed: onViewProjects, // 👈 now triggers scroll
          child: const Text("View Projects"),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: () => _launch("https://github.com/shruti-246"),
          icon: const Icon(Icons.code),
          label: const Text("GitHub"),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: isNarrow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  headline,
                  const SizedBox(height: 12),
                  sub,
                  const SizedBox(height: 20),
                  cta,
                  const SizedBox(height: 40),
                  const _AvatarCard(),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        headline,
                        const SizedBox(height: 12),
                        sub,
                        const SizedBox(height: 20),
                        cta,
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Flexible(
                    flex: 4,
                    child: Center(child: _AvatarCard()),
                  ),
                ],
              ),
      ),
    );
  }
}

class _AvatarCard extends StatefulWidget {
  const _AvatarCard({Key? key}) : super(key: key);

  @override
  State<_AvatarCard> createState() => _AvatarCardState();
}

class _AvatarCardState extends State<_AvatarCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _hovering
            ? ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  'assets/avatar_hover.png',
                  key: const ValueKey(1),
                  height: 240,
                  width: 240,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: Image.asset(
                  'assets/avatar.png',
                  key: const ValueKey(2),
                  height: 240,
                  width: 240,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final GlobalKey keyValue;

  const _Section(
      {required this.title, required this.child, required this.keyValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keyValue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _AboutMe extends StatelessWidget {
  static final keyValue = GlobalKey();
  const _AboutMe();

  @override
  Widget build(BuildContext context) {
    return _Section(
      keyValue: keyValue,
      title: 'About',
      child: Text(
        "Computer Science student with a keen interest in software engineering and databases.\nAspiring researcher and problem solver.",
      ),
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  static final keyValue = GlobalKey();

  const _ProjectsSection({Key? key}) : super(key: key); // 👈 fix here

  @override
  Widget build(BuildContext context) {
    final projects = [
      Project(
        title: 'BarterDB',
        description:
            'A barter marketplace with role-based flows and code verification.',
        tech: ['Django/Flask', 'SQLite', 'Render Deployment'],
        demoUrl: 'https://bartersystem-mowi.onrender.com',
        githubUrl: 'https://github.com/shruti-246/BarterSystem',
        image: 'assets/projects/barter_welcome.png',
      ),
      Project(
        title: 'Unity Game UI',
        description: 'Menu, Settings, and Shop flow with design patterns.',
        tech: ['Unity', 'C#'],
        demoUrl:
            'https://drive.google.com/file/d/1fR7Z4LCLAUbvLe8JaqucWBlK9Gi16i0b/view?usp=sharing',
        githubUrl: 'https://github.com/shruti-246/legend_of_warriors',
        image: 'assets/projects/company_logo.png',
      ),
    ];

    return _Section(
      keyValue: keyValue,
      title: 'Projects',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth < 700
              ? 1
              : constraints.maxWidth < 1100
                  ? 2
                  : 3;
          return GridView.builder(
            itemCount: projects.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, i) => ProjectCard(project: projects[i]),
          );
        },
      ),
    );
  }
}

class Project {
  final String title;
  final String description;
  final List<String> tech;
  final String demoUrl;
  final String githubUrl;
  final String image;
  Project(
      {required this.title,
      required this.description,
      required this.tech,
      required this.demoUrl,
      required this.githubUrl,
      required this.image});
}

class ProjectCard extends StatelessWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView( // ✅ ensures no overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project thumbnail (resized safely)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // ✅ aligns top
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        project.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      project.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                project.description,
                maxLines: 4, // ✅ allow a little more before ellipsis
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Tech stack
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in project.tech)
                    Chip(
                      label: Text(t),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  if (project.demoUrl != null)
                    Flexible( // ✅ prevents button overflow
                      child: TextButton.icon(
                        onPressed: () => _launch(project.demoUrl!),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Live Demo'),
                      ),
                    ),
                  if (project.githubUrl != null)
                    Flexible(
                      child: TextButton.icon(
                        onPressed: () => _launch(project.githubUrl!),
                        icon: const Icon(Icons.code),
                        label: const Text('GitHub'),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  static final keyValue = GlobalKey();
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final skills = {
      'Languages': ['Dart', 'Python', 'C#', 'SQL'],
      'Frameworks': ['Flutter', 'Unity', 'FastAPI/Flask'],
      'Tools': ['Git', 'Docker', 'SQLite/MySQL'],
    };

    return _Section(
      keyValue: keyValue,
      title: 'Skills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.entries
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 140,
                          child: Text(e.key,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600))),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: e.value
                              .map((s) => Chip(label: Text(s)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  static final keyValue = GlobalKey();
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      keyValue: keyValue,
      title: 'Contact',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Want to collaborate or have a role in mind? Let's talk."),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _ContactChip(
                  icon: Icons.alternate_email,
                  label: 'debnathshruti477@gmail.com',
                  url: 'mailto:debnathshruti477@gmail.com'),
              _ContactChip(
                  icon: Icons.code,
                  label: 'github.com/shruti-246',
                  url: 'https://github.com/shruti-246'),
              _ContactChip(
                  icon: Icons.business_center,
                  label: 'LinkedIn',
                  url: 'https://www.linkedin.com/in/shrutidebnath224/'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _ContactChip(
      {required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () => _launch(url),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;
  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => _launch(url),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: Text(
          '© ${DateTime.now().year} Shruti Debnath — Built with Flutter',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _SectionSpacer extends StatelessWidget {
  const _SectionSpacer();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 24);
}

Future<void> _launch(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not launch: $url');
  }
}

void _scrollToKey(GlobalKey key) {
  final ctx = key.currentContext;
  if (ctx == null) return;
  Scrollable.ensureVisible(ctx,
      duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
}
