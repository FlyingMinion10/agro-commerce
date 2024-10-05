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

struct PublicationBuyView: View {
    var publication: Publication
    var body: some View {
        VStack {
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

struct PublicationSellView: View {
    var publication: Publication
    var body: some View {
        HStack {
            VStack {
                Image(publication.cSelectedProduct)
                    .resizable()
                    .scaledToFit()
                Text(publication.cSelectedProduct + " " + publication.cSelectedVariety)
                    .font(.headline)
            }
            Divider()
            VStack {
                HStack {
                    Image("TuLogo")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(publication.cPublisherName)
                    Spacer()
                }
                HStack {
                    ForEach(1...5, id: \.self) { index in
                        Image(systemName: index <= 4 ? "star.fill" : "star")
                            .foregroundColor(index <= 4 ? .yellow : .gray)
                            .padding(.top, 5)
                    }
                }
                .frame(width: 50)
            }
            .frame(width: 150)
            Divider()
            VStack {
                Text("$\(publication.cPriceRatio[0]) /kg")
                Divider()
                Text("\(publication.cProductQuantity) Toneladas")
            }
        }
        .foregroundColor(.black)
        .frame(width: 360, height: 100)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - CanvasView
struct CanvasView: View {
    @State private var publications: [Publication] = []
    @State private var showFilterSidebar: Bool = false
    @State private var selectedDisplayView: displayView = .sell

    @State private var filterProduct = "Seleccionar"
    @State private var filterVariety = "Seleccionar"
    @State private var selectedRegion = "Todas"
    
    enum displayView: String, CaseIterable {
        case sell, buy
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {  // Fijamos el alineamiento de ZStack a la derecha
                VStack {
                    HStack {
                        Spacer(minLength: 100)
                        Picker("Modelo de vista", selection: $selectedDisplayView) {
                            Text("COMPRAR").tag(displayView.buy)
                            Text("VENDER").tag(displayView.sell)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .font(.title)
                        .padding(.top)
                        .onChange(of: selectedDisplayView) { newValue in
                            fetchPublications()
                        }
                        Spacer(minLength: 50)
                        
                        // MARK: - Filter button
                        Button(action: {
                            withAnimation {
                                showFilterSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .font(.title)
                                .padding(.top)
                        }
                        .padding(.trailing, 20)
                    }
                    
                    if publications.isEmpty {
                        VStack(spacing: 20) {
                            Text("No se encontraron publicaciones")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                            Text("Refresque la página o intente más tarde")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                            Image(systemName: "photo.badge.exclamationmark.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        Spacer()
                    } else {
                        ScrollView {
                            if selectedDisplayView == .buy {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    ForEach(publications) { publication in
                                        NavigationLink(destination: DetailView(publication: publication)) {
                                            PublicationBuyView(publication: publication)
                                        }
                                    }
                                }
                                .padding()
                            } else {
                                LazyVStack {
                                    ForEach(publications) { publication in
                                        NavigationLink(destination: DetailView(publication: publication)) {
                                            PublicationSellView(publication: publication)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                
                if showFilterSidebar {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showFilterSidebar.toggle()  // Cerrar el filtro cuando se toque fuera de la barra
                            }
                        }
                }
                
                // MARK: - Filter Sidebar
                VStack {
                    HStack {
                        Spacer()
                        Text("Filtros")
                            .font(.headline)
                            .padding()
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showFilterSidebar.toggle()  // Cerrar el filtro con el botón "X"
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    VStack {
                        Text("Filtrar por producto:")
                            .padding(.trailing) // Añade un poco de espacio
                            .bold()
                        Picker("Productos", selection: $filterProduct) {
                            ForEach(Stock.productos, id: \.self) { producto in
                                Text(producto).tag(producto)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    if filterProduct != "Seleccionar" {
                        VStack {
                            Text("Filtrar por variedad:")
                                .padding(.trailing) // Añade un poco de espacio
                                .bold()
                            Picker("Variedades", selection: $filterVariety) {
                                ForEach(Stock.variedades[filterProduct] ?? [], id: \.self) { variedad in
                                    Text(variedad).tag(variedad)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    VStack {
                        Text("Filtrar por región:")
                            .padding(.trailing) // Añade un poco de espacio
                            .bold()
                        Picker("Regíon", selection: $selectedRegion) {
                            ForEach(Stock.estados, id: \.self) { estado in
                                Text(estado).tag(estado)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    Button(action: {
                        applyFilters()
                        withAnimation {
                            showFilterSidebar.toggle()
                        }
                    }) {
                        Text("Aplicar filtros")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                
                    // Aquí añades tus opciones de filtros
                    Spacer()
                }
                .frame(width: 300, height: 600)
                .background(Color.white)
                // .shadow(color: .black, radius: 10, x: 0, y: 5) // Agregar sombra aquí
                .offset(x: showFilterSidebar ? 0 : 350) // Deslizar fuera del marco cuando esté oculto
                .animation(.easeInOut, value: showFilterSidebar) // Aplicar animación al cambiar el estado
            }
            .onAppear {
                fetchPublications()
            }
            .background(Color.backstage)
        }
    }
    
    // MARK: - Fetch Publications
    func fetchPublications(with additionalFilters: [String: String] = [:]) {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/publications/get") else {
            print("URL no válida")
            return
        }
        
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        var queryItems = [
            URLQueryItem(name: "filterType", value: "publisherType"),
            URLQueryItem(name: "primaryFilter", value: selectedDisplayView == .buy ? "Productor" : "Bodeguero")
        ]
        
        // Añadir filtros adicionales
        for (key, value) in additionalFilters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
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
            // Imprimir la respuesta del servidor para verificar la estructura
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Respuesta del servidor: \(jsonString)")
            }
    
            do {
                let decodedPublications = try JSONDecoder().decode([Publication].self, from: data)
                DispatchQueue.main.async {
                    self.publications = decodedPublications
                }
            } catch {
                print("Error decoding publications: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Llamar a la función fetchPublications con los filtros seleccionados
    func applyFilters() {
        var additionalFilters = [String: String]()
        
        if filterProduct != "Seleccionar" {
            additionalFilters["product"] = filterProduct
        }
        
        if filterVariety != "Seleccionar" {
            additionalFilters["variety"] = filterVariety
        }
        
        if selectedRegion != "Todas" {
            additionalFilters["region"] = selectedRegion
        }
        
        fetchPublications(with: additionalFilters)
    }
    
    func handleDecodingError(_ error: Error) {
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
