//
//  StoreItemListViewModel.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/14/21.
//

import Foundation

class StoreItemListViewModel: ObservableObject {
    private var firestoreManager: FirestoreManager
    var groceryItemName: String = ""
    @Published var store: StoreViewModel?
    
    init() {
        firestoreManager = FirestoreManager()
    }
    
    func addItemsToStore(storeId: String) {
        // Dictionary ["items": item]
        firestoreManager.updateStore(storeId: storeId, values: ["items": [groceryItemName] ] ) {result in
            switch result {
            case .success(let storeModel):
                if let model = storeModel {
                    DispatchQueue.main.async {
                        self.store = StoreViewModel(store: model)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}