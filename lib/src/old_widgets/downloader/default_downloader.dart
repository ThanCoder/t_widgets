import 'dart:async';
import 'dart:io';

// final tokens = <String, DownloadToken>{};

// Future<void> startDownload(String id, String url, String path) async {
//   final token = DownloadToken();
//   tokens[id] = token;
//   try {
//     await downloadFileDefaultFun(
//       url,
//       path,
//       cancelToken: token,
//       onProgress: (progress) {
//         print('$id: $progress');
//       },
//     );
//   } finally {
//     tokens.remove(id);
//   }
// }

// void cancelDownload(String id) {
//   tokens[id]?.cancel();
// }

class DownloadToken {
  bool _isCancelled = false;

  void Function()? _onCancel;

  bool get isCancelled => _isCancelled;

  void cancel() {
    if (_isCancelled) return;

    _isCancelled = true;
    _onCancel?.call();
  }
  

  void _attach(void Function() onCancel) {
    _onCancel = onCancel;

    // attach လုပ်တဲ့အချိန်မှာ cancel လုပ်ပြီးသားဖြစ်နေရင်
    if (_isCancelled) {
      _onCancel?.call();
    }
  }

  void _detach() {
    _onCancel = null;
  }
}

Future<void> downloadFileDefaultFun(
  String url,
  String savePath, {
  DownloadToken? cancelToken,
  void Function(double progress)? onProgress,
  void Function()? onDownloaded,
  void Function(String error)? onError,
}) async {
  final client = HttpClient();
  final tempFile = File('$savePath.tmp');

  HttpClientRequest? request;
  StreamSubscription<List<int>>? subscription;
  IOSink? sink;

  try {
    if (await tempFile.exists()) {
      await tempFile.delete();
    }

    request = await client.getUrl(Uri.parse(url));

    // CancelToken -> request + stream cancel
    cancelToken?._attach(() {
      request?.abort();

      final sub = subscription;
      if (sub != null) {
        unawaited(sub.cancel());
      }
    });

    if (cancelToken?.isCancelled == true) {
      request.abort();
      return;
    }

    final response = await request.close();

    if (cancelToken?.isCancelled == true) {
      await response.drain<void>();
      return;
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = 'Server Error: ${response.statusCode}';

      onError?.call(error);

      await response.drain<void>();

      return;
    }

    final total = response.contentLength;
    var received = 0;

    sink = tempFile.openWrite();

    final completer = Completer<void>();

    subscription = response.listen(
      (chunk) {
        if (cancelToken?.isCancelled == true) {
          return;
        }

        received += chunk.length;

        sink!.add(chunk);

        if (total > 0) {
          final progress = received / total;

          onProgress?.call(progress.clamp(0.0, 1.0));
        }
      },
      onDone: () async {
        try {
          // Download cancel ဖြစ်သွားရင် temp file ပဲဖျက်
          if (cancelToken?.isCancelled == true) {
            await sink?.close();
            sink = null;

            if (await tempFile.exists()) {
              await tempFile.delete();
            }

            if (!completer.isCompleted) {
              completer.complete();
            }

            return;
          }

          await sink?.flush();
          await sink?.close();
          sink = null;

          final saveFile = File(savePath);

          await saveFile.parent.create(recursive: true);

          if (await saveFile.exists()) {
            await saveFile.delete();
          }

          await tempFile.rename(savePath);

          onProgress?.call(1.0);
          onDownloaded?.call();

          if (!completer.isCompleted) {
            completer.complete();
          }
        } catch (e, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(e, stackTrace);
          }
        }
      },
      onError: (Object error, StackTrace stackTrace) async {
        try {
          await sink?.close();
        } catch (_) {}

        sink = null;

        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (_) {}
        }

        // Cancel ဖြစ်တာကို error အဖြစ် မပြချင်
        if (cancelToken?.isCancelled != true) {
          onError?.call('Download Error: $error');
        }

        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      cancelOnError: true,
    );

    await completer.future;
  } catch (e, stackTrace) {
    try {
      await subscription?.cancel();
    } catch (_) {}

    try {
      await sink?.close();
    } catch (_) {}

    if (await tempFile.exists()) {
      try {
        await tempFile.delete();
      } catch (_) {}
    }

    // Cancel ကို error မလုပ်
    if (cancelToken?.isCancelled != true) {
      onError?.call('Download Error: $e');
      Error.throwWithStackTrace(e, stackTrace);
    }
  } finally {
    cancelToken?._detach();

    try {
      await subscription?.cancel();
    } catch (_) {}

    try {
      await sink?.close();
    } catch (_) {}

    client.close(force: true);
  }
}
