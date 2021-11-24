//
//  StoreCell.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/24/21.
//

import SwiftUI

struct StoreCell: View {
    let store: StoreViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.name)
                .font(.title2)
            Text(store.address)
                .font(.callout)
        }
    }
}


struct StoreCell_Previews: PreviewProvider {
    static var previews: some View {
        StoreCell(store: StoreViewModel(store: Store(id: "123", name: "Preview Store", address: "Preview Address", items: nil)))
    }
}
