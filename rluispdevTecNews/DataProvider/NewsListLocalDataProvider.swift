//
//  NewsListLocalDataProvider.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 4/30/25.
//

import Foundation

protocol NewsListLocalDataProviderProtocol: GenericDataProvider{}

class NewsListLocalDataProvider: DataProviderManager< NewsListLocalDataProviderProtocol, NewsModel> {

        
        func getNewsList() {
            NewsListRepository.shared.getNewsList { newModelList, error in
            if let error = error {
                self.delegate?.errorData(self.delegate, error: error)
                return
            }
            
            if let model = newModelList {
                self.delegate?.success(model: model)
            }
        }
    }
}


