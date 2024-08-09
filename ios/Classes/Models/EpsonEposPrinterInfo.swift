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
    var success: Bool
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

//var printer = EpsonEposPrinterInfo(deviceInfo.ipAddress,  deviceInfo.bdAddress , deviceInfo.macAddress,  deviceInfo.deviceName , deviceInfo.deviceType.toString(), deviceInfo.deviceType.toString()  , deviceInfo.target)
