//
//  StoreItem.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/22/21.
//

import Foundation

struct StoreItem: Codable {
    var name: String = ""
    var price: Double = 0.0
    var quantity: Int = 0
}

extension StoreItem {
    static func from(_ storeItemVS: StoreItemViewState) -> StoreItem {
        return StoreItem(name: storeItemVS.name, price: Double(storeItemVS.price) ?? 0.0, quantity: Int(storeItemVS.quantity) ?? 0)
    }
}
