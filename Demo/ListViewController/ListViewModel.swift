//
//  ListViewModel.swift
//  Demo
//
//  Created by Pisit W on 6/6/2563 BE.
//  Copyright © 2563 confusians. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import Alamofire
import AlamofireImage


class ListViewModel: NSObject {
    var datasource: ListDataSource?

    var networkState: DynamicValue<NetworkState> = DynamicValue(.none)
    
    override init() {
        super.init()
        datasource = ListDataSource()
        getData()
    }
    
    func getData(id: Int = 0, resetPage: Bool = true) {
        
        let param = [:] as [String : AnyObject]
        
        networkState.value = .loading
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { return }
        Alamofire.request(url, method: .get, parameters: param)
            .responseJSON { [weak self] response in
                switch response.result {
                case .success(let responseValue):
                    if let data = response.data, let json = try? JSON(data: data), let arrayResponse = Mapper<ListModel>().mapArray(JSONString: json.rawString() ?? "") {
                        // success block
                        self?.datasource?.data.value = arrayResponse
                        self?.networkState.value = .successHaveValue
                    } else {
                        // received response but cannot map
                        self?.networkState.value = .successHaveValue
                    }
                case .failure(let error):
                    // error block
                    self?.networkState.value = .error
                    break
                }
        }
    }
}

class ListDataSource: GenericDataSource<ListModel>, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ListViewTableViewCell
        cell?.iconView.backgroundColor = indexPath.row % 2 == 0 ? .dodgerBlue459 : .redFC1
        let model = data.value[indexPath.row]

        if let text = model.url, let url = URL(string: text) {
            cell?.mainImageView.af_setImage(withURL: url)
        }
        cell?.titleLbale.text = model.title
        return cell ?? UITableViewCell()
        
    }
    
}
