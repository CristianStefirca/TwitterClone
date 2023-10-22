import SwiftUI
import Foundation

struct Home: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack {
            ZStack {
                TabView(selection: $selectedIndex) {
                    Feed(userUUID: "userUUID")
                        .environmentObject(appState) // Pass the existing appState object
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    // Replace with the current user's ID
                    let currentUserId = "YOUR_CURRENT_USER_ID"
                    
                    SearchView(currentUserId: currentUserId)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(1)
                    
                    NotificationsView()
                        .tabItem {
                            Image(systemName: "bell.fill")
                            Text("Notifications")
                        }
                        .tag(2)
                    
                    MessagesView()
                        .tabItem {
                            Image(systemName: "message.fill")
                            Text("Messages")
                        }
                        .tag(3)
                }
            }
            
            Button(action: signOut) {
                Text("Sign Out!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
    
    func signOut() {
        // Clear token and switch back to AuthentificationView
        appState.token = nil as String?
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: AuthentificationView(isShowing: Binding<Bool>.constant(true), appState: appState))
            window.makeKeyAndVisible()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(AppState())
    }
}
