// ignore_for_file: dead_code

import 'package:auto_guessr_mobile/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_guessr_mobile/core/theme/app_colors.dart';
import 'package:auto_guessr_mobile/core/theme/app_spacing.dart';
import 'package:auto_guessr_mobile/core/widgets/pixel_label.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:auto_guessr_mobile/features/auth/presentation/cubit/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_guessr_mobile/core/widgets/widgets.dart';

/// Écran d'accueil provisoire, pour vérifier que l'authentification fonctionne.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = switch (context.watch<AuthCubit>().state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };

    bool isUserAuthenticated = user != null;
    // bool isUserAuthenticated = true;
    return Scaffold(
      body: Column(
        children: [
          BackgroundHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isUserAuthenticated
                  ? [
                      Row(
                        children: [
                          // Partie décorative : elle prend la place restante et
                          // rétrécit si l'écran est étroit ou la police agrandie.
                          Expanded(
                            child: Row(
                              children: [
                                const CardexLogo(size: 26),
                                // `Flexible` : le label accepte d'avoir moins de
                                // place que demandé ; `FittedBox` le réduit alors
                                // au lieu de déborder.
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: PixelLabel(
                                      'Version rouge',
                                      color: AppColors.textPrimary,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // L'action garde toujours sa taille : elle doit rester
                          // lisible et facile à toucher.
                          FilledButton(
                            onPressed: () => isUserAuthenticated
                                ? context.read<AuthCubit>().logout()
                                : context.go(Routes.login),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.ink,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              // Remplace la largeur infinie du thème : obligatoire
                              // pour un bouton placé dans un Row.
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md + 4,
                              ),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium,
                            ),
                            child: Text(
                              isUserAuthenticated
                                  ? 'SE DÉCONNECTER'
                                  : 'SE CONNECTER',
                            ),
                          ),
                        ],
                      ),
                      // Espacement plus grand ici : on change de "bloc".
                      const SizedBox(height: AppSpacing.lg),
                      PixelLabel(
                        "Salut, ${user?.pseudo ?? 'Inconnu'} !",
                        color: AppColors.textPrimary,
                        size: 15,
                      ),
                      // Salut + titre forment un bloc : espacement serré.
                      const SizedBox(height: AppSpacing.sm),
                      // `scaleDown` : taille 56 si la place le permet, sinon le
                      // mot rétrécit d'un bloc au lieu de passer à la ligne.
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: CardexLogoText(size: 56),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // `Container` plutôt que `Card` : pas de marge, d'ombre
                      // ni de couleur Material imposées, juste un fond arrondi.
                      Container(
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
                                // `Expanded` : le texte prend la place restante
                                // et pousse "OUVRIR" à droite.
                                Expanded(
                                  // Un seul texte, plusieurs styles : chaque
                                  // `TextSpan` hérite du style parent et ne
                                  // redéfinit que ce qui change.
                                  child: Text.rich(
                                    TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      children: const [
                                        TextSpan(
                                          text: '128',
                                          style: TextStyle(
                                            color: AppColors.yellow,
                                          ),
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
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                    // Retire le padding et la taille minimale
                                    // du TextButton, pour qu'il s'aligne sur
                                    // le bord droit de la carte.
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Niv. 7 · Spotter — 640 / 1000 XP',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : [
                      Row(
                        children: [
                          // Partie décorative : elle prend la place restante et
                          // rétrécit si l'écran est étroit ou la police agrandie.
                          Expanded(
                            child: Row(
                              children: [
                                const CardexLogo(size: 26),
                                // `Flexible` : le label accepte d'avoir moins de
                                // place que demandé ; `FittedBox` le réduit alors
                                // au lieu de déborder.
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: PixelLabel(
                                      'Version rouge',
                                      color: AppColors.textPrimary,
                                      size: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // L'action garde toujours sa taille : elle doit rester
                          // lisible et facile à toucher.
                          FilledButton(
                            onPressed: () => isUserAuthenticated
                                ? context.read<AuthCubit>().logout()
                                : context.go(Routes.login),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.ink,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              // Remplace la largeur infinie du thème : obligatoire
                              // pour un bouton placé dans un Row.
                              minimumSize: const Size(0, 44),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md + 4,
                              ),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium,
                            ),
                            child: Text(
                              isUserAuthenticated
                                  ? 'SE DÉCONNECTER'
                                  : 'SE CONNECTER',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.md),
                      // `scaleDown` : taille 74 si la place le permet, sinon le
                      // mot rétrécit d'un bloc au lieu de passer à la ligne.
                      const Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: CardexLogoText(size: 74),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      PixelLabel(
                        "FLASHE-LES TOUTES !",
                        color: AppColors.textPrimary,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        "Prends en photo les voitures que tu croises. Chaque modèle identifié rejoint ton CarDex.",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(AppSpacing.md),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dernières voitures capturées',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // TODO(toi) : remplacer par une liste de voitures capturées.
                  const Center(
                    child: PixelLabel(
                      'Aucune voiture capturée pour l’instant.',
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // TODO(toi) : remplacer les données en dur par la vraie dernière
          // capture.
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            // `Material` + `InkWell` : toute la carte est cliquable, avec
            // l'ondulation Material qui suit l'arrondi (`borderRadius`).
            child: Material(
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
                              // Un nom trop long est coupé avec "…" au lieu
                              // de faire déborder la ligne.
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: AppColors.lcdInk,
                                    fontSize: 20,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Simple indice visuel : c'est la carte entière qui
                      // réagit au toucher.
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.lcdInk,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
