//
//  Feed.swift
//  TwitterCloneV2
//
//  Created by Cristian Stefirca on 10.06.2023.
//

import SwiftUI

struct Feed: View {
    
    
    var userUUID: String
       
       init(userUUID: String) {
           self.userUUID = userUUID
       }
    
    @State private var isAddFeedPresented = false

    @State private var tweets: [TweetFeed] = []
     
     var body: some View {
         NavigationView {
             List(tweets) { tweet in
                 VStack(alignment: .leading, spacing: 10) {
                     HStack(spacing: 10) {
                         Image(tweet.user.profileImage)
                             .resizable()
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                         VStack(alignment: .leading) {
                             Text(tweet.user.name)
                                 .font(.headline)
                             Text("@\(tweet.user.username) • \(tweet.timestamp)")
                                 .foregroundColor(.gray)
                         }
                     }
                     Text(tweet.text)
                     HStack(spacing: 60) {
                         Button(action: {}) {
                             Image(systemName: "bubble.left")
                         }
                         Button(action: {}) {
                             Image(systemName: "arrow.2.squarepath")
                         }
                         Button(action: {}) {
                             Image(systemName: "heart")
                         }
                         Button(action: {}) {
                             Image(systemName: "square.and.arrow.up")
                         }
                     }
                     .foregroundColor(.gray)
                     .font(.system(size: 18))
                 }
                 .padding(.vertical)
             }
             .listStyle(PlainListStyle())
             .navigationBarTitle("Home", displayMode: .inline)
             .navigationBarItems(leading:
                 Image("twitter-logo")
                     .resizable()
                     .frame(width: 30, height: 30),
                 trailing:
                Button(action: { isAddFeedPresented = true }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
                            }

             )
             .onAppear(perform: loadData)
             .sheet(isPresented: $isAddFeedPresented) {
                 AddFeedView(isPresented: $isAddFeedPresented)
             }

         }
     }
     
    func loadData() {
    // Create URL for request
    guard let url = URL(string: "http://localhost:3000/home/user-tweets/:userUUID") else { return }
    
    // Create data task
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        // Check for errors
        if let error = error {
            print("Error fetching data: \(error.localizedDescription)")
            return
        }
        
        // Decode JSON data
        if let data = data {
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
               let decodedData = try decoder.decode(HomeData.self, from: data)
                DispatchQueue.main.async {
                    self.tweets = decodedData.tweets
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }
    
    // Start data task
    task.resume()
}
    
 }

struct UserFeed: Identifiable, Decodable {
    var id: String
    let name: String
    let username: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case username
        case profileImage
    }
}


struct HomeData: Decodable {
    let tweets: [TweetFeed]
}





struct TweetFeed: Identifiable, Decodable {
    var id: String
    let text: String
    let timestamp: String
    let user: UserFeed
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case timestamp
        case user
    }
}



 struct Feed_Previews: PreviewProvider {
     static var previews: some View {
         Feed(userUUID: "userUUID")
     }
 }
