import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../user/controller/user_controller.dart';
import '../controller/community_controller.dart';

class CommunityMembersScreen extends ConsumerStatefulWidget {
  final String id;
  const CommunityMembersScreen({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunityMembersScreenState();
}

class _CommunityMembersScreenState
    extends ConsumerState<CommunityMembersScreen> {
  Set<String> uids = {};
  int counter = 0;
  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void removeMember(String communityId, String userId) {
    ref
        .read(communityControllerProvider.notifier)
        .removeMember(communityId, userId);
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.id, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByIdProvider(widget.id)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (BuildContext context, int index) {
                final member = community.members[index];
                return ref.watch(getUserDataByIdProvider(member)).when(
                      data: (user) {
                        return user.id == community.admin
                            ? const SizedBox()
                            : ListTile(
                                title: Text(user.name.toString()),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    user.profilePicture,
                                  ),
                                ),
                                trailing: Container(
                                  width: 80,
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      community.admin == user.id
                                          ? removeMember(community.id, user.id)
                                          : null;
                                    },
                                    child: Text(
                                      community.admin == user.id
                                          ? 'Remove'
                                          : 'Report',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
