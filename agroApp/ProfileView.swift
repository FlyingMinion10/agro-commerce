import SwiftUI

struct ProfileView: View {
    // Datos del perfil
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla

    static let profileName: String = "Juan Felipe Zepeda"
    static let accountType: String = "Productor"
    static let profileImage: Image = Image("TuLogo")
    static let reputationScore: Int = 94
    let profileBio: String = "Biografía del perfil"
    let followersCount: Int = 1200
    let postsCount: Int = 7

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Barra superior
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: SettingsView(userEmail: "usuario@example.com", userPassword: "password123")) {
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
                        
                        VStack(alignment: .leading) {
                            Text(ProfileView.profileName)
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text(profileBio)
                                .font(.subheadline)
                                .foregroundColor(.gray)
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
                    
                    // Botones de acción
                    HStack {
                        Button(action: {
                            // Acción al presionar el botón "Seguir"
                        }) {
                            Text("Seguir")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 120)
                                .padding(.vertical, 10)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: {
                            // Acción al presionar el botón "Mensaje"
                        }) {
                            Text("Mensaje")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 120)
                                .padding(.vertical, 10)
                                .background(Color.accentColor)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: {
                            // Acción al presionar el botón "Correo electrónico"
                        }) {
                            Image(systemName: "envelope")
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 20)
                    .padding(.horizontal, 40)
                    
                    // Publicaciones
                    VStack {
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 8) {
                            ForEach(0..<10, id: \.self) { index in
                                // Mostrar imagen de publicación
                                VStack {
                                    Image("postImage\(index)")
                                        .resizable()
                                        .scaledToFit()
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding(8)
                    }
                    .background(Color.backstage)
                }
            }
        }
    }
}

struct SettingsView: View {
    @State private var passcodeLockEnabled = true
    @State private var faceIDEnabled = true
    var userEmail: String
    var userPassword: String

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("SECURITY")) {
                    Toggle(isOn: $faceIDEnabled) {
                        Text("Face ID")
                    }
                    .padding(.top)
                    .font(.headline)
                    Text("If your device has Touch ID or Face ID enabled, you can also use that to unlock the app.")
                        .font(.caption)
                        .padding(.bottom)
                }
                
                Section(header: Text("ACCOUNT")) {
                    NavigationLink(destination: PaymentView()) {
                        Text("Metodo de pago")
                    }
                    Text("Registra un metodo de pago para hacer compras desde la App")
                        .font(.caption)
                        .padding(.bottom)
                }
                
                Section(header: Text("ABOUT")) {}
                
                NavigationLink(destination: HelpView()) {
                    Text("Help")
                }
                NavigationLink(destination: AffinWebsiteView()) {
                    Text("Go to guich.mx")
                }
                NavigationLink(destination: TermsOfUseView()) {
                    Text("Terms of use")
                }
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                }
                NavigationLink(destination: DeleteAccountView()) {
                    Text("Delete Account")
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
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

struct DeleteAccountView: View {
    var body: some View {
        Text("Delete Account View")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
