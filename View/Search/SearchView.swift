import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var users: [User] = []
    @State private var currentUserId: String
    
    init(currentUserId: String) {
        self.currentUserId = currentUserId
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Twitter", text: $searchText)
                        .onChange(of: searchText) { _ in
                            loadData()
                        }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                Section(header: Text("People")) {
                    ForEach(users) { user in
                        HStack {
                            if let profileImage = user.profileImage {
                                Image(profileImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                // Handle the case where profileImage is nil
                                // For example, you could display a placeholder image
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text("@\(user.name)") // Use the name property instead of the username property
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: { followUser(user.id) }) {
                                Text("Follow")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 80, height: 30)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Twitter", displayMode: .inline)
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        // Check if searchText is empty
        if searchText.isEmpty { return }
        
        // Create URL for request
        guard let url = URL(string: "http://localhost:3000/search/\(searchText)") else { return }
        
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
                                print(String(data: data, encoding: .utf8)!)
                                let decoder = JSONDecoder()
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                                let decodedData = try decoder.decode(SearchResponse.self, from: data)
                                DispatchQueue.main.async {
                                    self.users = decodedData.users
                                }
                            } catch let DecodingError.dataCorrupted(context) {
                                print(context.debugDescription)
                            } catch let DecodingError.keyNotFound(key, context) {
                                print("Key '\(key)' not found:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch let DecodingError.valueNotFound(value, context) {
                                print("Value '\(value)' not found:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch let DecodingError.typeMismatch(type, context)  {
                                print("Type '\(type)' mismatch:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch {
                                print("Error decoding JSON: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    // Start data task
                    task.resume()
                }


                
                    func followUser(_ userIdToFollow: String) {
                        // Use the currentUserId property instead of the hardcoded value
                        let currentUserId = self.currentUserId
                        
                        // Create URL for request
                        guard let url = URL(string: "http://localhost:3000/follow/\(currentUserId)/\(userIdToFollow)") else { return }
                        
                        // Create request
                        var request = URLRequest(url:url)
                        request.httpMethod = "POST"
                        
                        // Create data task
                        let task = URLSession.shared.dataTask(with:request) { data, response, error in
                            // Check for errors
                            if let error = error {
                                print("Error following user: \(error.localizedDescription)")
                                return
                            }
                            
                            // Parse response data
                            if let data = data,
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let message = json["message"] as? String {
                                print(message)
                            }
                        }
                        
                        // Start data task
                        task.resume()
                    }
                }


                struct SearchResponse: Decodable {
                    let users: [User]
                }




            struct User: Identifiable, Decodable {
                let id: String
                let name: String
                let profileImage: String?
                let email: String?
                let password: String?

                enum CodingKeys: String, CodingKey {
                    case id = "_id"
                    case name
                    case profileImage
                    case email
                    case password
                }
            }

