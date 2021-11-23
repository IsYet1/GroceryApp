//
//  FirestoreManager.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/8/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager {
    private var db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    func getStoreById(storeId: String, completion: @escaping (Result<Store?, Error>) -> Void) {
        let ref = db.collection("stores").document(storeId)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let snapshot = snapshot {
                    var store: Store? = try? snapshot.data(as: Store.self)
                    if store != nil {
                        store!.id = snapshot.documentID
                        completion(.success(store))
                    }
                }
            }
        }
    }
    
    func addItemToStore(storeId: String, storeItem: StoreItem, completion: @escaping (Result<Store?, Error>) -> Void) {
        do {
            let _ = try db.collection("stores")
                .document(storeId)
                // TODO: Try using the storeItem object instead of parsing it out.
                .collection("items").addDocument(data: ["name": storeItem.name, "price": storeItem.price, "quantity": storeItem.quantity])
            
            self.getStoreById(storeId: storeId) { result in
                switch result{
                case .success(let store):
                    completion(.success(store))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // This is not used after adding the addItemToStore above. He named the functions the same but I used a different name.
    func updateStore(storeId: String, values: [AnyHashable: Any], completion: @escaping (Result<Store?, Error>) -> Void) {
        let ref = db.collection("stores").document(storeId)
        ref.updateData(
        [
            // arrayUnion will append values
            "items": FieldValue.arrayUnion((values["items"] as? [String]) ?? [] )
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.getStoreById(storeId: storeId) {result in
                    switch result {
                    case .success(let store):
                        completion(.success(store))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    func getAllStores(completion: @escaping (Result<[Store]?, Error>) -> Void) {
        db.collection("stores")
            .getDocuments { (snapshot, error) in
                // Unwrap with the if =. If it's there then it will set the variable (error) and perform the {block}
                if let error = error {
                    completion(.failure(error))
                } else {
                    if let snapshot = snapshot {
                        let stores: [Store]? = snapshot.documents.compactMap { doc in
                            var store = try? doc.data(as: Store.self)
                            if store != nil {
                                store!.id = doc.documentID
                            }
                            return store
                        }
                        completion(.success(stores))
                    }
                }
            }
    }
    
    func save(store: Store, completion: @escaping (Result<Store?, Error>) -> Void) {
        do {
            let ref = try db.collection("stores").addDocument(from: store)
            ref.getDocument {(snapshot, error) in
                guard let snapshot = snapshot, error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                let store = try? snapshot.data(as: Store.self)
                completion(.success(store))
            }
        } catch let error {
            completion(.failure(error))
        }
    }

}

