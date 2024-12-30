//
//  CommandsGenerator.swift
//  epson_epos
//
//  Created by Thomas on 11/08/2024.
//

import Foundation

public class CommandGenerator: NSObject {
    func onGenerateCommandFor(printer: Epos2Printer?, command: Dictionary<String, Any>) {
        guard let printer = printer else {
            return
        }
        //        Log.d(logTag, "onGenerateCommand: $command")
        
        guard let commandId = command["id"] as? String, commandId.isEmpty == false else {
            // Invalid commandId
            return
        }
        
        let commandValue = command["value"]
        
        switch commandId {
        case "appendText":
            guard let commandValue = commandValue as? String else { return }
            //                Log.d(logTag, "appendText: $commandValue")
            printer.addText(commandValue);
            
        case "printRawData":
            guard let commandValue = commandValue as? FlutterStandardTypedData
            else { return }
            let data = Data(commandValue.data)
            //                    Log.d(logTag, "printRawData")
            printer.addCommand(data)
            
        case "addImage":
            guard let commandValue = commandValue as? String else { return }
            guard let width = command["width"] as? Int, let height = command["height"] as? Int, let posX = command["posX"] as? Int, let posY = command["posY"] as? Int, let bitmap = convertBase64ToImage(commandValue) else { return }
            //                    Log.d(logTag, "appendBitmap: $width x $height $posX $posY bitmap $bitmap")
            printer.add(
                bitmap,
                x: posX,
                y: posY, width: width,
                height: height,
                color:EPOS2_COLOR_1.rawValue,
                mode:EPOS2_MODE_MONO.rawValue,
                halftone:EPOS2_HALFTONE_DITHER.rawValue,
                brightness:Double(EPOS2_PARAM_DEFAULT),
                compress:EPOS2_COMPRESS_AUTO.rawValue
            )
            
        case "addFeedLine":
            guard let commandValue = commandValue as? Int else { return }
            printer.addFeedLine(commandValue)
            
        case "addCut":
            guard let commandValue = commandValue as? String else { return }
            switch commandValue {
            case "CUT_FEED":
                printer.addCut(EPOS2_CUT_FEED.rawValue)
            case "EPOS2_CUT_FEED":
                printer.addCut(EPOS2_CUT_NO_FEED.rawValue)
            case "CUT_RESERVE":
                printer.addCut(EPOS2_CUT_RESERVE.rawValue)
            default:
                printer.addCut(EPOS2_PARAM_DEFAULT)
            }
            
        case "addLineSpace":
            guard let commandValue = commandValue as? Int else { return }
            printer.addFeedLine(commandValue)
            
        case "addTextAlign":
            guard let commandValue = commandValue as? String else { return }
            switch commandValue {
            case "LEFT":
                printer.addTextAlign(EPOS2_ALIGN_LEFT.rawValue)
                
            case "CENTER":
                printer.addTextAlign(EPOS2_ALIGN_CENTER.rawValue)
                
            case "RIGHT":
                printer.addTextAlign(EPOS2_ALIGN_RIGHT.rawValue)
                
            default:
                printer.addTextAlign(EPOS2_PARAM_DEFAULT)
            }
            
        case "addTextFont":
            guard let commandValue = commandValue as? String else { return }
            switch commandValue {
            case "FONT_A":
                printer.addTextFont(EPOS2_FONT_A.rawValue)
                
            case "FONT_B":
                printer.addTextFont(EPOS2_FONT_B.rawValue)
                
            case "FONT_C":
                printer.addTextFont(EPOS2_FONT_C.rawValue)
                
            case "FONT_D":
                printer.addTextFont(EPOS2_FONT_D.rawValue)
                
            case "FONT_E":
                printer.addTextFont(EPOS2_FONT_E.rawValue)
            default:
                break
            }
            
        case "addTextSmooth":
            guard let commandValue = commandValue as? Bool else { return }
            if commandValue {
                printer.addTextSmooth(EPOS2_TRUE)
            } else {
                printer.addTextSmooth(EPOS2_FALSE)
            }
            
        case "addTextSize":
            guard let width = command["width"] as? Int, let height = command["height"] as? Int else { return }
            //                Log.d(logTag, "setTextSize: width: $width, height: $height")
            printer.addTextSize(width, height: height)
            
        case "addTextStyle":
            var reverseValue = EPOS2_PARAM_DEFAULT
            if let reverse = command["reverse"] as? Bool {
                if (reverse == true) {
                    reverseValue = EPOS2_TRUE
                } else {
                    reverseValue = EPOS2_FALSE
                }
            }
            var ulValue = EPOS2_PARAM_DEFAULT
            if let ul = command["ul"] as? Bool {
                if (ul) {
                    ulValue = EPOS2_TRUE
                } else {
                    ulValue = EPOS2_FALSE
                }
            }
            
            var emValue = EPOS2_PARAM_DEFAULT
            if let em = command["em"] as? Bool {
                if (em) {
                    emValue = EPOS2_TRUE
                } else {
                    emValue = EPOS2_FALSE
                }
            }
            var colorValue = EPOS2_PARAM_DEFAULT
            if let color = command["color"] as? String {
                switch color {
                case "COLOR_NONE":
                    colorValue = EPOS2_COLOR_NONE.rawValue
                case "COLOR_1":
                    colorValue = EPOS2_COLOR_1.rawValue
                case "COLOR_2":
                    colorValue = EPOS2_COLOR_2.rawValue
                case "COLOR_3":
                    colorValue = EPOS2_COLOR_3.rawValue
                case "COLOR_4":
                    colorValue = EPOS2_COLOR_4.rawValue
                default:
                    break
                }
                
                printer.addTextStyle(reverseValue, ul: ulValue, em: emValue, color: colorValue)
            }
            
        case "addBarcode":
            var barcodeWidth = 2
            if let width = command["width"] as? Int {
                barcodeWidth = width
            }
            var barcodeHeight = 100
            if let height = command["height"] as? Int {
                barcodeHeight = height
            }
            var barcode = ""
            if let code = command["barcode"] as? String {
                barcode = code
            }
            var type = EPOS2_BARCODE_EAN13.rawValue
            if let codeType = command["type"] as? Int {
                type = Int32(codeType)
            }
            var textPosition = EPOS2_HRI_BELOW.rawValue
            if let position = command["position"] as? Int {
                textPosition = Int32(position)
            }
            var font = EPOS2_FONT_A.rawValue
            var fontValue = command["font"] as? String
            switch fontValue {
            case "FONT_A":
                font = EPOS2_FONT_A.rawValue
                
            case "FONT_B":
                font = EPOS2_FONT_B.rawValue
                
            case "FONT_C":
                font = EPOS2_FONT_C.rawValue
                
            case "FONT_D":
                font = EPOS2_FONT_D.rawValue
                
            case "FONT_E":
                font = EPOS2_FONT_E.rawValue
            default:
                break
            }
            
            printer.addBarcode(
                barcode,
                type: type,
                hri: textPosition,
                font: font,
                width:barcodeWidth,
                height:barcodeHeight
            )
            
        case "addKick":
            let drawerPin: Int = (command["drawerPin"] as? Int) ?? 0
            let pulseOn: Int = (command["pulseOn"] as? Int) ?? 100
            let pulseOff: Int = (command["pulseOff"] as? Int) ?? 100
            printer.addPulse(drawerPin, time: EPOS2_PULSE_100MS.rawValue * pulseOn / 100)

        default:
            print("Command not supported \(commandId)")
            break
        }
    }
}

private extension CommandGenerator {
    func convertBase64ToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
