//
//  StoreItemsListView.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/18/21.
//

import SwiftUI

struct StoreItemsListView: View {
    
    let store: StoreViewModel
    @StateObject private var storeItemListVM = StoreItemListViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter item name", text: $storeItemListVM.groceryItemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Save") {
                storeItemListVM.addItemsToStore(storeId: store.storeId)
            }
            
            List(store.items, id: \.self) {item in
                Text(item)
            }
        }
    }
}

struct StoreItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsListView(store: StoreViewModel(store: Store(id: "123", name: "Preview Store", address: "Preview Address", items: nil)))
    }
}
