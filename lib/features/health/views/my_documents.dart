import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/font_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/health_controlller.dart';

class MyDocumentView extends ConsumerStatefulWidget {
  const MyDocumentView({super.key});

  @override
  ConsumerState<MyDocumentView> createState() => _MyDocumentViewState();
}

class _MyDocumentViewState extends ConsumerState<MyDocumentView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final fontsize = ref.watch(fontSizesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Documents',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: fontsize.headingSize,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigation.navigateSearchDocument(context);
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(userDocumentsProvider).when(
                  data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final document = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              document.document,
                            ),
                            radius: 24,
                          ),
                          title: Text(
                            document.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  fontSize: fontsize.subheadingSize + 4,
                                ),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                          ),
                          subtitle: Text(
                            document.description,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: fontsize.fontSize),
                          ),
                          onTap: () {
                            Navigation.navigateDocument(context, document.id);
                          },
                        );
                      },
                    ),
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.navigateCreateDocument(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
