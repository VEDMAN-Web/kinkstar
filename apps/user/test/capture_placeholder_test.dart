import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinkstar_user/src/app.dart';

import '../../../tool/capture_frame.dart';

void main() {
  testWidgets('writes a 780x1688 capture of the placeholder home', (
    tester,
  ) async {
    final file = await captureFrame(
      tester,
      widget: const ProviderScope(child: UserApp()),
      outputPath: '../../design/compare/U01_build.png',
    );
    final bytes = file.readAsBytesSync();
    expect(bytes[0], 0x89);
    final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
    final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
    expect(width, 780);
    expect(height, 1688);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
