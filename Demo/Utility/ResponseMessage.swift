//
//  ResponseMessage.swift
//  scgfamily2020
//
//  Created by User23 on 12/9/2562 BE.
//  Copyright © 2562 user23. All rights reserved.
//

import Foundation
import ObjectMapper

class BasicData: Mappable {
    
    var response_code: Int!
    var response_msg: String!
    var networkState: NetworkState = .none
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response_code <- map["response_code"]
        response_msg <- map["response_msg"]
    }
    
    func checkForNetworkState() {
        
        if response_code == FREEZE_APP_ERROR_CODE {
            NotificationCenter.default.post(name: .AppStatus, object: AppStatusType.freezeApp)
            return
        }
        
        if !(200...299 ~= response_code) {
            networkState = NetworkState.errorFromCode(errorCode: response_code, errorMessage: response_msg)
        } else {
            networkState = .successHaveValue
        }
    }
    
    func checkForArrayNetworkState(data: [Mappable]) {
        
        if response_code == FREEZE_APP_ERROR_CODE {
            NotificationCenter.default.post(name: .AppStatus, object: AppStatusType.freezeApp)
            return
        }
        
        if !(200...299 ~= response_code) {
            networkState = NetworkState.errorFromCode(errorCode: response_code, errorMessage: response_msg)
        } else if data.count == 0 {
            networkState = .successNoValue
        } else {
            networkState = .successHaveValue
        }
    }
}

class ResponseNoData: BasicData {
    override func mapping(map: Map) {
        super.mapping(map: map)
        checkForNetworkState()
    }
    
    override func checkForNetworkState() {
        super.checkForNetworkState()
    }
}

class ResponseSingleData<T: Mappable>: BasicData {
    
    var data: T!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.JSON["result"] == nil {
            data = T.init(JSONString: "{}")
        } else {
            data <- map["result"]
        }
        checkForNetworkState()
    }
    
    override func checkForNetworkState() {
        super.checkForNetworkState()
    }
}

class ResponseArrayData<T: Mappable>: BasicData {
    
    var data: [T]!

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        if map.JSON["result"] == nil {
            data = []
        } else {
            data <- map["result"]
        }
        checkForNetworkState()
    }
    
    override func checkForNetworkState() {
        if let data = data {
            checkForArrayNetworkState(data: data)
        } else {
           super.checkForNetworkState()
        }
    }
}

class ResponseArrayPagination<T: Mappable>: BasicData {
    
    var pagination: PageUtility!
    var lists: [T]!
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        lists <- map["result.lists"]
        pagination <- map["result.pagination"]
        checkForNetworkState()
    }
    
    override func checkForNetworkState() {
        if let data = lists {
            checkForArrayNetworkState(data: data)
        } else {
            super.checkForNetworkState()
        }
    }
}


let TOKEN_EXPIRED_NOTIFICATION = "TOKEN_EXPIRED_NOTIFICATION"
let TOKEN_EXPIRED = 5103
let USER_NOT_ACTIVE = 5105
let PLEASE_LOGIN_AGAIN = 5106
let FREEZE_APP_ERROR_CODE = 503

enum NetworkState: Equatable {
    case none
    case loading
    case noInternet
    case successHaveValue
    case successNoValue
    case error
    case errorWith(errorCode: Int, errorMessage: String)
    case loadingMore
    case tokenExpired
    case progress(progress: Double)
    
    func isLoading() -> Bool {
        return self == NetworkState.loading
    }
    
    func isTokenExpired() -> Bool {
        switch self {
        case .errorWith(let errorCode, let _):
            return errorCode == TOKEN_EXPIRED
        default:
            return false
        }
    }
    
    static func errorFromCode(errorCode: Int, errorMessage: String) -> NetworkState {
        if errorCode == TOKEN_EXPIRED || errorCode == USER_NOT_ACTIVE || errorCode == PLEASE_LOGIN_AGAIN {
            NotificationCenter.default.post(name: Notification.Name(TOKEN_EXPIRED_NOTIFICATION), object: errorMessage)
            return .tokenExpired
        }
        return .errorWith(errorCode: errorCode, errorMessage: errorMessage)
    }
}
