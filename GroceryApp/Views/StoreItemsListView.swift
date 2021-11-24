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
    
    @State private var storeItemVS = StoreItemViewState()
    
    private func deleteStoreItem(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let storeItem = storeItemListVM.storeItems[index]
            storeItemListVM.deleteStoreItem(storeId: store.storeId, storeItemId: storeItem.storeItemId)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                StoreCell(store: store).frame(alignment: .leading)
                Spacer()
            }
            .frame(alignment: .leading)
            .padding()
            TextField("Enter item name", text: $storeItemVS.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Price", text: $storeItemVS.price)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Quantity", text: $storeItemVS.quantity)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                storeItemListVM.addItemToStore(storeId: store.storeId, storeItemVS: storeItemVS) { error in
                    if error == nil {
                        storeItemVS = StoreItemViewState()
                        storeItemListVM.getStoreItemsBy(storeId: store.storeId)
                    }
                }
            }
            List {
                ForEach(storeItemListVM.storeItems, id: \.storeItemId) { storeItem in
                    Text(storeItem.name)
                }.onDelete(perform: deleteStoreItem)
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
