//
//  OrderViewModel.swift
//  CoffeeMachine
//
//  Created by user on 15/9/22.
//

import Foundation

struct OrderViewModel {
    let order: Order
}

extension OrderViewModel{
    var name:String{
        return order.name
    }
    var email:String{
        return order.email
    }
    var type:String{
        return order.type.rawValue.capitalized
    }
    var size:String{
        return order.size.rawValue.capitalized
    }
}
