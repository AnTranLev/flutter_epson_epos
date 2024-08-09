//
//  MessageHelper.swift
//  epson_epos
//
//  Created by Thomas on 08/08/2024.
//

import Foundation

class MessageHelper {
    class func errorEpos(_ resultCode: Int32, method: String) -> String {
        let msg = String(format: "%@\n%@\n\n%@\n%@\n",
                         NSLocalizedString("methoderr_errcode", comment:""),
                         getEposErrorText(resultCode),
                         NSLocalizedString("methoderr_method", comment:""),
                         method)
        return msg
    }
    
    class func errorEposBt(_ resultCode: Int32, method: String) -> String {
        let msg = String(format: "%@\n%@\n\n%@\n%@\n",
                         NSLocalizedString("methoderr_errcode", comment:""),
                         getEposBtErrorText(resultCode),
                         NSLocalizedString("methoderr_method", comment:""),
                         method)
        return msg
    }
    
    class func result(_ code: Int32, errMessage: String) -> String {
        var msg: String = ""
        
        if errMessage.isEmpty {
            msg = String(format:"%@\n%@\n",
                         NSLocalizedString("statusmsg_result", comment: ""),
                         getEposResultText(code))
        }
        else {
            msg = String(format:"%@\n%@\n\n%@\n%@\n",
                         NSLocalizedString("statusmsg_result", comment: ""),
                         getEposResultText(code),
                         NSLocalizedString("statusmsg_description", comment: ""),
                         errMessage)
        }
        
        return msg
    }
    
    class fileprivate func getEposErrorText(_ error : Int32) -> String {
        var errText = ""
        switch (error) {
        case EPOS2_SUCCESS.rawValue:
            errText = "SUCCESS"
            break
        case EPOS2_ERR_PARAM.rawValue:
            errText = "ERR_PARAM"
            break
        case EPOS2_ERR_CONNECT.rawValue:
            errText = "ERR_CONNECT"
            break
        case EPOS2_ERR_TIMEOUT.rawValue:
            errText = "ERR_TIMEOUT"
            break
        case EPOS2_ERR_MEMORY.rawValue:
            errText = "ERR_MEMORY"
            break
        case EPOS2_ERR_ILLEGAL.rawValue:
            errText = "ERR_ILLEGAL"
            break
        case EPOS2_ERR_PROCESSING.rawValue:
            errText = "ERR_PROCESSING"
            break
        case EPOS2_ERR_NOT_FOUND.rawValue:
            errText = "ERR_NOT_FOUND"
            break
        case EPOS2_ERR_IN_USE.rawValue:
            errText = "ERR_IN_USE"
            break
        case EPOS2_ERR_TYPE_INVALID.rawValue:
            errText = "ERR_TYPE_INVALID"
            break
        case EPOS2_ERR_DISCONNECT.rawValue:
            errText = "ERR_DISCONNECT"
            break
        case EPOS2_ERR_ALREADY_OPENED.rawValue:
            errText = "ERR_ALREADY_OPENED"
            break
        case EPOS2_ERR_ALREADY_USED.rawValue:
            errText = "ERR_ALREADY_USED"
            break
        case EPOS2_ERR_BOX_COUNT_OVER.rawValue:
            errText = "ERR_BOX_COUNT_OVER"
            break
        case EPOS2_ERR_BOX_CLIENT_OVER.rawValue:
            errText = "ERR_BOXT_CLIENT_OVER"
            break
        case EPOS2_ERR_UNSUPPORTED.rawValue:
            errText = "ERR_UNSUPPORTED"
            break
        case EPOS2_ERR_FAILURE.rawValue:
            errText = "ERR_FAILURE"
            break
        default:
            errText = String(format:"%d", error)
            break
        }
        return errText
    }
    
    class fileprivate func getEposBtErrorText(_ error : Int32) -> String {
        var errText = ""
        switch (error) {
        case EPOS2_BT_SUCCESS.rawValue:
            errText = "SUCCESS"
            break
        case EPOS2_BT_ERR_PARAM.rawValue:
            errText = "ERR_PARAM"
            break
        case EPOS2_BT_ERR_UNSUPPORTED.rawValue:
            errText = "ERR_UNSUPPORTED"
            break
        case EPOS2_BT_ERR_CANCEL.rawValue:
            errText = "ERR_CANCEL"
            break
        case EPOS2_BT_ERR_ALREADY_CONNECT.rawValue:
            errText = "ERR_ALREADY_CONNECT"
            break;
        case EPOS2_BT_ERR_ILLEGAL_DEVICE.rawValue:
            errText = "ERR_ILLEGAL_DEVICE"
            break
        case EPOS2_BT_ERR_FAILURE.rawValue:
            errText = "ERR_FAILURE"
            break
        default:
            errText = String(format:"%d", error)
            break
        }
        return errText
    }
    
