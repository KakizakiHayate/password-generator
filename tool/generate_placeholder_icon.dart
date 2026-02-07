import 'dart:io';
import 'dart:typed_data';

/// 単色のPNGバイナリを生成する（外部依存なし）
Uint8List generatePng({
  required int width,
  required int height,
  required int r,
  required int g,
  required int b,
}) {
  final out = BytesBuilder();

  // PNG signature
  out.add([137, 80, 78, 71, 13, 10, 26, 10]);

  // IHDR chunk
  final ihdrData = BytesBuilder();
  ihdrData.add(_uint32(width));
  ihdrData.add(_uint32(height));
  ihdrData.addByte(8); // bit depth
  ihdrData.addByte(2); // color type: RGB
  ihdrData.addByte(0); // compression method
  ihdrData.addByte(0); // filter method
  ihdrData.addByte(0); // interlace method
  _writeChunk(out, 'IHDR', ihdrData.toBytes());

  // IDAT chunk - image data
  final rawData = BytesBuilder();
  for (var y = 0; y < height; y++) {
    rawData.addByte(0); // filter: none
    for (var x = 0; x < width; x++) {
      rawData.addByte(r);
      rawData.addByte(g);
      rawData.addByte(b);
    }
  }
  final compressed = zlib.encode(rawData.toBytes());
  _writeChunk(out, 'IDAT', Uint8List.fromList(compressed));

  // IEND chunk
  _writeChunk(out, 'IEND', Uint8List(0));

  return out.toBytes();
}

/// PNGファイルを指定パスに保存する
void saveIcon({
  required String outputPath,
  required int width,
  required int height,
  required int r,
  required int g,
  required int b,
}) {
  final bytes = generatePng(width: width, height: height, r: r, g: g, b: b);
  final file = File(outputPath);
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes);
}

/// PNGチャンクを書き込む
void _writeChunk(BytesBuilder out, String type, Uint8List data) {
  final typeBytes = type.codeUnits;
  out.add(_uint32(data.length));
  out.add(typeBytes);
  out.add(data);

  // CRC32 (type + data)
  final crcInput = BytesBuilder();
  crcInput.add(typeBytes);
  crcInput.add(data);
  out.add(_uint32(_crc32(crcInput.toBytes())));
}

/// 32bit big-endian バイト列
Uint8List _uint32(int value) {
  final data = ByteData(4);
  data.setUint32(0, value, Endian.big);
  return data.buffer.asUint8List();
}

/// CRC32の1バイト分の処理
int _crc32ProcessByte(int crc, int byte) {
  crc ^= byte;
  for (var i = 0; i < 8; i++) {
    crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
  }
  return crc;
}

/// CRC32計算（PNG仕様準拠）
int _crc32(Uint8List data) {
  var crc = 0xFFFFFFFF;
  for (final byte in data) {
    crc = _crc32ProcessByte(crc, byte);
  }
  return crc ^ 0xFFFFFFFF;
}

/// CLI実行用のmain関数
void main() {
  const outputPath = 'assets/icon/app_icon.png';
  saveIcon(
    outputPath: outputPath,
    width: 1024,
    height: 1024,
    r: 0,
    g: 122,
    b: 255,
  );
  // ignore: avoid_print
  print('Generated placeholder icon: $outputPath (1024x1024)');
}
