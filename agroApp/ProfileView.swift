import SwiftUI

//struct Publication: Identifiable, Codable {
//    var id: Int?
//    var cPublisherName: String
//    var cPublisherType: String
//    var cPublisherEmail: String // Added for test
//    var cSelectedProduct: String
//    var cSelectedVariety: String
//    var cProductDescription: String
//    var cProductQuantity: String
//    var cPriceRatio: [String]
//    var cTags: [Tag]
//}

struct ProfileView: View {
    @Binding var isAuthenticated: Bool
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla
    static let profileName: String = UserDefaults.standard.string(forKey: "profileName") ?? ""
    static let accountType: String = UserDefaults.standard.string(forKey: "accountType") ?? ""
    static let email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    
    static let profileImage: Image = Image("TuLogo")
    static let reputationScore: Int = 100
    let profileBio: String = "Biografía del perfil"
    let followersCount: Int = 1200
    let postsCount: Int = 7
    
    @State private var myPublications: [Publication] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Barra superior
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: SettingsView(isAuthenticated: $isAuthenticated)) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Imagen de perfil y nombre
                    HStack {
                        ProfileView.profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(ProfileView.reputationScore < 70 ? Color.red : (ProfileView.reputationScore < 85 ? Color.yellow : ProfileView.reputationScore < 100 ? Color.green : Color.blue), lineWidth: 3))
                            .padding(.trailing, 16)
                        
                        VStack() {
                            Text(ProfileView.profileName)
                                .font(.headline)
                                .fontWeight(.bold)
                            HStack {
                                ForEach(1...5, id: \.self) { index in
                                    Image(systemName: index <= ProfileView.reputationScore/20 ? "star.fill" : "star")
                                        .foregroundColor(index <= ProfileView.reputationScore/20 ? .yellow : .gray)
                                        .padding(-5)
                                }
                            }
                            .frame(width: 50)
                        }
                        .padding(.trailing, 16)
                    }
                    
                    // Estadísticas de la cuenta
                    HStack {
                        VStack {
                            Text("\(postsCount)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Publicaciones")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer()
                        VStack {
                            Text("\(ProfileView.reputationScore)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Reputacion")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 16)

                        Spacer()
                        VStack {
                            Text("\(followersCount)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Seguidores")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 40)
                    
                    
                    // MARK: - Mis Publicaciones
                    VStack {
                        if myPublications.isEmpty {
                            VStack (spacing: 20) {
                                Text("No tienes publicaciones")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("Publica tus productos para que otros usuarios puedan verlos.")
                                    .font(.system(size: 20))
                                    .foregroundColor(.gray)
                                Image(systemName: "photo.badge.exclamationmark.fill")
                                    .font(.system(size: 100))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(myPublications) { publication in
                                NavigationLink(destination: DetailView(publication: publication)) {
                                    VStack() {
                                        Image(publication.cSelectedProduct)
                                            .resizable()
                                            .scaledToFit()
                                        Text(publication.cSelectedProduct + " " + publication.cSelectedVariety)
                                            .font(.headline)
                                        Divider()
                                        HStack {
                                            Image("TuLogo")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            Spacer()
                                            VStack {
                                                HStack {
                                                    ForEach(1...5, id: \.self) { index in
                                                        Image(systemName: index <= 4 ? "star.fill" : "star")
                                                            .foregroundColor(index <= 4 ? .yellow : .gray)
                                                            .padding(-5)
                                                    }
                                                }
                                                .frame(width: 50)
                                                Text(publication.cPublisherName)
                                            }
                                            Spacer()
                                        }
                                        Divider()
                                        
                                        Text("$\(publication.cPriceRatio[0]) /kg")
                                        
                                        Divider()
                                        Text("\(publication.cProductQuantity) Toneladas")
                                    }
                                    .foregroundColor(.black)
                                    .frame(width: 140, height: 250)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding()
                    }
                    .background(Color.backstage)
                }
            }
            .onAppear() {
                fetchMyPublications()
            }
        }
    }
    
    // MARK: - Funcion para obtener pubs
    func fetchMyPublications() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/publications/get") else {
            print("URL no válida")
            return
        }
        
        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "filterType", value: "publisherEmail"),
            URLQueryItem(name: "primaryFilter", value: ProfileView.email)
        ]
        
        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching publications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos.")
                return
            }

            // Imprimir los datos recibidos en formato JSON PRINT FOR DEBUG
