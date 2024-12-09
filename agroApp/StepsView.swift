import SwiftUI
import Foundation

struct InfoTutoRec: View {
    let number: Int
    let text: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(number)")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 30, height: 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(text)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct dismiss_header: View {
    var title: String
    let screenWidth = UIScreen.main.bounds.width
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack{
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24))
            }
            Spacer()
            Text(title)
                .font(.system(size: 30))
                .foregroundStyle(Color.black.opacity(0.9))
                .padding(.vertical, 20)
            Spacer()
            Button(action: {
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 24))
            }
        }
        .padding()
        .frame(width: screenWidth, height: 60)
        .background(Color.white)

    }
}

struct StepsView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // State Variables
    private let myAccountType: String = ProfileView.accountType
    @State var tranStep: Int?
    
    // Variables heredadas desde ChatsView para la negociación
    var interaction_id: Int
    var producto_completo: String
    var buyer: String
    var seller: String
    var currentStep: Int
    
    // Importar elemento para volver a la vista anterior
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    Text("Pasos")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.black.opacity(0.9))
                        .padding(.vertical, 20)
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)
                ScrollView{}
            }
            .onAppear {
            if currentStep > 4 {
                fetchTranStep(interactionID: interaction_id)
            }
        }
//            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
    }

    func fetchTranStep(interactionID: Int) {
    // func fetchStartingValues() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/tran-step/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interactionID)), // Convertir Int? a String?
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
                print("Error al obtener tranStep: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos de la bodega.")
                return
            }

            // Imprimir los datos recibidos en formato JSON
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("Datos recibidos del servidor StepView: \(jsonString)") // PRINT FOR DEBUG
            // }

            do {
                let decodedResponse = try JSONDecoder().decode([StepResponse].self, from: data)
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        if let firstResponse = decodedResponse.first {
                            print("Datos decodificados correctamente: \(firstResponse)") // PRINT FOR DEBUG
                            self.tranStep = firstResponse.tran_step
                        }
                    }

                }
            } catch {
                print("Error al decodificar datos de StepView: \(error)")
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


struct StepResponse: Codable {
    let tran_step: Int
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(interaction_id: 3, producto_completo: "Aguacate Hass", buyer: "p", seller: "j", currentStep: 15)
    }
}
