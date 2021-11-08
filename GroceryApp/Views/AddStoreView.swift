//
//  AddStoreView.swift
//  GroceryApp
//
//  Created by Don McKenzie on 11/8/21.
//

import SwiftUI

struct AddStoreView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var addStoreVM = AddStoreViewModel()
    var body: some View {
        Form {
            // This code automatically stores the name and address to the VM
            Section {
                TextField("Name", text: $addStoreVM.name)
                TextField("Address", text: $addStoreVM.address)
                HStack {
                    Spacer()
                    Button("Save") {
                        addStoreVM.save()
                    // Listen for the saved value to change.
                    }.onChange(of: addStoreVM.saved, perform: {value in
                        if value {
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                    Spacer()
                }
                // In case there's an error - display the message
                Text(addStoreVM.message)
            }
        }.navigationBarItems(leading: Button(action: {
            presentationMode
                .wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
        }))
        .navigationTitle("Add New Store")
        .embedInNavigationView()
    }
}

struct AddStoreView_Previews: PreviewProvider {
    static var previews: some View {
        AddStoreView()
    }
}
