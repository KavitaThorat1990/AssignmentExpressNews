//
//  SearchNewsViewModel.swift
//  ExpressNews
//
//  Created by Kavita Thorat on 03/01/24.
//

import PromiseKit

final class SearchNewsViewModel: NewsListViewModel {
    var selectedQuery: String = ""
    
    override func getAPIParameters() -> [String : Any] {
        var parameters = super.getAPIParameters()
        parameters[APIConstants.RequestParameters.query] = selectedQuery
        return parameters
    }
}
