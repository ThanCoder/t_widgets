// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

sealed class TImgSource {
  const TImgSource();
  String get key;
  ImageProvider get provider;

  const factory TImgSource.file(File file) = TImgFileSource;
  const factory TImgSource.network(String url) = TImgNetworkSource;
  const factory TImgSource.memory(Uint8List bytes) = TImgMemorySource;
}

class TImgFileSource extends TImgSource {
  final File file;
  final String? cacheKey;
  const TImgFileSource(this.file, {this.cacheKey});

  @override
  String get key => cacheKey ?? 'file:${file.path}';

  @override
  ImageProvider<Object> get provider => FileImage(file);
}

class TImgNetworkSource extends TImgSource {
  final String url;
  final String? cacheKey;
  const TImgNetworkSource(this.url, {this.cacheKey});

  @override
  String get key => cacheKey ?? 'network:$url';

  @override
  ImageProvider<Object> get provider => NetworkImage(url);
}

class TImgMemorySource extends TImgSource {
  final Uint8List bytes;
  final String? cacheKey;
  const TImgMemorySource(this.bytes, {this.cacheKey});

  @override
  String get key => cacheKey ?? 'memory:${bytes.length}';

  @override
  ImageProvider<Object> get provider => MemoryImage(bytes);
}

class TImgAssetSource extends TImgSource {
  final String assetName;
  final String? cacheKey;
  const TImgAssetSource(this.assetName, {this.cacheKey});

  @override
  String get key => cacheKey ?? 'asset:$assetName';

  @override
  ImageProvider<Object> get provider => AssetImage(assetName);
}
