//
//  AddressView.swift
//  Cupcake Corner
//
//  Created by George Patterson on 14/03/2021.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order

    
    
    var body: some View {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("ZIP", text: $order.zip)
                }
                Section {
                    NavigationLink(destination: CheckoutView(order: order)) {
                        Text("Check Out")
                    }
                }.disabled(order.hasValidAddress == false)
            }
            .navigationBarTitle("Delivery Details", displayMode: .inline)
        
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
