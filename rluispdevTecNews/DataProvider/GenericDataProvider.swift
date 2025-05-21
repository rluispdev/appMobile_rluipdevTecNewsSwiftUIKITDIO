//
//  GenericDataProvider.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 4/30/25.
//

import Foundation

protocol GenericDataProvider {
    func success(model: Any)
    func errorData(_ provide: GenericDataProvider?, error: Error)
}

 class DataProviderManager<T, S> {
     var delegate: T?
     var model: S?
    
}
