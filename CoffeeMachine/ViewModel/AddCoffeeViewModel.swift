//
//  AddCoffeeViewModel.swift
//  CoffeeMachine
//
//  Created by user on 15/9/22.
//

import Foundation

class AddCoffeeViewModel {
    var name:String?
    var email:String?
    
    var selectedSize:String?
    var selectedType:String?

    var types:[String] {
        return CoffeeType.allCases.map{ $0.rawValue.capitalized }
    }
    var sizes:[String] {
        return CoffeeSize.allCases.map{ $0.rawValue.capitalized }
    }
}
