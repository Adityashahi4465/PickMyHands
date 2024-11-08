import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/firebase_constants.dart';
import '../../../core/utils/snackbar.dart';
import '../../../models/document_model.dart';
import '../../../routes/route_utils.dart';
import '../../../theme/font_provider.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/health_controlller.dart';

class SearchDocumentScreen extends ConsumerStatefulWidget {
  const SearchDocumentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchDocumentScreen> createState() =>
      _SearchDocumentScreenState();
}

class _SearchDocumentScreenState extends ConsumerState<SearchDocumentScreen> {
  String searchInput = '';

  void navigateToDocument(BuildContext context, String id) {
    Navigation.navigateDocument(context, id);
  }

  void deleteDocument(String id) {
    ref.read(healthControllerProvider.notifier).deleteDocument(id);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final fontSize = ref.watch(fontSizesProvider);

    print(searchInput);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: ((value) {
            setState(() {
              searchInput = value.toLowerCase();
            });
          }),
        ),
      ),
      body: searchInput != ''
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirebaseConstants.documentCollection)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    ),
                  );
                }
                print("docsssssssssssss ${snapshot.data!.docs}");
                snapshot.data!.docs.forEach((e) {
                  print("Document name: ${e['title'.toLowerCase()]}");
                  print("Search input: $searchInput");
                });
                final List result = snapshot.data!.docs
                    .where(
                      (e) =>
                          e['title'.toLowerCase()]
                              .toLowerCase()
                              .startsWith(searchInput.toLowerCase()) &&
                          (e['userId'] ==
                              user.id), // Add this condition for user-specific documents
                    )
                    .map((e) =>
                        DocumentModel.fromMap(e.data() as Map<String, dynamic>))
                    .toList();

                print("result: $result");

                return SizedBox(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        final DocumentModel document = result[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(document.document),
                          ),
                          title: Text('${document.title}'),
                          onTap: () {
                            navigateToDocument(context, document.id);
                          },
                          trailing: Container(
                            width: 80,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                deleteDocument(document.id);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: fontSize.subheadingSize,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            )
          : const Center(
              child: Text(
                'Start typing to search for anything..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
