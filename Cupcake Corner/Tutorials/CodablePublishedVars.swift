//
//  CodablePublishedVars.swift
//  Cupcake Corner
//
//  Created by George Patterson on 14/03/2021.
//

import SwiftUI

struct CodablePublishedVars: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

/*
Codable works differently with published variables

to tell swift which properites should be loaded and saved:
We use a protocol called codingkey with an enum

in every case, our enum is the property we want to load and save


*/

enum CodingKeys: CodingKey {
   case name
}

class User: Codable, ObservableObject {
   @Published var name = "George P"
   
   //custom initialiser given a container used to read values for all our properties
   //handed an instance of Decoder, containing all our data but up to us with how to read it
   //anyone that sublasses the USer class must override the init with a custom implementation to ensure that they add their own values
   //this iis where we get required, could also write final class User and remove the required
   //We ask our decoder instance for all the coding keys we set in CodingKey using decoder.container
   //  meaning that data should have a container where the keys match the cases in the enum, throwing call because those keys may not exist
   //we read values directly from the contaier by referencing cases in our enum, name = ... extra safety
   
   //Codable makes it a lot harder to make a mistake, because we dont use strings and checks data types are correct
   
   //this shows us how to decode info
   required init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
       name = try container.decode(String.self, forKey: .name)
   }
   
   //this shows us how to encode the info (archive, ready to write to JSON)
   func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(name, forKey: .name)
   }
}

struct CodablePublishedVars_Previews: PreviewProvider {
    static var previews: some View {
        CodablePublishedVars()
    }
}
