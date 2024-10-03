import SwiftUI

// Tag debe conformar a Codable (Decodable + Encodable)
struct Tag: Identifiable, Codable {
    var id: String { category + value }  // En caso de que el ID no sea proporcionado en el JSON
    var category: String
    var value: String
}

// Publication debe conformar a Codable (Decodable + Encodable)
struct Publication: Identifiable, Codable {
    var id: Int?
    var cPublisherName: String
    var cPublisherType: String
    var cPublisherEmail: String // Added for test
    var cSelectedProduct: String
    var cSelectedVariety: String
    var cProductDescription: String
    var cProductQuantity: String
    var cPriceRatio: [String]
    var cTags: [Tag]
}

// MARK: - CanvasView
struct CanvasView: View {
    @State private var publications: [Publication] = []
    
    @State private var selectedDisplayView: displayView = .buy
    enum displayView: String, CaseIterable {
        case sell, buy
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Modelo de vista", selection: $selectedDisplayView) {
                    Text("Comprar").tag(displayView.buy)
                    Text("Vender").tag(displayView.sell)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedDisplayView) {
                    fetchPublications()
                }
                if publications.isEmpty {
                    Text("No se encontraron publicaciones.")
                        .padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(publications) { publication in
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
                                        //                        Text(publication.cProductDescription)
                                        //                            .lineLimit(2)
                                        //                        Mostrar las etiquetas correctamente
                                        //                        ForEach(publication.cTags) { tag in
                                        //                            Text("\(tag.category): \(tag.value)")
                                        //                        }
                                        
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
                }
            }
            .onAppear {
                fetchPublications()
            }
            .background(Color.backstage)
        }
    }
    
    // Función para obtener todas las publicaciones
    func fetchPublications() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/publications/get") else {
            print("URL no válida")
            return
        }
        
        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "filterType", value: "publisherType"),
            URLQueryItem(name: "primaryFilter", value: selectedDisplayView == .buy ? "Productor" : "Bodeguero")
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

            // Imprimir los datos recibidos en formato JSON
