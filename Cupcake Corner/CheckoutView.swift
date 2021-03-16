//
//  CheckoutView.swift
//  Cupcake Corner
//
//  Created by George Patterson on 14/03/2021.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    

    
    var body: some View {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        Image("cupcakes")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width)
                        Text("Your total is \(order.cost, specifier: "%.2f")")
                            .font(.title)
                        
                        Button("Place Order") {
                            self.placeOrder()
                        }.padding()
                    }
                }
                
            }//.alert(isPresented: $showingConfirmation) {
               // Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            //}
    .sheet(isPresented: $showingConfirmation) {
        VStack {
            Text("Thank You! Your order is being processed")
                .font(.subheadline)
            Divider()
            Text("Order Date:")
            Text("Amount: \(order.quantity)")
            Text("Total: \(order.cost, specifier: "%.2f")")
        }
        
            }
            .navigationBarTitle("Checkout", displayMode: .inline)
        }
    
    
    /*
     Place order will do 3 things:
     Convert our order into some JSON data
     Prepare a URLRequest to send our encoded data as JSON
     Run that request and process the respone
     */
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST" //set the http method type, we will be writing data so here is a POST method
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
