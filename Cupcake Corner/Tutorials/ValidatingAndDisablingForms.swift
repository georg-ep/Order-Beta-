//
//  ValidatingAndDisablingForms.swift
//  Cupcake Corner
//
//  Created by George Patterson on 14/03/2021.
//

import SwiftUI
/*
 
 .disabled()
 
 a modifier for checking form input before proceeding
 
 */

struct ValidatingAndDisablingForms: View {
    @State private var username = ""
    @State private var email = ""
    
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }

        var body: some View {
            Form {
                Section {
                    TextField("Username", text: $username)
                    TextField("Email", text: $email)
                }

                Section {
                    Button("Create account") {
                        print("Creating account…")
                    }
                }
                .disabled(disableForm)
                //this section is disabled if username or email are less than 5 chars long

            }
        }
}

struct ValidatingAndDisablingForms_Previews: PreviewProvider {
    static var previews: some View {
        ValidatingAndDisablingForms()
    }
}
