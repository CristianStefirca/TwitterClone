//
//  AddFeed.swift
//  TwitterCloneV2
//
//  Created by Cristian Stefirca on 17.06.2023.
//

import SwiftUI

struct AddFeedView: View {
    
    @Binding var isPresented: Bool
    @State private var text = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("What's happening?", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Compose", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: { isPresented = false }) {
                Text("Cancel")
            },
                                trailing:
                                    Button(action: postTweet) {
                Text("Post")
            }
            )
        }
    }
    
    func postTweet() {
        // Create URL for request
        guard let url = URL(string: "http://localhost:3000/tweets") else { return }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let body: [String: Any] = ["text": text]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else { return }
        request.httpBody = httpBody
        
        // Create data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error creating tweet: \(error.localizedDescription)")
                return
            }
            
            // Dismiss compose view
            DispatchQueue.main.async {
                isPresented = false
            }
        }
        
        // Start data task
        task.resume()
    }

    
    
    struct AddFeed_Previews: PreviewProvider {
        static var previews: some View {
            AddFeedView(isPresented: .constant(true))
        }
    }
}
