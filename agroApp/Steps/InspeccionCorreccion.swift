//
//  InspeccionCorreccionView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//
import SwiftUI

struct InspeccionCorreccion: View {
    var interaction_id: Int
    var seller: String

    @State private var tons: String = ""
    @State private var price: String = ""
    @State private var transport: String = ""
    @State private var percentages: String =  ""
    
    @State private var weight_1: String =  ""
    @State private var weight_2: String =  ""
    @State private var weight_3: String =  ""

    var body: some View {
        VStack(spacing: 20) {
            dismiss_header(title: "Inspección/Corrección")
            Divider()
            
            ScrollView {
                Text("¿Qué significa hacer una corrección y qué conlleva?")
                    .font(.title2)
                Text("Realizar una corrección en la compra-venta del producto implica modificar algún aspecto acordado previamente, como el precio, la cantidad, o los términos del contrato. Esto requiere la aprobación de ambas partes involucradas y conlleva una actualización del contrato original.")
                .foregroundStyle(Color.red)
                .italic()
                // Valores del Monopoly en la negociacion cv
                VStack() {
                    Text("Valores iniciales de la negociación")
                        .font(.system(size: 20))
                    Divider()
                    HStack {
                        VStack(alignment: .center) {
                            Text("Toneladas")
                                .bold()
                            Text(tons)
                            Spacer(minLength: 10)
                            Text("Precio")
                                .bold()
                            Text(price)
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Text("Transporte")
                                .bold()
                            Text(transport)
                            Spacer(minLength: 10)
                            Text("Porcentajes")
                                .bold()
                            Text(percentages)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(width: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)

                // Basculas
                VStack() {
                    Text("Pesos de las basculas")
                        .font(.system(size: 20))
                    Divider()
                    HStack {
                        VStack(alignment: .center) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                            Text("Bascula 1")
                                .bold()
                            Text(weight_1)
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                            Text("Bascula 2")
                                .bold()
                            Text(weight_2)
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Image(systemName: "scalemass.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.green)
                            Text("Bascula 3")
                                .bold()
                            Text(weight_3)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(width: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)

                // Evidencia del camion
                VStack(alignment: .leading, spacing: 10) {
                    Text("Evidencia del camion")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .frame(width: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)

                // Botones para corrección
                VStack(spacing: 15) {
                    Button(action: {
                        // Acción para hacer una corrección (por implementar)
                        requestCorrection()
                    }) {
                        Text("Quiero hacer una corrección en la compra venta del producto")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(16)
                    }
    

                    Button(action: {
                        // Acción para no hacer una corrección (por implementar)
                    }) {
                        Text("No quiero hacer una corrección")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(16)
                    }
    
                    .padding(.bottom, 30)
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            fetchOriginalMonopoly()
            getAllWeights()
        })
    }

    // Fetch datos del monopoly
    func fetchOriginalMonopoly() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/monopoly/get") else {
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
                print("No se recibieron datos Monopoly.")
                return
            }

            // Imprimir los datos recibidos en formato JSON
        //    if let jsonString = String(data: data, encoding: .utf8) {
        //        print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
        //    }

            do {
                let decodedMonopoly = try JSONDecoder().decode([Monopoly].self, from: data)
                DispatchQueue.main.async {
                    //print("Monopoly decodificado correctamente: \(decodedMonopoly)") // PRINT FOR DEBUG

                    if let firstMonopoly = decodedMonopoly.first {
                        self.tons = firstMonopoly.quantity
                        self.price = firstMonopoly.price
                        self.transport = firstMonopoly.transport
                        self.percentages = firstMonopoly.percentages
                    }
                }
            } catch {
                print("Error al decodificar el monopoly: \(error)")
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

    func getAllWeights() {
        // func fetchStartingValues() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/step-eight/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interaction_id)) // Convertir Int? a String?
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
                let decodedResponse = try JSONDecoder().decode([AllWeightsResponse].self, from: data)
                DispatchQueue.main.async {
                    //print("FormBodega Datos decodificados correctamente: \(decodedResponse)") // PRINT FOR DEBUG
            
                    if let firstResponse = decodedResponse.first {
                        self.weight_1 = firstResponse.peso_b1
                        self.weight_2 = firstResponse.peso_b2
                        self.weight_3 = firstResponse.peso_b3
                    }
                }
            } catch {
                print("Error al decodificar datos de getAllWeights: \(error)")
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

    func requestCorrection() {
        guard let url = URL(string: "\(Stock.endPoint)/api/step-eight/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos formateados
        let idToAcceptDeal: [String: Any] = [
            "interaction_id": interaction_id,
            "seller": seller
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: idToAcceptDeal, options: []) else {
            print("Error al serializar los datos para solicitar la corrección")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar los datos: \(error)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error en la respuesta del servidor requestCorrection()")
                return
            }

            do {
            //    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            //        print("Respuesta del servidor: \(json)")
            //        // Aquí puedes manejar la respuesta del servidor
            //    }
                
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct AllWeightsResponse: Codable {
    let peso_b1: String
    let peso_b2: String
    let peso_b3: String
}

struct InspeccionCorreccion_Previews: PreviewProvider {
    static var previews: some View {
        InspeccionCorreccion(interaction_id: 3, seller: "d")
    }
}
