//
//  StoreItemsListView.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/18/21.
//

// Multiple ways to handle the page update. Could do onChange like we've done before.

import SwiftUI

struct StoreItemsListView: View {
    
    var store: StoreViewModel
    @StateObject private var storeItemListVM = StoreItemListViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter item name", text: $storeItemListVM.storeItemVS.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Price", text: $storeItemListVM.storeItemVS.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Quantity", text: $storeItemListVM.storeItemVS.quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                storeItemListVM.addItemToStore(storeId: store.storeId) { error in
                    if error == nil {
                        storeItemListVM.getStoreItemsBy(storeId: store.storeId)
                    }
                }
            }
            List(storeItemListVM.storeItems, id: \.name) {item in
                Text(item.name)
            }
            
            Spacer()
            
            .onAppear(perform: {
                storeItemListVM.getStoreItemsBy(storeId: store.storeId)
//                storeItemListVM.getStoreById(storeId: store.storeId)
            })
        }
    }
}

struct StoreItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsListView(store: StoreViewModel(store: Store(id: "123", name: "Preview Store", address: "Preview Address", items: nil)))
    }
}
