import SwiftUI
import UIKit

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var profileImage: UIImage?
    @State private var email = ""
    @State private var password = ""
    
    // Add properties to track the validity of email, username, and password
    @State private var isEmailValid = false
    @State private var isUsernameValid = false
    @State private var isPasswordValid = false
    
    // Add this property to track whether the ImagePicker should be presented
    @State private var isPresentingImagePicker = false
    
    // Add property for scaling animation
    @State private var isButtonAnimated = false
    
    
    // For email
    @State private var isEmailComplete = false
    @State private var isEditingEmail = false
    
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("twitter-logo")
            
            
            Text("Create your account")
                .font(.title)
                .foregroundColor(Color(hex: "#1DA1F2"))
                .lineSpacing(50)
                .lineLimit(nil)
                .padding()
            
            if let profileImage = profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button(action: { isPresentingImagePicker = true }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .padding()
            }
            .sheet(isPresented: $isPresentingImagePicker) {
                ImagePicker(selectedImage: $profileImage)
            }
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(isUsernameValid ? .green : .red)
                    TextField("@Username", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: name) { newValue in
                            isUsernameValid = !newValue.isEmpty
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(isEmailComplete ? (isEmailValid ? .green : .red) : .red)
                    TextField("E-mail", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .onChange(of: email) { newValue in
                            isEmailValid = isValidEmail(newValue)
                            isEmailComplete = !newValue.isEmpty
                            if !isEmailValid && !isEditingEmail {
                                isEditingEmail = true
                            }
                        }
                        .onTapGesture {
                            isEditingEmail = true
                        }
                        .overlay(
                            VStack {
                                if email.isEmpty && !isEditingEmail {
                                    Text("E-mail")
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 8)
                                }
                            }
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(isPasswordValid ? (password.isEmpty ? Color.blue : Color.green) : Color.red )
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: password) { newValue in
                            isPasswordValid = isValidPassword(newValue)
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
                
            }
            Button(action: register) {
                Text("Sign Up!")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(100)
                    .padding(.horizontal, 32)
                    .padding(.top, 25) // Add padding to the bottom
                    .animation(.spring())
                    .scaleEffect(isButtonAnimated ? 1.2 : 1.0)
            }
            .disabled(!isFormValid)
            
            Spacer()
            
        }
        .padding()
        .navigationBarTitle("Create Account")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            isButtonAnimated = true
        }
    }
    
    
    
    var nameAttributedText: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Culoarea textului
            .font: UIFont.systemFont(ofSize: 14) // Fontul textului
        ]
        
        return NSAttributedString(string: "Name", attributes: attributes)
    }
    
    
    
    
    
    
    
    
    
    var emailAttributedText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: email)
        
        if isValidEmail(email) {
            attributedString.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: 0, length: email.utf16.count))
        } else {
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: email.utf16.count))
        }
        
        return attributedString
    }
    
    var isFormValid: Bool {
        !name.isEmpty && isEmailValid && isPasswordValid
    }
    
    var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
    }
    
    struct User: Codable {
        let name: String
        let profileImage: String
        let email: String
        let password: String
        
        init(name: String, profileImage: String, email: String, password: String) {
            self.name = name
            self.profileImage = profileImage
            self.email = email
            self.password = password
        }
    }
    
    func register() {
        // Validate the email and password before proceeding
        guard isEmailValid, isPasswordValid else {
            print("Invalid email or password")
            return
        }
        
        // Create URL for the request
        guard let url = URL(string: "http://localhost:3000/auth/register") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let user = User(name: name, profileImage: "", email: email, password: password)
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding request body: \(error)")
            return
        }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error registering user: \(error.localizedDescription)")
                return
            }
            
            // Check response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            // On successful registration, dismiss the RegisterView
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    
    
    
    struct AttributedTextField: UIViewRepresentable {
        @Binding var text: String
        var attributedText: NSAttributedString
        
        func makeUIView(context: Context) -> UITextField {
            let textField = UITextField()
            textField.delegate = context.coordinator
            return textField
        }
        
        func updateUIView(_ uiView: UITextField, context: Context) {
            uiView.attributedText = attributedText
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UITextFieldDelegate {
            var parent: AttributedTextField
            
            init(_ parent: AttributedTextField) {
                self.parent = parent
            }
            
            func textFieldDidChangeSelection(_ textField: UITextField) {
                parent.text = textField.text ?? ""
            }
        }
    }
    
    
    
    
    
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        @Environment(\.presentationMode) var presentationMode
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = context.coordinator
            imagePickerController.sourceType = .photoLibrary
            return imagePickerController
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let selectedImage = info[.originalImage] as? UIImage {
                    parent.selectedImage = selectedImage
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailComponents = email.components(separatedBy: "@")
        
        // Check if the email has two components (username and domain)
        guard emailComponents.count == 2 else {
            return false
        }
        
        let domain = emailComponents[1]
        
        // Check if the domain has at least one dot
        guard domain.contains(".") else {
            return false
        }
        
        // Check if the username and domain are not empty
        guard !emailComponents[0].isEmpty && !domain.isEmpty else {
            return false
        }
        
        return true
    }
    
    
    
    
    
    
    
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    struct RegisterView_Previews: PreviewProvider {
        static var previews: some View {
            RegisterView()
        }
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
