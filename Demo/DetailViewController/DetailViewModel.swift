//
//  DetailViewModel.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit

class DetailViewModel: NSObject {
    var model: DynamicValue<ListModel?> = DynamicValue(nil)
    var networkState: DynamicValue<NetworkState> = DynamicValue(.none)
}
