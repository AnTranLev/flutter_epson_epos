//
//  PluginImplement.swift
//  epson_epos
//
//  Created by Thomas on 08/08/2024.
//

import Foundation
import Flutter
import Combine

class PluginImplement: NSObject {
    private var cancellable = Set<AnyCancellable>()
    
    fileprivate var printers: [EpsonEposPrinterInfo] = []
    fileprivate var filterOption: Epos2FilterOption = Epos2FilterOption()
    
    fileprivate var result: FlutterResult?
    
    private enum Constants {
        static let discoverLookupInterval = 7.0 // 7 seconds
    }
    
    override init() {
        filterOption.deviceType = EPOS2_TYPE_PRINTER.rawValue
    }
    
    public func onDiscovery(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        let response = Epos2Discovery.start(filterOption, delegate: self)
        
        var resp = EpsonEposPrinterResult.init(type: PluginMethods.onDiscovery.rawValue, success: false)
        if response != EPOS2_SUCCESS.rawValue {
            resp.message = MessageHelper.errorEpos(response, method: "start")
            return result(try? resp.toJSONString())
        }
        
        Timer.publish(every: Constants.discoverLookupInterval, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink(receiveValue: { [weak self] _ in
                // Stop discover
                Epos2Discovery.stop()
                
                guard let self = self, let result = self.result else {
                    return
                }
                
                // return the result
                var resp = EpsonEposPrinterResult.init(type: PluginMethods.onDiscovery.rawValue, success: true)
                resp.content = printers
                do {
                    let data = try resp.toJSONString()
                    result(data)
                } catch let error {
                    resp = EpsonEposPrinterResult.init(type: PluginMethods.onDiscovery.rawValue, success: true)
                    resp.success = false
                    resp.message = error.localizedDescription
                    result(try? resp.toJSONString())
                }
            })
            .store(in: &cancellable)
    }
    
    public func connectDevice() {
        Epos2Discovery.stop()
        printers.removeAll()
        
        let btConnection = Epos2BluetoothConnection()
        let BDAddress = NSMutableString()
        let result = btConnection?.connectDevice(BDAddress)
        if result == EPOS2_SUCCESS.rawValue {
//            delegate?.discoveryView(self, onSelectPrinterTarget: BDAddress as String)
//            delegate = nil
        }
        else {
            Epos2Discovery.start(filterOption, delegate:self)
//            printerView.reloadData()
        }
    }
    
    public func restartDiscovery(_ sender: AnyObject) {
        var result = EPOS2_SUCCESS.rawValue;
        
        while true {
            result = Epos2Discovery.stop()
            
            if result != EPOS2_ERR_PROCESSING.rawValue {
                if (result == EPOS2_SUCCESS.rawValue) {
                    break;
                }
                else {
//                    MessageView.showErrorEpos(result, method:"stop")
                    return;
                }
            }
        }
        
        printers.removeAll()
//        printerView.reloadData()

        result = Epos2Discovery.start(filterOption, delegate:self)
        if result != EPOS2_SUCCESS.rawValue {
//            MessageView.showErrorEpos(result, method:"start")
        }
    }
}

extension PluginImplement: Epos2DiscoveryDelegate {
    func onDiscovery(_ deviceInfo: Epos2DeviceInfo!) {
        guard let printer = EpsonEposPrinterInfo.printer(from: deviceInfo) else {
            return
        }
        var printerIndex = printers.firstIndex(where: { e in
            e.ipAddress == deviceInfo.ipAddress
        })
        
        if let index = printerIndex, index > -1 {
            printers[index] = printer
        } else {
            printers.append(printer)
        }
    }
}
