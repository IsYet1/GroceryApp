//
//  StoreItemListViewModel.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/14/21.
//

import Foundation

struct StoreItemViewState {
    var name: String = ""
    var price: String = ""
    var quantity: String = ""
}

struct StoreItemViewModel {
    let storeItem: StoreItem
    var name: String {
        storeItem.name
    }
    var price: Double {
        storeItem.price
    }
    var quantity: Int {
        storeItem.quantity
    }
}

class StoreItemListViewModel: ObservableObject {
    private var firestoreManager: FirestoreManager
    var groceryItemName: String = ""
    @Published var store: StoreViewModel?
    @Published var storeItems: [StoreItemViewModel] = []
    
    var storeItemVS = StoreItemViewState()

    init() {
        firestoreManager = FirestoreManager()
    }
    
    func getStoreById(storeId: String) {
        firestoreManager.getStoreById(storeId: storeId) { result in
            switch result {
            case .success(let store):
                if let store = store {
                    DispatchQueue.main.async {
                        self.store = StoreViewModel(store: store)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func addItemToStore(storeId: String, completion: @escaping (Error?) -> Void) {
        let storeItem = StoreItem.from(storeItemVS)
        firestoreManager.addItemToStore(storeId: storeId, storeItem: storeItem) { result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func getStoreItemsBy(storeId: String) {
        firestoreManager.getStoreItemsBy(storeId: storeId) { result in
            switch result {
            case .success(let items):
                if let items = items {
                    DispatchQueue.main.async {
                        self.storeItems = items.map(StoreItemViewModel.init)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // This isn't being used as of lesson 39
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
