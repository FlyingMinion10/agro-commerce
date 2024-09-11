import SwiftUI

// Tag debe conformar a Codable (Decodable + Encodable)
struct Tag: Identifiable, Codable {
    var id: String { category + value }  // En caso de que el ID no sea proporcionado en el JSON
    var category: String
    var value: String
}

// Publication debe conformar a Codable (Decodable + Encodable)
struct Publication: Identifiable, Codable {
    var id: Int
    var cPublisherName: String
    var cPublisherType: String
    var cSelectedProduct: String
    var cSelectedVariety: String
    var cProductDescription: String
    var cProductQuantity: String
    var cPriceRatio: [String]
    var cTags: [Tag]
}

struct PublicationListView: View {
    @State private var publications: [Publication] = []
    
    @State private var selectedDisplayView: displayView = .buyer
    enum displayView: String, CaseIterable {
        case producer, buyer
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Modelo de vista", selection: $selectedDisplayView) {
                    Text("Comprador").tag(displayView.buyer)
                    Text("Productor").tag(displayView.producer)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                if publications.isEmpty {
                    Text("No se encontraron publicaciones.")
                        .padding()
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
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/publications/get") else {
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
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos del servidor: \(jsonString)")
            }

            do {
                let decodedPublications = try JSONDecoder().decode([Publication].self, from: data)
                DispatchQueue.main.async {
                    self.publications = decodedPublications
                    print("Publicaciones decodificadas correctamente: \(decodedPublications)")
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


struct DetailView: View {
   @State private var dSelectedPrice = "" // Change @StateObject to @State
   @State private var dSelectedQuantity = ""
   @State private var dSelectedTransport = ""

   let screenWidth = UIScreen.main.bounds.width
   let screenHeight = UIScreen.main.bounds.height
   var publication: Publication // Assume you have a `Publication` model

   
   var body: some View {
       VStack {
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
                   VStack(alignment: .center, spacing: 30) {
                       Text("Precio por tonelada:")
                       Picker("Precio", selection: $dSelectedPrice) { // Remove the explicit type annotation
                           ForEach(publication.cPriceRatio, id: \.self) { item in
                               Text(item + " /ton").tag(item) // Remove the unnecessary type conversion
                           }
                       }
                       .foregroundColor(.black)
                       .pickerStyle(MenuPickerStyle())
                       TextField("Toneladas", text: $dSelectedQuantity)
                           .keyboardType(.numberPad)
                           .frame(width: 100)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                       Text("Transporte:")
                       Picker("Transporte", selection: $dSelectedTransport) { // Remove
                           ForEach(Stock.transporte, id: \.self) { medio in
                               Text(medio).tag(medio) // Remove the unnecessary type conversion
                           }
                       }
                       .foregroundColor(.black)
                       .pickerStyle(MenuPickerStyle())
                   }
                   .frame(width: 200)
               }
           }
           .frame(width: screenWidth-10, height: 600)
           .padding()
           .background(Color.white)
           .clipShape(RoundedRectangle(cornerRadius: 8))
           .shadow(color: .gray, radius: 8, x: 0, y: 4) // Corrección aplicada aquí
       }
   }
}


        
struct PublicationListView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationListView()
    }
}
