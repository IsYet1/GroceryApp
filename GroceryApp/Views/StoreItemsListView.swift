//
//  StoreItemsListView.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/18/21.
//

// Multiple ways to handle the page update. Could do onChange like we've done before.

import SwiftUI
import Combine

struct StoreItemsListView: View {
    
    @State var store: StoreViewModel
    @StateObject private var storeItemListVM = StoreItemListViewModel()
    @State var cancellable: AnyCancellable?
    
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
            
            Spacer()
            
            .onAppear(perform: {
                cancellable = storeItemListVM.$store.sink { value in
                    if let value = value {
                        store = value
                    }
                    
                }
            })
        }
    }
}

struct StoreItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemsListView(store: StoreViewModel(store: Store(id: "123", name: "Preview Store", address: "Preview Address", items: nil)))
    }
}
