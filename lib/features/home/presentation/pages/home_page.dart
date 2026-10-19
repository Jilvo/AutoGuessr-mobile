import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/features/auth/domain/user.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_guessr_mobile/core/widgets/widgets.dart';

/// Écran d'accueil : une version visiteur et une version connectée.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = switch (context.watch<AuthCubit>().state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    // Les deux menus (connecté ou non) partagent ce handler. Le menu dit QUELLE
    // entrée a été choisie, la page décide OÙ aller. Le `switch` sur l'enum est
    // exhaustif : si tu ajoutes une entrée, le compilateur t'obligera à la
    // gérer ici. `push` : on empile l'écran, la flèche retour ramène ici.
    void openEntry(_HomeMenuEntry entry) => context.push(switch (entry) {
      // TODO(toi) : pointer vers l'écran de jeu quand il existera.
      _HomeMenuEntry.newGame => Routes.register,
      _HomeMenuEntry.resume => Routes.login,
      _HomeMenuEntry.capture => Routes.scanner,
      _HomeMenuEntry.profile => Routes.profile,
      _HomeMenuEntry.options => Routes.options,
    });

    // Chaque version est découpée en petits widgets (header + corps) : le
    // `build` reste lisible, et le `if / else` n'apparaît qu'une fois par zone.
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackgroundHeader(
              child: user == null
                  ? const _GuestHeader()
                  : _UserHeader(user: user),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: user == null
                  ? _GuestBody(onMenuEntry: openEntry)
                  : _UserBody(onMenuEntry: openEntry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Première ligne du bandeau rouge : logo + "Version rouge" à gauche,
/// [trailing] à droite (bouton de connexion ou avatar).
class _TopBar extends StatelessWidget {
  const _TopBar({required this.trailing});

  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Partie décorative : elle prend la place restante et rétrécit si
        // l'écran est étroit ou la police agrandie.
        Expanded(child: _VersionLabel()),
        const SizedBox(width: AppSpacing.md),
        // L'action garde toujours sa taille : elle doit rester lisible et
        // facile à toucher.
        trailing,
      ],
    );
  }
}

/// Bandeau du visiteur : bouton de connexion, gros logo, accroche.
class _GuestHeader extends StatelessWidget {
  const _GuestHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopBar(
          trailing: FilledButton(
            onPressed: () => context.go(Routes.login),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ink,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              // Remplace la largeur infinie du thème : obligatoire pour un
              // bouton placé dans un Row.
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md + 4,
              ),
              textStyle: Theme.of(context).textTheme.labelMedium,
            ),
            child: const Text('SE CONNECTER'),
          ),
        ),
        // Espacement plus grand ici : on change de "bloc".
        const SizedBox(height: AppSpacing.lg),
        // `scaleDown` : taille 64 si la place le permet, sinon le mot
        // rétrécit d'un bloc au lieu de passer à la ligne.
        const FittedBox(fit: BoxFit.scaleDown, child: CardexLogoText(size: 64)),
        const SizedBox(height: AppSpacing.md),
        const PixelLabel(
          'Flashe-les toutes !',
          color: AppColors.textPrimary,
          size: 15,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Prends en photo les voitures que tu croises. Chaque modèle '
          'identifié rejoint ton CarDex.',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

/// Bandeau de l'utilisateur connecté : avatar, salutation, progression.
class _UserHeader extends StatelessWidget {
  const _UserHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopBar(trailing: _AvatarMenu(user: user)),
        const SizedBox(height: AppSpacing.lg),
        PixelLabel(
          'Salut, ${user.pseudo} !',
          color: AppColors.textPrimary,
          size: 15,
        ),
        // Salut + titre forment un bloc : espacement serré.
        const SizedBox(height: AppSpacing.sm),
        const FittedBox(fit: BoxFit.scaleDown, child: CardexLogoText(size: 56)),
        const SizedBox(height: AppSpacing.md),
        const _ProgressCard(),
      ],
    );
  }
}

