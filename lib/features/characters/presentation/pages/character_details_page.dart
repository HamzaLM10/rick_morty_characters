import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty_characters/core/theme/app_colors.dart';
import 'package:rick_morty_characters/core/widgets/error_view.dart';
import 'package:rick_morty_characters/features/characters/domain/entities/character.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_cubit.dart';
import 'package:rick_morty_characters/features/characters/presentation/cubit/character_details_state.dart';

/// The details screen. Its Cubit is provided from outside (see app_router.dart).
class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.nameScrim,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ),
      ),
      body: BlocBuilder<CharacterDetailsCubit, CharacterDetailsState>(
        builder: (context, state) => switch (state) {
          CharacterDetailsInitial() || CharacterDetailsLoading() =>
            const Center(child: CircularProgressIndicator()),
          CharacterDetailsLoaded(:final character) => _DetailsContent(
            character: character,
          ),
          CharacterDetailsError(:final exception) => ErrorView(
            exception: exception,
            onRetry: () => context.read<CharacterDetailsCubit>().load(),
          ),
        },
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  const _DetailsContent({required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 360,
              width: double.infinity,
              child: ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Image.network(
                  character.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image_outlined, size: 64),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: AppColors.nameScrim,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Text(
                  character.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(label: 'Status', value: character.status),
              _InfoRow(label: 'Species', value: character.species),
              if (character.hasType)
                _InfoRow(label: 'Type', value: character.type),
              _InfoRow(label: 'Gender', value: character.gender),
              _InfoRow(label: 'Origin', value: character.origin),
              _InfoRow(label: 'Last location', value: character.lastLocation),
              _InfoRow(label: 'Episodes', value: '${character.episodeCount}'),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Label : value" with a short amber line under it.
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$label : ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          // Like the reference: the line length follows the label length.
          Container(
            height: 2,
            width: (label.length + 3) * 9.0,
            color: AppColors.amber,
          ),
        ],
      ),
    );
  }
}
