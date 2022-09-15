//
//  OrderListViewModel.swift
//  CoffeeMachine
//
//  Created by user on 15/9/22.
//

import Foundation

struct  OrderListViewModel {
    var ordersViewModel:[OrderViewModel]
    
    init() {
        self.ordersViewModel = []
    }
}

extension OrderListViewModel{
    func noOfOrders() -> Int {
        return ordersViewModel.count
    }
    func orderViewModel(at index:Int) -> OrderViewModel {
        return ordersViewModel[index]
    }
}