//            if let jsonString = String(data: data, encoding: .utf8) {
//               print("Datos recibidos del servidor: \(jsonString)")
//            }

            do {
                let decodedPublications = try JSONDecoder().decode([Publication].self, from: data)
                DispatchQueue.main.async {
                    self.myPublications = decodedPublications
//                    print("Publicaciones decodificadas correctamente: \(decodedPublications)") PRINT FOR DEBUG
                }
            } catch {
                print("Error al decodificar las publicaciones: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let key, let context):
                        print("Tipo no coincide para la clave \(key), \(context.debugDescription)")
                    case .valueNotFound(let key, let context):
                        print("Valor no encontrado para la clave \(key), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Clave no encontrada \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Datos corruptos: \(context.debugDescription)")
                    @unknown default:
                        print("Error desconocido de decodificación")
                    }
                }
            }
        }.resume()
    }
}

struct SettingsView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("SECURITY")) {
                    Toggle(isOn: .constant(true)) {
                        Text("Face ID")
                    }
                    .padding(.top)
                    .font(.headline)
                    Text("Si tu dispositivo tiene Touch ID o Face ID, también puedes usarlo para desbloquear la app.")
                        .font(.caption)
                        .padding(.bottom)
                }
                
                Section(header: Text("ACCOUNT")) {
                    NavigationLink(destination: PaymentView()) {
                        Text("Método de pago")
                    }
                    Text("Registra un método de pago para hacer compras desde la app.")
                        .font(.caption)
                        .padding(.bottom)
                }
                
                Section(header: Text("ABOUT")) {}
                
                NavigationLink(destination: HelpView()) {
                    Text("Ayuda")
                }
                NavigationLink(destination: AffinWebsiteView()) {
                    Text("Ir a guich.mx")
                }
                NavigationLink(destination: TermsOfUseView()) {
                    Text("Términos de uso")
                }
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Política de privacidad")
                }
                NavigationLink(destination: LogOut(isAuthenticated: $isAuthenticated)) {
                    Text("Cerrar Sesión")
                }
            }
            .navigationBarTitle("Ajustes", displayMode: .inline)
        }
    }
}


struct PaymentView: View {
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var cardNumber: String = ""
    @State private var expirationDate: String = ""
    @State private var cvv: String = ""
    @State private var paypalEmail: String = ""

    enum PaymentMethod: String, CaseIterable {
        case creditCard, paypal
    }

    var body: some View {
        VStack {
            Picker("Payment Method", selection: $selectedPaymentMethod) {
                Text("Credit Card").tag(PaymentMethod.creditCard)
                Text("PayPal").tag(PaymentMethod.paypal)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedPaymentMethod == .creditCard {
                VStack {
                    TextField("Card Number", text: $cardNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Expiration Date", text: $expirationDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
            } else if selectedPaymentMethod == .paypal {
                TextField("PayPal Email", text: $paypalEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Button("Add Payment Method") {
                // Lógica para agregar el método de pago seleccionado
                print("Add payment method: \(selectedPaymentMethod)")
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        .navigationTitle("Add Payment Method")
    }
}


struct HelpView: View {
    var body: some View {
        Text("Help View")
    }
}

struct AffinWebsiteView: View {
    var body: some View {
        Link(destination: URL(string: "https://www.guich.mx")!) {
            Text("Go to guich.mx")
        }
    }
}

struct TermsOfUseView: View {
    var body: some View {
        Text("Terms of Use View")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy View")
    }
}

struct LogOut: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack {
            Text("Cerrar Sesión")
                .font(.largeTitle)
                .padding()

            Button(action: {
                logout()
            }) {
                Text("Cerrar Sesión")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }

    func logout() {
        // Eliminar credenciales del Keychain
        KeychainHelper.shared.delete(service: "com.tuapp.login", account: "userCredentials")
        // Actualizar el estado de autenticación
        isAuthenticated = false
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