//            if let jsonString = String(data: data, encoding: .utf8) {
//               print("Datos recibidos del servidor: \(jsonString)") PRINT FOR DEBUG
//            }

            do {
                let decodedPublications = try JSONDecoder().decode([Publication].self, from: data)
                DispatchQueue.main.async {
                    self.publications = decodedPublications
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

// MARK: - DetailView
struct DetailView: View {
    @State private var showSuccessAlert = false
    
    @State private var dOffertedPrice = "" // Change @StateObject to @State
    @State private var dRequestedQuantity = ""
    @State private var dSelectedTransport = ""
    @State private var showPopup = false
    @State private var porcentajeIzquierdo = 50

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var publication: Publication // Assume you have a `Publication` model
    let buyerEmail: String = ProfileView.email
    let buyerProfileName: String = ProfileView.profileName

   
   var body: some View {
       ZStack {
           VStack {
               HStack {
                   Image("TuLogo")
                       .resizable()
                       .frame(width: 70, height: 70)
                       .padding(.horizontal, 20)
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
                   .padding(.horizontal, 20)
                   Spacer()
               }
               Divider()
               HStack {
                   Image(publication.cSelectedProduct)
                       .resizable()
                       .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                       .padding(.trailing, 20)
                   VStack {
                       Text(publication.cSelectedProduct + " " + publication.cSelectedVariety)
                           .bold()
                       Text(publication.cProductDescription)
                   }
               }
               .frame(height: 150)
               
               Divider()
               Text(publication.cProductQuantity + " Toneladas")
               Divider()
               HStack {
                   VStack(alignment: .leading) {
                       ForEach(publication.cTags) { tag in
                           HStack { // Alinea el contenido a la izquierda
                               Text(tag.category)
                                   .font(.headline)
                               Text(tag.value)
                                   .font(.subheadline)
                                   .foregroundColor(.gray)
                           }
                           Spacer()
                       }
                   }
                   .padding(.leading, -10)
                   Divider()
                   VStack() {
                       VStack {
                           Text("Precio por kilogramo:")
                           
                           ForEach(publication.cPriceRatio, id: \.self) { item in
                               Text(item + " /kg").tag(item) // Remove the unnecessary type conversion
                           }
                           .foregroundColor(.black)
                       }
                       Spacer()
                       Button(action: {
                           showPopup = true
                       }) {
                           Text("Mostrar Pop-up")
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .cornerRadius(8)
                       }
                   }
                   .frame(width: 200)
                   .padding(.vertical, 40)
               }
           }
           .frame(width: screenWidth-10, height: 650)
           .padding()
           .background(Color.white)
           .clipShape(RoundedRectangle(cornerRadius: 8))
//           .shadow(color: .gray, radius: 8, x: 0, y: 4) // Corrección aplicada aquí
           .blur(radius: showPopup ? 3 : 0)

           if showPopup {
               VStack (spacing: 30) {
                   VStack {
                       Text("Precio por kilogramo:")
                           .textCase(.uppercase)
                           .padding(.bottom, 10)
                       ForEach(publication.cPriceRatio, id: \.self) { item in
                           Text(item + " /kg").tag(item) // Remove the unnecessary type conversion
                       }
                       .foregroundColor(.black)
                       TextField("Precio a ofertar ($ /kg)", text: $dOffertedPrice)
                           .keyboardType(.numberPad)
                           .frame(maxWidth: .infinity)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                   }
                   VStack {
                       Text("Toneladas a comprar")
                       TextField("Cantidad en toneladas", text: $dRequestedQuantity)
                           .keyboardType(.numberPad)
                           .frame(maxWidth: .infinity)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                   }
                   VStack {
                       Text("Transporte:")
                       Picker("Transporte", selection: $dSelectedTransport) {
                           ForEach(Stock.transporte, id: \.self) { medio in
                               Text(medio).tag(medio)
                           }
                       }
                       .foregroundColor(.black)
                       .pickerStyle(MenuPickerStyle())
                       
                       if dSelectedTransport == "A cargo de AFFIN" {
                           Text("Comprador \(porcentajeIzquierdo)% - \(100 - porcentajeIzquierdo)% Vendedor")
                           HStack {
                               Button(action: {
                                   if porcentajeIzquierdo > 0 {
                                       porcentajeIzquierdo += 1
                                   }
                               }) {
                                   Image(systemName: "arrow.left")
                               }
                               
                               Button(action: {
                                   if porcentajeIzquierdo < 100 {
                                       porcentajeIzquierdo -= 1
                                   }
                               }) {
                                   Image(systemName: "arrow.right")
                               }
                           }
                           .padding(.leading, 20)
                       }
                   }
                   Button(action: {
                       // action here
                       createInteraction()
                   }) {
                       Text("Enviar oferta")
                           .frame(width: 250)
                           .padding(10)
                           .background(Color.accentColor)
                           .foregroundColor(.white)
                           .cornerRadius(8)
                           .alert(isPresented: $showSuccessAlert) {
                               Alert(
                                   title: Text("¡Éxito!"),
                                   message: Text("Oferta enviada exitosamente."),
                                   dismissButton: .default(Text("OK"), action: {
                                       // Reiniciar la alerta después de que se cierre
                                       showSuccessAlert = false
                                   })
                               )
                           }
                   }
                   .disabled(!isFormValid())
                   .opacity(isFormValid() ? 1 : 0.5)
                   
                   Button(action: {
                       showPopup = false
                   }) {
                       Text("Cerrar")
                           .frame(width: 250)
                           .padding(10)
                           .background(Color.white)
                           .foregroundColor(.red)
                           .cornerRadius(8)
                           .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 2)
                           )
                   }
               }
               .frame(width: 300)
               .padding()
               .background(Color.white)
               .clipShape(RoundedRectangle(cornerRadius: 16))
               .shadow(color: .gray, radius: 8, x: 0, y: 4)
           }
        }
   }
    func isFormValid() -> Bool {
        return !dOffertedPrice.isEmpty && !dRequestedQuantity.isEmpty && !dSelectedTransport.isEmpty
    }
    
    // MARK: - Create interaction
    func createInteraction() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/interaction/create") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Establecer valores no definidos arriba
        var dTransportPercentages: String = "100-0"
        if dSelectedTransport == "A cargo de AFFIN" {
            dTransportPercentages = "\(porcentajeIzquierdo)-\(100 - porcentajeIzquierdo)"
        } else {
            dTransportPercentages = "100-0"
        }
        let item = publication.cSelectedProduct + " " + publication.cSelectedVariety
        
        print("buyerEmail", buyerEmail)
        // Crear el diccionario con los datos formateados
        let interactionInitData: [String: Any] = [
            "buyer": buyerEmail,
            "seller": publication.cPublisherEmail,
            "buyer_name": buyerProfileName,
            "seller_name": publication.cPublisherName,
            "item": item,
            "publication_id": publication.id as Any,
            "price": dOffertedPrice,
            "quantity": dRequestedQuantity,
            "transport": dSelectedTransport,
            "percentages": dTransportPercentages,
            "last_mod": buyerEmail,
            "accepted": false
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: interactionInitData, options: []) else {
            print("Error al serializar los datos del producto")
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
                print("Error en la respuesta del servidor")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta del servidor: \(json)")
                    // Aquí puedes manejar la respuesta del servidor
                    showSuccessAlert = true
//                    clearForm() MFM
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}


        
struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
