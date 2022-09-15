//
//  Model.swift
//  CoffeeMachine
//
//  Created by user on 15/9/22.
//

import Foundation

enum CoffeeType:String,Codable,CaseIterable {
    case cappuccino
    case latte
    case espressino
    case cortado
}
enum CoffeeSize:String,Codable,CaseIterable {
    case small
    case medium
    case large
}
struct Order:Codable {
    let name:String
    let email:String
    let type:CoffeeType
    let size:CoffeeSize
}
extension Order {
    static var all:Resource<[Order]> = {
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("Invalid URL")
        }
        return Resource<[Order]>(url: url)
    }()
    
    static func create(_ vm: AddCoffeeViewModel)->Resource<Order?>{
        let order = Order(vm)
        guard let url = URL(string: "https://warp-wiry-rugby.glitch.me/orders") else {
            fatalError("Invalid URL")
        }
        guard let data = try? JSONEncoder().encode(order) else {
            fatalError("Error encodeing order!")
        }
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
}

extension Order {
    init?(_ vm:AddCoffeeViewModel) {
        guard let name = vm.name, let email = vm.email,let typeS = vm.selectedType?.lowercased(),let sizeS = vm.selectedSize?.lowercased(), let type = CoffeeType(rawValue: typeS),let size = CoffeeSize(rawValue: sizeS) else {
            return nil
        }
        self.name = name
        self.email = email
        self.type = type
        self.size = size
    }
}


