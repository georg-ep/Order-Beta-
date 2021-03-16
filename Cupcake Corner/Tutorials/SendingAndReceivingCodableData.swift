//
//  SendingAndReceivingCodableData.swift
//  Cupcake Corner
//
//  Created by George Patterson on 14/03/2021.
//

import SwiftUI
/*
 
 If we combine codable with sending and receiving data from the net we can cnvert swift objects to JSON for sending
 then receive back JSON to be converted into swift objects
 
 URLSession
 this automatically runs in the backgroud
 this is run on the background thread, an independent piece of code which runs the same time as the rest of our program
 
iOS likes to have everything run on the main thread, the thread that the program was started
 this is because it stops 2 pieces of code trying to manipulate the UI simultaneously
 
 */

struct SendingAndReceivingCodableData: View {
    
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
            
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
        print("Invalid URL")
        return
        }
        
        let request = URLRequest(url: url)
        
        //URLSession manages network requests
        //its very common to use the shared session iOS creates for us to use
        //unless we require some specific behaviour
        
        //dataTask is called on the shared session to create a networkking task from URLRequest, and a closure which should be run when the task completes
        
        
        
        URLSession.shared.dataTask(with: request) { data, //data returned from request
                                                    response, //description of the data
                                                    error //error that occured
                                                    in
            //the code in this closure is what gets run when the request finishes
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    
                    //DispatchQueue.main.async
                    //is a particular way to send work to the main thread
                    //we don't want the results to be on the background thread, bevause this is where problems can be encountered
                    //it takes a closure of work to perform and sends it off to the main thread for execution
                    //it is added to a queue
                    
                    
                    
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.results
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume() //this modifier allows the request to start immediately, without it the rquest would not be sent
    }
}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct SendingAndReceivingCodableData_Previews: PreviewProvider {
    static var previews: some View {
        SendingAndReceivingCodableData()
    }
}
