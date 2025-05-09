import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:epson_epos/charset/charset.dart';
import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

final logger = Logger();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EpsonPrinterModel> printers = [];

  // Define an encode to support print the specified language
  Uint8List useEncode(String text) {
    return tcvn.encode(text);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EPSON ePOS'),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ElevatedButton(
              //     onPressed: () => onDiscovery(EpsonEPOSPortType.TCP),
              //     child: Text('Discovery TCP')),
              // ElevatedButton(
              //     onPressed: () => onDiscovery(EpsonEPOSPortType.USB),
              //     child: Text('Discovery USB')),
              ElevatedButton(
                  onPressed: () => onDiscovery(EpsonEPOSPortType.BLUETOOTH),
                  child: Text('Discovery Bluetooth')),
              // ElevatedButton(
              //     onPressed: () => onDiscovery(EpsonEPOSPortType.ALL),
              ElevatedButton(
                  onPressed: () => onBleRequestPermission(),
                  child: Text(
                      'Request runtime permission')), //     child: Text('Discovery All')),
              ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  final printer = printers[index];
                  return Column(
                    children: [
                      Text('${printer.model} | ${printer.series}'),
                      Text('${printer.ipAddress}'),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              //onSetPrinterSetting(printer);
                              onPrintTest(printer);
                            },
                            child: Text('Print Test'),
                          ),
                          TextButton(
                            onPressed: () {
                              onPrintTest(printer);
                            },
                            child: Text('Print Raw Text'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                itemCount: printers.length,
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              )
            ],
          ),
        )),
      ),
    );
  }

  onDiscovery(EpsonEPOSPortType type) async {
    try {
      List<EpsonPrinterModel>? data = await EpsonEPOS.onDiscovery(type: type);
      logger.d('Did discover ${data?.length}');
      if (data != null && data.length > 0) {
        data.forEach((element) {
          logger.d(element.toJson());
        });
        setState(() {
          printers = data;
        });
      } else {
        setState(() {
          printers = [];
        });
      }
    } catch (e) {
      logger.e("Error: " + e.toString());
    }
  }

  void onSetPrinterSetting(EpsonPrinterModel printer) async {
    try {
      await EpsonEPOS.setPrinterSetting(printer, paperWidth: 80);
    } catch (e) {
      logger.e("Error: " + e.toString());
    }
  }

  Future<List<int>> _customEscPos() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    generator.setGlobalCodeTable('TCVN-3-1');

    // bytes += generator.text(
    //     'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
    //     styles: const PosStyles(codeTable: 'CP1252'));
    // bytes += generator.text('Special 2: blåbærgrød',
    //     styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.textEncoded(
        useEncode('Thoát nghe tim đập rộn ràng Cất lên tiếng,'),
        styles: const PosStyles(bold: true));
    // bytes +=
    //     generator.text('Reverse text', styles: const PosStyles(reverse: true));
    // bytes += generator.text('Underlined text',
    //     styles: const PosStyles(underline: true), linesAfter: 1);
    // bytes += generator.text('Align left',
    //     styles: const PosStyles(align: PosAlign.left));

    bytes += generator.setStyles(const PosStyles(align: PosAlign.center));
    bytes += generator.textEncoded(useEncode('hồ Đây Than Thở ngất đây'));

    // bytes += generator.text('Align right',
    //     styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
    // bytes += generator.qrcode('Barcode by escpos',
    //     size: QRSize.Size4, cor: QRCorrection.H);
    // bytes += generator.feed(2);
    bytes += generator.barcode(Barcode.code128('barcodeData'.split('')));
    // bytes += generator.row([
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: const PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col6',
    //     width: 6,
    //     styles: const PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: const PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);

    // bytes += generator.text('Text size 200%',
    //     styles: const PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));
    String base64String = base64Encode(bytes);

    bytes += generator.reset();

    return bytes;
  }

  void onPrintRaw(EpsonPrinterModel printer) async {
    EpsonEPOSCommand command = EpsonEPOSCommand();
    List<Map<String, dynamic>> commands = [];
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
    commands.add(command.addTextFont(EpsonEPOSFont.FONT_B));
    // commands.add(command.addFeedLine(1));
    commands.add(command.addTextStyle(bold: true));
    commands
        .add(command.append('Đây bước chân kẻ phong trần Lang thang cõi\n'));
    commands.add(command.addTextStyle(bold: false));
    // commands.add(command.append('ÀẢÃÁẠẶẬÈẺẼÉẸỆÌỈĨÍỊÒỎÕÓỌỘỜỞỠỚỢÙỦŨ ĂÂÊÔƠƯĐ\n'));
    commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
    commands.add(command.addFeedLine(1));
    commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
  }

  void onPrintTest(EpsonPrinterModel printer) async {
    EpsonEPOSCommand command = EpsonEPOSCommand();
    List<Map<String, dynamic>> commands = [];
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
    commands.add(command.addTextFont(EpsonEPOSFont.FONT_B));
    // commands.add(command.addFeedLine(1));
    commands.add(command.addTextStyle(bold: true));
    commands
        .add(command.append('Đây bước chân kẻ phong trần Lang thang cõi\n'));
    commands.add(command.addTextStyle(bold: false));
    // commands.add(command.append('ÀẢÃÁẠẶẬÈẺẼÉẸỆÌỈĨÍỊÒỎÕÓỌỘỜỞỠỚỢÙỦŨ ĂÂÊÔƠƯĐ\n'));
    // commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
    commands.add(command.addFeedLine(1));
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.CENTER));
    commands.add(command.addBarcode(
      barcode: '0000081002345',
      type: Epos2Barcode.EPOS2_BARCODE_EAN13,
      position: Epos2Hri.EPOS2_HRI_ABOVE,
      font: EpsonEPOSFont.FONT_B,
    ));
    commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
    final response = await EpsonEPOS.onPrint(printer, commands);
    logger.d(response.toString());
  }

  void onBleRequestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
    logger.d(statuses[Permission.bluetooth]);
  }
}
