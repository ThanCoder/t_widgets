import 'dart:io';

import 'package:flutter/material.dart';
import 'package:t_widgets/src/old_widgets/downloader/default_downloader.dart';
import 'package:t_widgets/src/old_widgets/functions/default_chooser_func.dart';
import 'package:t_widgets/t_widgets.dart';

String? initialDirectory;

class TCoverChooser extends StatefulWidget {
  final String coverPath;
  final VoidCallback? onChanged;
  final void Function()? onDeleted;
  const TCoverChooser({
    super.key,
    required this.coverPath,
    this.onChanged,
    this.onDeleted,
  });

  @override
  State<TCoverChooser> createState() => _TCoverChooserState();
}

class _TCoverChooserState extends State<TCoverChooser> {
  late File imageFile;

  @override
  void initState() {
    imageFile = File(widget.coverPath);
    super.initState();
    init();
  }

  @override
  void dispose() {
    downloadCancelToken.cancel();
    super.dispose();
  }

  bool isLoading = false;
  final downloadCancelToken = DownloadToken();

  Future<void> init() async {
    // try {} catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _showMenu,
        child: SizedBox(
          width: 150,
          height: 150,
          child: isLoading
              ? Center(child: TLoader.random())
              : TImageFile(path: imageFile.path, borderRadius: 5),
        ),
      ),
    );
  }

  void _showMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          onTap: () {
            Navigator.pop(context);
            _addFromPath();
          },
          leading: const Icon(Icons.add),
          title: const Text('Add From Path'),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            _downloadUrl();
          },
          leading: const Icon(Icons.add),
          title: const Text('Add From Url'),
        ),
        if (imageFile.existsSync())
          ListTile(
            onTap: () {
              Navigator.pop(context);
              _delete();
            },
            iconColor: Colors.red,
            leading: const Icon(Icons.delete_forever_rounded),
            title: const Text('Delete'),
          ),
      ],
    );
  }

  void _downloadUrl() {
    showDialog(
      context: context,
      builder: (context) => TRenameDialog(
        autofocus: true,
        renameLabelText: const Text('Image Direct Url'),
        submitText: 'Download',
        cancelText: 'Close',
        text: '',
        hintText: 'http***....',
        textInputType: TextInputType.url,
        onCheckIsError: (text) {
          if (!text.startsWith('http')) {
            return 'url required!';
          }
          return null;
        },
        onSubmit: (url) async {
          try {
            setState(() {
              isLoading = true;
            });
            if (TWidgets.instance.onCustomDownloadImage != null) {
              await TWidgets.instance.onCustomDownloadImage!(
                url,
                widget.coverPath,
              );
            } else {
              // default
              await downloadFileDefaultFun(
                url,
                imageFile.path,
                onProgress: (double progress) {},
                cancelToken: downloadCancelToken,
                onDownloaded: () {
                  if (!mounted) return;
                  setState(() {});
                },
                onError: (error) {
                  if (!mounted) return;
                  setState(() {});
                },
              );
            }

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!();
            }
          } catch (e) {
            TWidgets.showDebugLog(e.toString());
            if (!mounted) return;
            setState(() {
              isLoading = false;
            });
          }
        },
      ),
    );
  }

  void _addFromPath() async {
    try {
      setState(() {
        isLoading = true;
      });
      // default chooser
      String? path;
      // check custom image chooser
      if (TWidgets.instance.onOpenImageFileChooser != null) {
        // custom
        path = await TWidgets.instance.onOpenImageFileChooser!(
          initialDirectory: initialDirectory,
        );
      } else {
        // default
        path = await getDefaultImageChooser(initialDirectory: initialDirectory);
      }

      if (path != null) {
        final file = File(path);
        initialDirectory = file.parent.path;

        if (widget.coverPath.isNotEmpty) {
          await file.copy(widget.coverPath);
          // clear image cache
          await TAppServices.clearAndRefreshImage();
        }
        imageFile = File(path);
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (widget.onChanged != null) {
        widget.onChanged!();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      TWidgets.showDebugLog(e.toString());
    }
  }

  void _delete() async {
    if (!await imageFile.exists()) return;
    try {
      setState(() {
        isLoading = true;
      });

      await imageFile.delete();
      await TAppServices.clearAndRefreshImage();

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (widget.onChanged != null) {
        widget.onChanged!();
      }
    } catch (e) {
      TWidgets.showDebugLog(e.toString());
    }
  }
}
