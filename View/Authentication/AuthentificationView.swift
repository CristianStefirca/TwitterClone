import SwiftUI
import Foundation

class AppState: ObservableObject {
    @Published var token: String?
}

struct AuthentificationView: View {
    @Binding var isShowing: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isPresentingRegisterView = false
    
    var body: some View {
        VStack {
            Image("twitter-logo2")
                .padding()
            Text("Log In")
                .font(.largeTitle)
                .bold()
                .padding()
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            Button(action: login) {
                Text("Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            Button(action: { isPresentingRegisterView = true }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .sheet(isPresented: $isPresentingRegisterView) {
            RegisterView()
        }
    }
    
    func login() {
        // Create URL for request
        guard let url = URL(string: "http://localhost:3000/auth/login") else {
            print("Invalid URL")
            return
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let body: [String: Any] = ["email": email, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            print("Failed to create HTTP body")
            return
        }
        request.httpBody = httpBody
        
        // Create data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error logging in user: \(error.localizedDescription)")
                return
            }
            
            // Parse response data
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let token = json["token"] as? String else {
                DispatchQueue.main.async {
                    errorMessage = "Wrong email or password, please try again!"
                }
                return
            }
            
            DispatchQueue.main.async {
                isShowing = false
                presentationMode.wrappedValue.dismiss()
                
                // Store token and switch to Home view
                appState.token = token
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: Home().environmentObject(appState))
                    window.makeKeyAndVisible()
                }
            }
        }
        
        // Start the data task
        task.resume()
    }
}

struct AuthentificationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthentificationView(isShowing: .constant(true), appState: AppState())
    }
}