    class fileprivate func getEposResultText(_ resultCode : Int32) -> String {
        var result = ""
        switch (resultCode) {
        case EPOS2_CODE_SUCCESS.rawValue:
            result = "PRINT_SUCCESS"
            break
        case EPOS2_CODE_PRINTING.rawValue:
            result = "PRINTING"
            break
        case EPOS2_CODE_ERR_AUTORECOVER.rawValue:
            result = "ERR_AUTORECOVER"
            break
        case EPOS2_CODE_ERR_COVER_OPEN.rawValue:
            result = "ERR_COVER_OPEN"
            break
        case EPOS2_CODE_ERR_CUTTER.rawValue:
            result = "ERR_CUTTER"
            break
        case EPOS2_CODE_ERR_MECHANICAL.rawValue:
            result = "ERR_MECHANICAL"
            break
        case EPOS2_CODE_ERR_EMPTY.rawValue:
            result = "ERR_EMPTY"
            break
        case EPOS2_CODE_ERR_UNRECOVERABLE.rawValue:
            result = "ERR_UNRECOVERABLE"
            break
        case EPOS2_CODE_ERR_FAILURE.rawValue:
            result = "ERR_FAILURE"
            break
        case EPOS2_CODE_ERR_NOT_FOUND.rawValue:
            result = "ERR_NOT_FOUND"
            break
        case EPOS2_CODE_ERR_SYSTEM.rawValue:
            result = "ERR_SYSTEM"
            break
        case EPOS2_CODE_ERR_PORT.rawValue:
            result = "ERR_PORT"
            break
        case EPOS2_CODE_ERR_TIMEOUT.rawValue:
            result = "ERR_TIMEOUT"
            break
        case EPOS2_CODE_ERR_JOB_NOT_FOUND.rawValue:
            result = "ERR_JOB_NOT_FOUND"
            break
        case EPOS2_CODE_ERR_SPOOLER.rawValue:
            result = "ERR_SPOOLER"
            break
        case EPOS2_CODE_ERR_BATTERY_LOW.rawValue:
            result = "ERR_BATTERY_LOW"
            break
        case EPOS2_CODE_ERR_TOO_MANY_REQUESTS.rawValue:
            result = "ERR_TOO_MANY_REQUESTS"
            break
        case EPOS2_CODE_ERR_REQUEST_ENTITY_TOO_LARGE.rawValue:
            result = "ERR_REQUEST_ENTITY_TOO_LARGE"
            break
        case EPOS2_CODE_ERR_INVALID_WINDOW.rawValue:
            result = "EPOS2_CODE_ERR_INVALID_WINDOW";
            break;
        case EPOS2_CODE_CANCELED.rawValue:
            result = "EPOS2_CODE_CANCELED";
            break;
        case EPOS2_CODE_ERR_RECOGNITION.rawValue:
            result = "EPOS2_CODE_ERR_RECOGNITION";
            break;
        case EPOS2_CODE_ERR_READ.rawValue:
            result = "EPOS2_CODE_ERR_READ";
            break;
        case EPOS2_CODE_ERR_PAPER_JAM.rawValue:
            result = "EPOS2_CODE_ERR_PAPER_JAM";
            break;
        case EPOS2_CODE_ERR_PAPER_PULLED_OUT.rawValue:
            result = "EPOS2_CODE_ERR_PAPER_PULLED_OUT";
            break;
        case EPOS2_CODE_ERR_CANCEL_FAILED.rawValue:
            result = "EPOS2_CODE_ERR_CANCEL_FAILED";
            break;
        case EPOS2_CODE_ERR_PAPER_TYPE.rawValue:
            result = "EPOS2_CODE_ERR_PAPER_TYPE";
            break;
        case EPOS2_CODE_ERR_WAIT_INSERTION.rawValue:
            result = "EPOS2_CODE_ERR_WAIT_INSERTION";
            break;
        case EPOS2_CODE_ERR_ILLEGAL.rawValue:
            result = "EPOS2_CODE_ERR_ILLEGAL";
            break;
        case EPOS2_CODE_ERR_INSERTED.rawValue:
            result = "EPOS2_CODE_ERR_INSERTED";
            break;
        case EPOS2_CODE_ERR_WAIT_REMOVAL.rawValue:
            result = "EPOS2_CODE_ERR_WAIT_REMOVAL";
            break;
        case EPOS2_CODE_ERR_DEVICE_BUSY.rawValue:
            result = "EPOS2_CODE_ERR_DEVICE_BUSY";
            break;
        case EPOS2_CODE_ERR_IN_USE.rawValue:
            result = "EPOS2_CODE_ERR_IN_USE";
            break;
        case EPOS2_CODE_ERR_CONNECT.rawValue:
            result = "EPOS2_CODE_ERR_CONNECT";
            break;
        case EPOS2_CODE_ERR_DISCONNECT.rawValue:
            result = "EPOS2_CODE_ERR_DISCONNECT";
            break;
        case EPOS2_CODE_ERR_MEMORY.rawValue:
            result = "EPOS2_CODE_ERR_MEMORY";
            break;
        case EPOS2_CODE_ERR_PROCESSING.rawValue:
            result = "EPOS2_CODE_ERR_PROCESSING";
            break;
        case EPOS2_CODE_ERR_PARAM.rawValue:
            result = "EPOS2_CODE_ERR_PARAM";
            break;
        case EPOS2_CODE_RETRY.rawValue:
            result = "EPOS2_CODE_RETRY";
            break;
        case EPOS2_CODE_ERR_DIFFERENT_MODEL.rawValue:
            result = "EPOS2_CODE_ERR_DIFFERENT_MODEL";
            break;
        case EPOS2_CODE_ERR_DIFFERENT_VERSION.rawValue:
            result = "EPOS2_CODE_ERR_DIFFERENT_VERSION";
            break;
        case EPOS2_CODE_ERR_DATA_CORRUPTED.rawValue:
            result = "EPOS2_CODE_ERR_DATA_CORRUPTED";
            break;
        case EPOS2_CODE_ERR_RECOVERY_FAILURE.rawValue:
            result = "EPOS2_CODE_ERR_RECOVERY_FAILURE";
            break;
        case EPOS2_CODE_ERR_JSON_FORMAT.rawValue:
            result = "EPOS2_CODE_ERR_JSON_FORMAT";
            break;
        default:
            result = String(format:"%d", resultCode)
            break
        }
        
        return result;
    }
}
