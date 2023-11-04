// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:game_template/src/pixel_adventure/pixel_adventure_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Выбор уровня',
                ),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      GoRouter.of(context).go('/play/${PixelAdventurePage.routeName}');
                    },
                    title: Text('Пиксельное приключение', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  for (final level in gameLevels)
                    ListTile(
                      enabled: playerProgress.highestLevelReached >= level.number - 1,
                      onTap: () {
                        final audioController = context.read<AudioController>();
                        audioController.playSfx(SfxType.buttonTap);

                        GoRouter.of(context).go('/play/session/${level.number}');
                      },
                      leading: Text(
                        '${level.number}.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 20,
                              color: playerProgress.highestLevelReached >= level.number - 1
                                  ? palette.ink
                                  : palette.ink.withOpacity(.5),
                            ),
                      ),
                      title: Text(
                        'Уровень #${level.number}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: playerProgress.highestLevelReached >= level.number - 1
                                  ? palette.ink
                                  : palette.ink.withOpacity(.5),
                            ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        rectangularMenuArea: FilledButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: Text(
            'Назад',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: palette.trueWhite),
          ),
        ),
      ),
    );
  }
}
