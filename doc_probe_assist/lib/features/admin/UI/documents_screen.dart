import 'dart:typed_data';

import 'package:doc_probe_assist/features/admin/bloc/admin_bloc.dart';
import 'package:doc_probe_assist/models/directory_model.dart';
import 'package:doc_probe_assist/models/document_model.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final adminBloc = sl.get<AdminBloc>();
    List<Document> allDocs = [];
    List<Document> requestedDocs = [];
    List<MyDirectory> allDirectory = [];

    return BlocConsumer<AdminBloc, AdminState>(
      bloc: adminBloc,
      buildWhen: (previous, current) => current is! AdminActionState,
      listenWhen: (previous, current) => current is AdminActionState,
      listener: (context, state) {
        if (state is UploadDocumentFailedState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Document Uplod Failed. Please try Again Later.'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ok',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 10),
                    ))
              ],
            ),
          );
        } else if (state is CreateDirectoryFailedState) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Directory create Failed. Please try Again Later.'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ok',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 10),
                    ))
              ],
            ),
          );
        } else if (state is DirectoryDeleteFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Problem deleting this directory'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Ok'))
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is AdminInitial) {
          adminBloc.add(AllDocumentFetchEvent());
          adminBloc.add(RequestedDocumentFetchEvent());
        } else if (state is UploadDocumentSuccessState) {
          allDocs.add(state.document);
        } else if (state is DocumentLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DocumentLoadingSuccessState) {
          allDocs = state.documents['all_doc']!;
          requestedDocs = state.documents['req_doc']!;
          allDirectory = state.directories;
        } else if (state is CreateDirectorySuccessState) {
          Navigator.pop(context);
          allDirectory.add(state.directory);
        } else if (state is DocumentLoadingFailedState) {
          return AlertDialog(
            content:
                const Text('Something went wrong. Please Try again later.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Ok'))
            ],
          );
        } else if (state is DocumentDeleteState) {
          allDocs.removeAt(
              allDocs.indexWhere((element) => element.id == state.document.id));
        } else if (state is DocumentDeleteFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Problem deleting this document'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Ok'))
                ],
              );
            },
          );
        } else if (state is DirectoryDeleteState) {
          allDirectory.removeAt(allDirectory
              .indexWhere((element) => element.id == state.directory.id));
        } else if (state is DocumentApprovedState) {
          allDocs.add(state.document);
          requestedDocs.removeAt(requestedDocs
              .indexWhere((element) => element.id == state.document.id));
        } else if (state is DocumentApproveFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Problem approving this document'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Ok'))
                ],
              );
            },
          );
        } else if (state is UploadDocumentSuccessState) {
          allDocs.add(state.document);
        }
        return Column(
          children: [
            TabBar(
              tabs: [
                Text(
                  "Requested Documents",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "All Documents",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Directories",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
              controller: _tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  DocumentTab(
                    docs: requestedDocs,
                    isRequested: true,
                    adminBloc: adminBloc,
                    dirs: allDirectory,
                  ),
                  DocumentTab(
                    docs: allDocs,
                    adminBloc: adminBloc,
                    dirs: allDirectory,
                  ),
                  DirectoryTab(
                    directories: allDirectory,
                    adminBloc: adminBloc,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class DirectoryTab extends StatelessWidget {
  const DirectoryTab(
      {super.key, required this.directories, required this.adminBloc});

  final List<MyDirectory> directories;
  final AdminBloc adminBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController directoryNameTextEditingController =
        TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Create Directory"),
                          content: SizedBox(
                            width: 300,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller:
                                      directoryNameTextEditingController,
                                  decoration: const InputDecoration(
                                    labelText: "Enter Directory Name:",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  adminBloc.add(
                                      CreateDirectoryButtonClickedEvent(
                                          name:
                                              directoryNameTextEditingController
                                                  .text));
                                },
                                child: const Text("Create")),
                            TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("Cancel")),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('+ Create Directory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  )),
              Card(
                elevation: 10,
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: Text("Sr No."),
                    ),
                    const DataColumn(
                      label: SizedBox(
                          width: 200,
                          child: Text(
                            "Directory Name",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )),
                    ),
                    const DataColumn(
                      label: Text(" "),
                    ),
                  ],
                  rows: directories
                      .asMap()
                      .entries
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              Text((e.key + 1).toString()),
                            ),
                            DataCell(
                              Text(e.value.dirName),
                            ),
                            DataCell(IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Directory"),
                                    content: Text(
                                        "Sure want to Delete Directory ${e.value.dirName}?"),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            adminBloc.add(DeleteDirectoryEvent(
                                                directiry: e.value));

                                            context.pop();
                                          },
                                          child: const Text(
                                            "Delete",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      ElevatedButton(
                                          onPressed: () => context.pop(),
                                          child: const Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete_rounded),
                              color: Colors.red,
                            )),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DocumentTab extends StatelessWidget {
  const DocumentTab(
      {super.key,
      required this.docs,
      this.isRequested = false,
      required this.adminBloc,
      required this.dirs});

  final List<Document> docs;
  final List<MyDirectory> dirs;
  final bool isRequested;
  final AdminBloc adminBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController documentNameTextEditingController =
        TextEditingController();
    FilePickerResult? result;

    int? selectedDirectory;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                !isRequested
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       var fileName = 'No File Choosen';
                                //       Uint8List? file;
                                //       return BlocConsumer<AdminBloc,
                                //           AdminState>(
                                //         bloc: adminBloc,
                                //         listener: (context, state) {},
                                //         builder: (context, state) {
                                //           if (state
                                //               is NewDocumentSelectedState) {
                                //             fileName = state.fileName;
                                //             file = state.file;
                                //           }

                                //           if (state
                                //               is UploadDocumentFailedState) {
                                //             return AlertDialog(
                                //               content: Text(
                                //                   'Document Uploded Failed. Please try Again Later.'),
                                //               actions: [
                                //                 ElevatedButton(
                                //                     onPressed: () {
                                //                       Navigator.of(context)
                                //                           .pop();
                                //                     },
                                //                     child: Text(
                                //                       'Ok',
                                //                       style: Theme.of(context)
                                //                           .textTheme
                                //                           .titleMedium
                                //                           ?.copyWith(
                                //                               fontSize: 10),
                                //                     ))
                                //               ],
                                //             );
                                //           }
                                //           return AlertDialog(
                                //             title:
                                //                 const Text("Upload Document"),
                                //             content: SizedBox(
                                //               width: 300,
                                //               child: Column(
                                //                 mainAxisSize: MainAxisSize.min,
                                //                 children: [
                                //                   TextField(
                                //                     controller:
                                //                         documentNameTextEditingController,
                                //                     decoration:
                                //                         const InputDecoration(
                                //                       labelText:
                                //                           "Enter Document Name:",
                                //                     ),
                                //                   ),
                                //                   SizedBox(
                                //                     height: 20,
                                //                   ),
                                //                   Row(
                                //                     children: [
                                //                       SizedBox(
                                //                           width: 150,
                                //                           child: Text(fileName,
                                //                               overflow:
                                //                                   TextOverflow
                                //                                       .ellipsis)),
                                //                       SizedBox(
                                //                         width: 20,
                                //                       ),
                                //                       ElevatedButton(
                                //                           onPressed: () async {
                                //                             result =
                                //                                 await FilePicker
                                //                                     .platform
                                //                                     .pickFiles(
                                //                               type: FileType
                                //                                   .custom,
                                //                               allowedExtensions: [
                                //                                 'pdf'
                                //                               ],
                                //                             );
                                //                             if (result !=
                                //                                 null) {
                                //                               var _paths =
                                //                                   result!.files
                                //                                       .first;
                                //                               adminBloc.add(
                                //                                   NewDocumentSelectedEvent(
                                //                                       file: _paths
                                //                                           .bytes!,
                                //                                       name: _paths
                                //                                           .name));
                                //                             } else {
                                //                               // User canceled the picker
                                //                               print(
                                //                                   'result null');
                                //                             }
                                //                           },
                                //                           child: Text(
                                //                             'Choose File',
                                //                             style: Theme.of(
                                //                                     context)
                                //                                 .textTheme
                                //                                 .displayMedium
                                //                                 ?.copyWith(
                                //                                     fontSize:
                                //                                         10),
                                //                           ))
                                //                     ],
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //             actions: [
                                //               TextButton(
                                //                   onPressed: () {
                                //                     if (file != null) {
                                //                       adminBloc.add(
                                //                           UploadDocumentButtonClickedEvent(
                                //                               file: file,
                                //                               name: fileName));
                                //                     } else {
                                //                       print('file null');
                                //                     }

                                //                     Navigator.of(context).pop();
                                //                   },
                                //                   child: const Text("Upload")),
                                //               TextButton(
                                //                   onPressed: () {
                                //                     Navigator.of(context).pop();
                                //                   },
                                //                   child: const Text("Cancel")),
                                //             ],
                                //           );
                                //         },
                                //       );
                                //     });
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    var fileName = 'No File Choosen';
                                    Uint8List? file;
                                    return AlertDialog(
                                      title: const Text("Upload Document"),
                                      content: SizedBox(
                                        width: 300,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            DropdownSearch<MyDirectory>(
                                              clearButtonProps:
                                                  ClearButtonProps(
                                                      icon: Icon(Icons.cancel),
                                                      isVisible: true),
                                              popupProps: const PopupProps.menu(
                                                fit: FlexFit.loose,
                                                showSearchBox: true,
                                              ),
                                              onChanged: (value) =>
                                                  selectedDirectory = value?.id,
                                              items: dirs,
                                              itemAsString: (item) =>
                                                  item.dirName,
                                              filterFn: (item, filter) {
                                                return item.dirName
                                                    .startsWith(filter);
                                              },
                                              dropdownDecoratorProps:
                                                  const DropDownDecoratorProps(
                                                dropdownSearchDecoration:
                                                    InputDecoration(
                                                        labelText:
                                                            "Add to Directory",
                                                        labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Color.fromARGB(
                                                              255, 1, 49, 121),
                                                        ),
                                                        contentPadding:
                                                            EdgeInsets.zero),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                    width: 150,
                                                    child: BlocBuilder<
                                                        AdminBloc, AdminState>(
                                                      bloc: adminBloc,
                                                      buildWhen: (previous,
                                                              current) =>
                                                          current
                                                              is NewDocumentSelectedState,
                                                      builder:
                                                          (context, state) {
                                                        return Text(fileName,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis);
                                                      },
                                                    )),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      result = await FilePicker
                                                          .platform
                                                          .pickFiles(
                                                        type: FileType.custom,
                                                        allowedExtensions: [
                                                          'pdf'
                                                        ],
                                                      );
                                                      if (result != null) {
                                                        var fileObject =
                                                            result!.files.first;
                                                        fileName =
                                                            fileObject.name;
                                                        file = fileObject.bytes;
                                                        adminBloc.add(
                                                            NewDocumentSelectedEvent(
                                                                file: file!,
                                                                name:
                                                                    fileName));
                                                        // // sl.get<ChatRepository>().uploadDocument(
                                                        // //     _paths.bytes!, _paths.name);
                                                      } else {
                                                        // User canceled the picker
                                                        print('result null');
                                                      }
                                                    },
                                                    child: Text(
                                                      'Choose File',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium
                                                          ?.copyWith(
                                                              fontSize: 10),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              if (file != null) {
                                                adminBloc.add(
                                                    UploadDocumentButtonClickedEvent(
                                                        file: file,
                                                        dirId:
                                                            selectedDirectory,
                                                        name: fileName));
                                                file = null;
                                                documentNameTextEditingController
                                                    .text = "";
                                                fileName =
                                                    "No Document Selected";
                                                context.pop();
                                              } else {
                                                print('file null');
                                              }

                                              // Navigator.of(context).pop();
                                            },
                                            child: const Text("Upload")),
                                        TextButton(
                                            onPressed: () {
                                              context.pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('+ Add Document'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              )),
                        ],
                      )
                    : SizedBox(),
                Card(
                  elevation: 10,
                  child: DataTable(
                    columns: [
                      const DataColumn(
                        label: Text("Sr No."),
                      ),
                      const DataColumn(
                        label: Text("Emp ID"),
                      ),
                      const DataColumn(
                        label: Text("Date"),
                      ),
                      const DataColumn(
                        label: SizedBox(
                            width: 200,
                            child: Text(
                              "Document Name",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )),
                      ),
                      DataColumn(label: const Text("Directory")),
                      DataColumn(
                        label: !isRequested
                            ? const Text("Status")
                            : const SizedBox(
                                width: 1,
                              ),
                      ),
                      const DataColumn(
                        label: Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Link",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(" "),
                      ),
                    ],
                    rows: docs
                        .asMap()
                        .entries
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Text((e.key + 1).toString()),
                              ),
                              DataCell(
                                Text(e.value.empId),
                              ),
                              DataCell(
                                Text(e.value.time),
                              ),
                              DataCell(
                                SizedBox(
                                    width: 200,
                                    child: Text(
                                      e.value.docName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                              ),
                              DataCell(
                                Text(e.value.directory ?? ''),
                              ),
                              DataCell(
                                !isRequested
                                    ? Text(e.value.embeddingStatus)
                                    : const SizedBox(
                                        width: 1,
                                      ),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    var uri = Uri.parse(e.value.url);
                                    await launchUrl(uri);
                                  },
                                  child: Text(
                                    "View",
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ),
                              ),
                              (isRequested)
                                  ? DataCell(Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            adminBloc.add(ApproveDocumentEvent(
                                                document: e.value));
                                          },
                                          icon: const Icon(Icons.check_sharp),
                                          color: Colors.green,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.close_sharp),
                                          color: Colors.red,
                                        )
                                      ],
                                    ))
                                  : DataCell(IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text("Delete Document"),
                                            content: Text(
                                                "Sure want to Delete Chat ${e.value.docName}?"),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    adminBloc.add(
                                                        DeleteDocumentEvent(
                                                            document: e.value));

                                                    context.pop();
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                              ElevatedButton(
                                                  onPressed: () =>
                                                      context.pop(),
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete_rounded),
                                      color: Colors.red,
                                    )),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
