import SwiftUI

struct DetailTransport: Decodable {
    let fecha_de_corte: String
    let fecha_de_llegada: String
    let coste_flete: String
    let tipo_de_camion: String
}

struct TransporteStep: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    let userType: String = ProfileView.accountType
    let userEmail: String = ProfileView.email

    // Condiciones importadas de CHATVIEW
    var interaction_id: Int
    var producto_completo: String
    
    // Valores a recopilar para crear la orden de transporte
    @State private var fecha_de_corte: String = "fecha_de_corte"
    @State private var fecha_de_llegada: String = "fecha_de_llegada"
    @State private var coste_flete: String = "coste_flete"
    @State private var tipo_de_camion: String = "tipo_de_camion"
    
    @State private var fecha_de_llegada_con: String = "fecha_de_llegada"
    @State private var coste_flete_con: String = "coste_flete"
    @State private var transportEnterprise: String = "Grupo castores"
    
    
    // Nuevo estado para controlar la alerta
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    Text("Negociación del transporte")
                        .font(.system(size: 24))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.accentColor), alignment: .bottom // Color
                )
                
                // MARK: - Datos iniciales
                VStack (alignment: .leading) {
                    HStack {
                        Image(producto_completo.components(separatedBy: " ").first ?? "Manzana") // Remplazar por la imagen del producto real
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text(producto_completo)
                            .font(.system(size: 25))
                    }
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Fecha de corte:")
                            Text("Fecha de llegada:")
                            Text("Coste de flete:")
                            Text("Tipo de camión:")
                        }
                        Spacer()
                        VStack (alignment: .leading) {
                            Text(fecha_de_corte)
                            Text(fecha_de_llegada)
                            Text(coste_flete)
                            Text(tipo_de_camion)
                        }
                        .bold()
                        Spacer(minLength: 50)
                    }
                }
                .padding()
                .frame(width: screenWidth-40)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.accentColor), alignment: .bottom // Color
                )
                
                // MARK: - Ofertas
                ScrollView {
                    HStack {
                        VStack {
                            Text(transportEnterprise)
                                .font(.system(size: 18))
                                .textCase(.uppercase)
                            HStack {
                                Image("TuLogo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                Text("5")
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                            .font(.system(size: 25))
                        }
                        .frame(width: 200)
                        Divider()
                        VStack {
                            Text("$ \(coste_flete) MXN")
                            Divider()
                            Text("Fecha: \(fecha_de_llegada)")
                        }
                    }
                    .foregroundColor(.black)
                    .frame(width: 340, height: 100)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                .padding(.top, 20)
            }
            .onAppear(perform: fetchStartingValues) // fetchValues()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helper Functions

    func fetchStartingValues() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/step-three/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interaction_id)), // Convertir Int? a String?
        ]

        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching publications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos de la bodega.")
                return
            }

        //     // Imprimir los datos recibidos en formato JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
            }

            do {
                let decodedResponse = try JSONDecoder().decode([DetailTransport].self, from: data)
            DispatchQueue.main.async {
                print("BodegaStep Datos decodificados correctamente: \(decodedResponse)") // PRINT FOR DEBUG
        
                if let firstResponse = decodedResponse.first {
                    self.fecha_de_corte = firstResponse.fecha_de_corte
                    self.fecha_de_llegada = firstResponse.fecha_de_llegada
                    self.coste_flete = firstResponse.coste_flete
                    self.tipo_de_camion = firstResponse.tipo_de_camion
                }
            }
            } catch {
                print("Error al decodificar datos de la transporte: \(error)")
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

struct TransporteStep_Previews: PreviewProvider {
    static var previews: some View {
        TransporteStep(interaction_id: 3, producto_completo: "Aguacate Haas")
    }
}
