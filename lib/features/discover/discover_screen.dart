import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'discover_profile.dart';
import 'discover_service.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discoverService = context.read<DiscoverService>();
    return StreamBuilder<List<DiscoverProfile>>(
      stream: discoverService.watchDiscoverProfiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data ?? const <DiscoverProfile>[];
        if (items.isEmpty) {
          return const Center(child: Text('No profiles to show yet.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      item.photoUrl.isEmpty ? null : NetworkImage(item.photoUrl),
                  child: item.photoUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                title: Text('${item.name}, ${item.age}'),
                subtitle: Text(
                  item.bio.isEmpty ? 'No bio added yet.' : item.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
