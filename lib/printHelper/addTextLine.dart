import 'package:epson_epos/epson_epos.dart';
import 'package:epson_epos/layout/font_a_chars_per_line.dart';
import 'package:epson_epos/layout/space_between.dart';

const DEFAULT_PAPER_WIDTH = 80;

Map<String, dynamic> addTextLine(
    EpsonPrinterModel printer, SpaceBetweenParams params) {
  final printerCharsPerLinePerWidth = getFontACharsPerLine(printer.model ?? '');
  // final setting = await EpsonEPOS.getPrinterSetting(printer);

  final charsPerLine = printerCharsPerLinePerWidth[DEFAULT_PAPER_WIDTH] ?? 42;

  final text = spaceBetween((charsPerLine).ceil(), params);
  return EpsonEPOSCommand().append(text);
}