/// Avatar rond avec l'initiale du pseudo. Un tap ouvre un petit menu
/// (profil, déconnexion).
class _AvatarMenu extends StatelessWidget {
  const _AvatarMenu({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final pseudo = user.pseudo.trim();
    final initial = pseudo.isEmpty ? '?' : pseudo[0].toUpperCase();

    // `PopupMenuButton` : chaque entrée porte une valeur (ici une fonction),
    // renvoyée à `onSelected` quand on la choisit. On utilise le `context` de
    // la page (pas celui du menu, qui disparaît à sa fermeture).
    return PopupMenuButton<VoidCallback>(
      tooltip: 'Mon compte',
      onSelected: (action) => action(),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: () => context.push(Routes.profile),
          child: const Text('Profil'),
        ),
        PopupMenuItem(
          value: () => context.read<AuthCubit>().logout(),
          child: const Text('Se déconnecter'),
        ),
      ],
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.ink,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.yellow, width: 2),
        ),
        child: Text(
          initial,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: AppColors.yellow, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

/// Carte "128 / 248 capturées" + barre d'XP, dans le bandeau rouge.
// TODO(toi) : remplacer les données en dur par la vraie progression.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    // `Container` plutôt que `Card` : pas de marge, d'ombre ni de couleur
    // Material imposées, juste un fond arrondi.
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // `Expanded` : le texte prend la place restante et pousse
              // "OUVRIR" à droite.
              Expanded(
                // Un seul texte, plusieurs styles : chaque `TextSpan` hérite
                // du style parent et ne redéfinit que ce qui change.
                child: Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.labelMedium,
                    children: const [
                      TextSpan(
                        text: '128',
                        style: TextStyle(color: AppColors.yellow),
                      ),
                      TextSpan(text: ' / 248 CAPTURÉES'),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textMuted,
                  textStyle: Theme.of(context).textTheme.labelSmall,
                  // Retire le padding et la taille minimale du TextButton,
                  // pour qu'il s'aligne sur le bord droit de la carte.
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('OUVRIR ›'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: 128 / 248,
            minHeight: 8,
            color: AppColors.yellow,
            backgroundColor: AppColors.border,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Niv. 7 · Spotter — 640 / 1000 XP',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Sous le bandeau, pour le visiteur : voiture mystère + menu.
class _GuestBody extends StatelessWidget {
  const _GuestBody({required this.onMenuEntry});

  final ValueChanged<_HomeMenuEntry> onMenuEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PixelLabel(
          'Quelle est cette voiture ?',
          color: AppColors.yellow,
          size: 14,
        ),
        const SizedBox(height: AppSpacing.md),
        // TODO(toi) : la voiture mystère du jour viendra de l'API.
        Card(
          // Le Card ajoute par défaut une marge et une ombre : on les retire
          // pour qu'il s'aligne pile sur le reste de la page.
          margin: EdgeInsets.zero,
          elevation: 0,
          color: AppColors.surface,
          // `RoundedRectangleBorder` : coins arrondis ; `side` dessine le
          // trait de la bordure (`Border.all` ferait des angles droits).
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            side: const BorderSide(color: AppColors.border, width: 2),
          ),
          // Découpe l'image selon l'arrondi : sans ça, elle déborde
          // par-dessus les coins.
          clipBehavior: Clip.antiAlias,
          // `AspectRatio` : la hauteur suit la largeur de l'écran ; `cover`
          // remplit le cadre quitte à rogner les bords de la photo.
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.asset('assets/images/clio4.jpg', fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        // `spaceBetween` : un texte collé à gauche, l'autre à droite.
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PixelLabel('N° ???', color: AppColors.textMuted),
            SizedBox(width: AppSpacing.md),
            // `Flexible` : sur un écran étroit, ce texte passe à la ligne au
            // lieu de déborder.
            Flexible(
              child: PixelLabel(
                'Devine-la pour +50 XP',
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _HomeMenu(
          entries: const [
            _HomeMenuEntry.newGame,
            _HomeMenuEntry.resume,
            _HomeMenuEntry.options,
          ],
          onActivated: onMenuEntry,
        ),
        const SizedBox(height: AppSpacing.lg),
        const Center(
          child: PixelLabel('Appuie sur start', color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Sous le bandeau, pour l'utilisateur connecté : défi du jour, dernière
/// capture, menu.
class _UserBody extends StatelessWidget {
  const _UserBody({required this.onMenuEntry});

  final ValueChanged<_HomeMenuEntry> onMenuEntry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DailyChallengeCard(),
        const SizedBox(height: AppSpacing.md),
        const _LastCaptureCard(),
        const SizedBox(height: AppSpacing.lg),
        _HomeMenu(
          entries: const [
            _HomeMenuEntry.capture,
            _HomeMenuEntry.profile,
            _HomeMenuEntry.options,
          ],
          onActivated: onMenuEntry,
        ),
      ],
    );
  }
}

/// Carte "Défi du jour" : vignette de la voiture mystère + textes.
// TODO(toi) : remplacer les données en dur par le vrai défi du jour.
class _DailyChallengeCard extends StatelessWidget {
  const _DailyChallengeCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // `Material` + `InkWell` : toute la carte est cliquable, avec
    // l'ondulation Material qui suit l'arrondi (`shape`).
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO(toi) : lancer le défi du jour.
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // `ClipRRect` : arrondit l'image elle-même, sans Card autour.
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.asset(
                  'assets/images/clio4.jpg',
                  width: 112,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    const PixelLabel(
                      'Défi du jour · +50 XP',
                      color: AppColors.yellow,
                    ),
                    Text(
                      'Quelle est cette voiture ?',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Série en cours : 4 jours',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carte "écran LCD" de la dernière voiture capturée.
// TODO(toi) : remplacer les données en dur par la vraie dernière capture.
class _LastCaptureCard extends StatelessWidget {
  const _LastCaptureCard();

  @override
  Widget build(BuildContext context) {
    // `Material` + `InkWell` : toute la carte est cliquable, avec
    // l'ondulation Material qui suit l'arrondi (`borderRadius`).
    return Material(
      color: AppColors.lcd,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO(toi) : ouvrir la fiche de la voiture.
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Vignette : taille fixe, en attendant la vraie photo.
              Container(
                width: 64,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.lcdInk,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  'R34',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.lcd),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // `Expanded` : les textes prennent la place restante et
              // poussent le chevron contre le bord droit.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    const PixelLabel(
                      'Dernière capture · hier',
                      color: AppColors.lcdInkMuted,
                    ),
                    Text(
                      '#087 Skyline GT-R R34',
                      // Un nom trop long est coupé avec "…" au lieu de faire
                      // déborder la ligne.
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.lcdInk, fontSize: 20),
                    ),
                  ],
                ),
              ),
              // Simple indice visuel : c'est la carte entière qui réagit au
              // toucher.
              const Icon(
                Icons.chevron_right,
                color: AppColors.lcdInk,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _VersionEntry {
  red('Rouge'),
  blue('Bleue'),
  green('Verte');

  const _VersionEntry(this.versionColor);
  final String versionColor;
}

/// Les entrées du menu d'accueil. Chaque valeur porte ses propres textes :
/// ajouter une entrée = ajouter une ligne ici.
enum _HomeMenuEntry {
  // Visiteur non connecté.
  newGame('Nouvelle partie'),
  resume('Continuer', 'Connexion · reprends ta collection'),
  // Utilisateur connecté.
  capture('Capturer', 'Ouvrir le scanner'),
  profile('Profil', 'Carte pilote · 3 / 8 badges'),
  options('Options');

  const _HomeMenuEntry(this.title, [this.subtitle]);

  final String title;

  /// Facultatif : "Options" n'en a pas.
  final String? subtitle;
}

/// Menu façon jeu rétro : un ▶ devant l'entrée sélectionnée.
///
/// - Tap sur une entrée : la sélectionne. Tap sur l'entrée déjà sélectionnée :
///   la valide (comme le bouton A d'une Game Boy).
/// - Appui long puis glisser : le ▶ suit le doigt ; lâcher valide l'entrée
///   sous le doigt (glisser hors du menu avant de lâcher = annuler).
///
/// ─── Comment marche un StatefulWidget ───────────────────────────────────────
/// Il est fait de DEUX classes :
/// 1. `_HomeMenu` (le widget) : la CONFIGURATION, immuable (que des `final`).
///    Flutter la jette et la recrée à chaque fois que le parent se reconstruit.
/// 2. `_HomeMenuState` (l'état) : créé UNE seule fois par `createState()`, il
///    SURVIT aux reconstructions. C'est là que vivent les variables qui
///    changent, comme `_selected`.
/// Depuis l'état, on lit la configuration avec `widget.xxx`.
///
/// Widget à part : un `setState` ici ne reconstruit que le menu, pas toute
/// la page d'accueil.
class _HomeMenu extends StatefulWidget {
  const _HomeMenu({required this.entries, required this.onActivated});

  /// Les entrées à afficher, dans l'ordre. La première est sélectionnée au
  /// départ.
  final List<_HomeMenuEntry> entries;

  /// Appelé quand une entrée est VALIDÉE (pas quand elle est juste
  /// sélectionnée : ça, c'est l'affaire interne du menu).
  final ValueChanged<_HomeMenuEntry> onActivated;

  @override
  State<_HomeMenu> createState() => _HomeMenuState();
}

class _VersionLabel extends StatefulWidget {
  const _VersionLabel();

  @override
  State<_VersionLabel> createState() => _VersionLabelState();
}

class _VersionLabelState extends State<_VersionLabel> {
  _VersionEntry _version = _VersionEntry.red;
  void _nextVersion() {
    final nextIndex = (_version.index + 1) % _VersionEntry.values.length;
    
    setState(() => _version = _VersionEntry.values[nextIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: _nextVersion,
        child: Row(
          children: [
            const CardexLogo(size: 26),
            // `Flexible` : le label accepte d'avoir moins de place que
            // demandé ; `FittedBox` le réduit alors au lieu de déborder.

            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: PixelLabel(
                "Version ${_version.versionColor}",
                color: AppColors.textPrimary,
                size: 13,
              ),
            ),
          ],
        ),
      );
  }
}

class _HomeMenuState extends State<_HomeMenu> {
  /// L'état : l'entrée devant laquelle s'affiche le ▶.
  /// `late` : on ne peut pas lire `widget` ici, on l'initialise dans
  /// `initState`.
  late _HomeMenuEntry _selected;

  /// Une clé par entrée, pour retrouver où chacune est dessinée à l'écran
  /// pendant le glissement. Créées une seule fois, en même temps que l'état.
  final _itemKeys = {
    for (final entry in _HomeMenuEntry.values) entry: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _selected = widget.entries.first;
  }

  /// Appelé quand le parent reconstruit le menu avec une nouvelle
  /// configuration (ex. : on se connecte, la liste d'entrées change). L'état,
  /// lui, a survécu : si l'entrée sélectionnée n'existe plus, on revient à la
  /// première.
  @override
  void didUpdateWidget(_HomeMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.entries.contains(_selected)) {
      _selected = widget.entries.first;
    }
  }

  // Cycle de vie d'un State :
  // - initState() : appelé UNE fois, à la création. Pour initialiser un
  //   controller, s'abonner à un stream...
  // - build()     : appelé après chaque setState, et à chaque reconstruction
  //   du parent. Doit être rapide et sans effet de bord.
  // - dispose()   : appelé UNE fois, quand le widget quitte l'écran. Pour
  //   libérer controllers et abonnements (les GlobalKey n'en ont pas besoin).

  /// Change la sélection. `setState` prévient Flutter : "l'état a changé,
  /// rappelle build()". Sans lui, la variable changerait, mais pas l'écran.
  void _select(_HomeMenuEntry entry) {
    // Rien ne change : on évite un rebuild (et une vibration) inutile. Pendant
    // un glissement, ce cas arrive à chaque pixel de mouvement.
    if (entry == _selected) return;
    HapticFeedback.selectionClick(); // petit "clic", comme un menu de console
    setState(() => _selected = entry);
  }

  void _onItemTap(_HomeMenuEntry entry) {
    if (entry == _selected) {
      widget.onActivated(entry); // `widget` = la configuration (_HomeMenu)
    } else {
      _select(entry);
    }
  }

  /// Quelle entrée se trouve sous le doigt ? `null` s'il est entre deux
  /// entrées ou hors du menu.
  _HomeMenuEntry? _entryAt(Offset globalPosition) {
    for (final entry in widget.entries) {
      // Le "RenderBox" est l'objet qui connaît la taille et la position réelles
      // du widget à l'écran ; la GlobalKey permet de le retrouver.
      final box = _itemKeys[entry]!.currentContext?.findRenderObject();
      if (box is! RenderBox) continue;
      // Position du doigt dans le repère de l'entrée : il est dessus s'il se
      // trouve entre (0, 0) et (largeur, hauteur).
      final local = box.globalToLocal(globalPosition);
      if ((Offset.zero & box.size).contains(local)) return entry;
    }
    return null;
  }

  void _onPressMove(Offset globalPosition) {
    if (_entryAt(globalPosition) case final entry?) _select(entry);
  }

  void _onPressEnd(Offset globalPosition) {
    if (_entryAt(globalPosition) case final entry?) widget.onActivated(entry);
  }

  @override
  Widget build(BuildContext context) {
    // La Column parente centre ses enfants sans les étirer : sans ce
    // SizedBox, la boîte prendrait la largeur de son texte.
    return SizedBox(
      width: double.infinity,
      child: RetroDialogBox(
        // UN seul détecteur autour de tout le menu pour l'appui long : un
        // détecteur par entrée ne verrait jamais le doigt arriver depuis une
        // autre entrée (le geste appartient au widget où il a commencé).
        // Appui long plutôt que simple glissement : un glissement normal
        // reste libre pour faire défiler la page.
        child: RawGestureDetector(
          gestures: {
            LongPressGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  LongPressGestureRecognizer
                >(
                  () => LongPressGestureRecognizer(
                    duration: const Duration(milliseconds: 200),
                  ),
                  (recognizer) {
                    recognizer.onLongPressStart = (details) =>
                        _onPressMove(details.globalPosition);
                    recognizer.onLongPressMoveUpdate = (details) =>
                        _onPressMove(details.globalPosition);
                    recognizer.onLongPressEnd = (details) =>
                        _onPressEnd(details.globalPosition);
                  },
                ),
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.lg,
            children: [
              for (final entry in widget.entries)
                _HomeMenuItem(
                  key: _itemKeys[entry],
                  entry: entry,
                  selected: entry == _selected,
                  onTap: () => _onItemTap(entry),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Une ligne du menu : le ▶ (si sélectionnée), le titre et le sous-titre.
///
/// `StatelessWidget` : elle ne décide rien, elle affiche ce qu'on lui donne
/// et PRÉVIENT le parent quand on la touche (via [onTap]). C'est le parent
/// qui possède l'état : on dit qu'on "remonte l'état" (lifting state up).
class _HomeMenuItem extends StatelessWidget {
  const _HomeMenuItem({
    super.key,
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final _HomeMenuEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // `Semantics` : annonce "bouton, sélectionné" au lecteur d'écran.
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        // Sans `opaque`, seuls le texte et l'icône réagiraient : toucher
        // l'espace vide de la ligne ne ferait rien.
        behavior: HitTestBehavior.opaque,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        // `maintainSize` : le ▶ garde sa place même caché, pour que le texte
        // ne saute pas de côté quand la sélection change.
        Visibility.maintain(
          visible: selected,
          child: const Icon(Icons.play_arrow, color: AppColors.ink, size: 28),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              PixelLabel(entry.title, color: AppColors.ink, size: 16),
              if (entry.subtitle case final subtitle?)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.inkMuted),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
