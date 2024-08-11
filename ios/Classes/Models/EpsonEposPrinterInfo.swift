//
//  EpsonEposPrinterInfo.swift
//  epson_epos
//
//  Created by Thomas on 09/08/2024.
//

import Foundation

public class EpsonEposPrinterInfo: NSObject, Codable {
    var ipAddress: String?
    var bdAddress: String?
    let macAddress: String
    var model: String?
    var type: String?
    var printType: String?
    var target: String?
    
    public init(ipAddress: String? = nil, bdAddress: String? = nil, macAddress: String, model: String? = nil, type: String? = nil, printType: String? = nil, target: String? = nil) {
        self.ipAddress = ipAddress
        self.bdAddress = bdAddress
        self.macAddress = macAddress
        self.model = model
        self.type = type
        self.printType = printType
        self.target = target
    }
    
    public static func printer(from deviceInfo: Epos2DeviceInfo) -> EpsonEposPrinterInfo? {
        if (deviceInfo.deviceName != nil && deviceInfo.deviceName.isEmpty == false) {
            var printer = EpsonEposPrinterInfo(
                ipAddress: deviceInfo.ipAddress,
                bdAddress: deviceInfo.bdAddress,
                macAddress: deviceInfo.macAddress,
                model: deviceInfo.deviceName,
                type: String(deviceInfo.deviceType),
                printType: String(deviceInfo.deviceType),
                target: deviceInfo.target
            )
            return printer
        }
        
        return nil
    }
}

//int deviceType;
//NSString *target;
//NSString *deviceName;
//NSString *ipAddress;
//NSString *macAddress;
//NSString *bdAddress;
//NSString *leBdAddress;

//EpsonEposPrinterInfo(
//  var ipAddress: String? = nil,
//  var bdAddress: String? = nil,
//  var macAddress: String? = nil,
//  var model: String? = nil,
//  var type: String? = nil,
//  var printType: String? = nil,
//  var target: String? =null
//)
