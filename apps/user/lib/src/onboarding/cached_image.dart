import 'dart:io';

import 'package:flutter/widgets.dart';

/// Loads [url] over HTTP and keeps the bytes in the temp directory.
///
/// Widget tests skip the request (`FLUTTER_TEST`) so a capture stays on the
/// design placeholder instead of waiting on the network. A failed load shows
/// [fallback].
class KsCachedImage extends StatefulWidget {
  const KsCachedImage({
    super.key,
    required this.url,
    required this.fallback,
    this.fit = BoxFit.cover,
  });

  final String url;
  final Widget fallback;
  final BoxFit fit;

  @override
  State<KsCachedImage> createState() => _KsCachedImageState();
}

class _KsCachedImageState extends State<KsCachedImage> {
  File? _file;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      _failed = true;
      return;
    }
    _load();
  }

  Future<void> _load() async {
    try {
      final name = _cacheKey(widget.url);
      final dir = Directory('${Directory.systemTemp.path}/kinkstar-images');
      await dir.create(recursive: true);
      final file = File('${dir.path}/$name');
      if (!file.existsSync() || file.lengthSync() == 0) {
        final client = HttpClient();
        try {
          final request = await client.getUrl(Uri.parse(widget.url));
          final response = await request.close();
          if (response.statusCode != 200) {
            throw HttpException('status ${response.statusCode}');
          }
          final bytes = await response.fold<List<int>>(
            <int>[],
            (previous, chunk) => previous..addAll(chunk),
          );
          await file.writeAsBytes(bytes, flush: true);
        } finally {
          client.close();
        }
      }
      if (!mounted) return;
      setState(() => _file = file);
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;
    if (file == null || _failed) return widget.fallback;
    return Image.file(
      file,
      fit: widget.fit,
      errorBuilder: (_, _, _) => widget.fallback,
    );
  }
}

String _cacheKey(String url) {
  var hash = 0;
  for (final unit in url.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return hash.toString();
}
