import SwiftUI
import PhotosUI
import Foundation
// import Alamofire

// MARK: - Tag struct and PriceTonPair struct
struct Taag: Identifiable {
    let id = UUID()
    var category: String
    var value: String
}

struct PriceTonPair {
    var price: String
    var tonRange: String
}

// MARK: - Box modifiers
struct ContainerBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func containerBox() -> some View {
        self.modifier(ContainerBoxModifier())
    }
}

struct PublicationCreatorView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    let publisherType: String = ProfileView.accountType
    // let publisherScore: Int = ProfileView.reputationScore
    // let publisherPhoto: Image = ProfileView.profileImage

    @State private var selectedProduct = "Seleccionar" // Valor inicial, asegúrate de que
    @State private var selectedVariety = "Seleccionar" // Valor inicial, asegúrate
    @State private var productDescription: String = ""
    @State private var priceTonPairs: [PriceTonPair] = []
    @State private var price: String = ""
    @State private var tonRange: String = ""
    @State private var productQuantity:  String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var tags: [Taag] = [
        Taag(category: "Calidad", value: ""),
        Taag(category: "Region", value: ""),
        Taag(category: "Tamano", value: ""),
        Taag(category: "Frescura", value: ""),
        Taag(category: "Sabor", value: ""),
        Taag(category: "Olor", value: "")
    ]

    // Nuevo estado para controlar la alerta
    @State private var showSuccessAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    // Crea un NumberFormatter para números flotantes


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
                    Text("Públicar como \(publisherType)")
                        .font(.system(size: 24))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                }
                .padding(.bottom,20)
                .padding(.horizontal, 30)
                .frame(width: screenWidth)
                .background(Color.white)
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.gray), alignment: .bottom // Color y alineación del borde
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // MARK: - Publisher Name
                        Text(publisherName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .containerBox()
                        
                        // MARK: - Product Image
                        VStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        showImagePicker = true
                                    }
                            } else if !selectedProduct.isEmpty {
                                Group {
                                    if let uiImage = UIImage(named: selectedProduct) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .onTapGesture {
                                                showImagePicker = true
                                            }
                                    } else {
                                        // Devuelve un View vacío o un placeholder si no hay imagen
                                        EmptyView()
                                    }
                                }
                            } else {
                                Button(action: {
                                    showImagePicker = true
                                }) {
                                    VStack {
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.gray)
                                        Text("Agregar Imagen")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(height: 200)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .containerBox()
                        
                        // MARK: - Product Details
                        VStack(spacing: 15) {
                            HStack {
                                Text("Producto:")
                                    .padding(.trailing) // Añade un poco de espacio
                                    .bold()
                                Spacer()
                                Picker("Productos", selection: $selectedProduct) {
                                    ForEach(Stock.productos, id: \.self) { producto in
                                        Text(producto).tag(producto)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            
                            HStack {
                                Text("Variedad:")
                                    .padding(.trailing) // Añade un poco de espacio
                                    .bold()
                                Spacer()
                                Picker("Variedades", selection: $selectedVariety) {
                                    ForEach(Stock.variedades[selectedProduct] ?? [], id: \.self) { variedad in
                                        Text(variedad).tag(variedad)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            }
                            HStack {
                                Text("Descripción:")
                                Spacer()
                            }
                            .bold()
                            TextEditor(text: $productDescription)
                                .frame(height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .onChange(of: productDescription) { newValue in
                                    let limit = 140
                                    if newValue.count > limit {
                                        productDescription = String(newValue.prefix(limit))
                                    }
                                }
                        }
                        .padding(.horizontal)
                        .containerBox()
                        
                        // MARK: - Quantity of product
                        VStack(spacing: 15) {
                            HStack {
                                TextField("Toneladas", text: $productQuantity)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("Ton")
                                    .padding(.trailing) // Añade un poco de espacio
                                    .bold()
                            }
                        }
                        .padding(.horizontal)
                        .containerBox()
                        
                        // MARK: - Price ratio
                        VStack(spacing: 15) {
                            Text("Rango de precios")
                            ForEach($priceTonPairs.indices, id: \.self) { index in
                                HStack {
                                    Text("$")
                                        .padding(.trailing) // Añade un poco de espacio
                                        .bold()
                                    TextField("Precio", text: $priceTonPairs[index].price)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    Text("|")
                                        .bold()
                                        .padding(.horizontal) // Añade espacio a ambos lados
                                    TextField("Rango ton", text: $priceTonPairs[index].tonRange)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    Button(action: {
                                        priceTonPairs.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            Button(action: {
                                self.priceTonPairs.append(PriceTonPair(price: self.price, tonRange: self.tonRange))
                                // Limpia los campos después de añadir
                                self.price = ""
                                self.tonRange = ""
                            }) {
                                Text("+")
                            }
                        }
                        .padding(.horizontal)
                        .containerBox()
                        
                        // MARK: - Tags
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tags")
                                .font(.headline)
                            TextField("Calidad", text: $tags[0].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Región", text: $tags[1].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Tamaño", text: $tags[2].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Frescura", text: $tags[3].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Sabor", text: $tags[4].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Olor", text: $tags[5].value)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        }
                        .padding(.horizontal)
                        .containerBox()
                        
                        // MARK: - Submit Button
                        Button(action: {
                            saveToDatabase()
                        }) {
                            Text("Publicar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                                // Mostrar la alerta cuando `showSuccessAlert` es verdadero
                                .alert(isPresented: $showSuccessAlert) {
                                    Alert(
                                        title: Text("¡Éxito!"),
                                        message: Text("Publicación creada exitosamente."),
                                        dismissButton: .default(Text("OK"), action: {
                                            // Reiniciar la alerta después de que se cierre
                                            showSuccessAlert = false
                                        })
                                    )
                                }
                        }
                        .padding(.horizontal)
                        .disabled(!isFormValid())
                        .opacity(isFormValid() ? 1 : 0.5)
                        
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                }
                //            .navigationTitle("Crear Publicación")
                //            .navigationBarTitleDisplayMode(.inline)
                //            .toolbar {
                //                ToolbarItem(placement: .navigationBarLeading) {
                //                    Button(action: {
                //                        dismiss()
                //                    }) {
                //                        Image(systemName: "chevron.backward")
                //                            .foregroundColor(.blue)
                //                    }
                //                }
                //            }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    func isFormValid() -> Bool {
        return !selectedProduct.isEmpty && !productDescription.isEmpty && !priceTonPairs.isEmpty && !productQuantity.isEmpty
    }

    func clearForm() {
        selectedProduct = "Seleccionar"
        selectedVariety = "Seleccionar"
        productDescription = ""
        priceTonPairs = []
        price = ""
        tonRange = ""
        productQuantity = ""
        selectedImage = nil
        tags = [
            Taag(category: "Calidad", value: ""),
            Taag(category: "Region", value: ""),
            Taag(category: "Tamano", value: ""),
            Taag(category: "Frescura", value: ""),
            Taag(category: "Sabor", value: ""),
            Taag(category: "Olor", value: "")
        ]
    }

    func saveToDatabase() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/publications/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Formatear priceTonPairs como un array de objetos con "tonRange" y "price"
        let priceTonPairsFormatted = priceTonPairs.map { ["tonRange": String($0.tonRange), "price": String($0.price)] }

        // Formatear tags como un objeto con propiedades
        let tagsFormatted: [String: String] = [
            "Calidad": tags.first(where: { $0.category == "Calidad" })?.value ?? "",
            "Region": tags.first(where: { $0.category == "Region" })?.value ?? "",
            "Tamano": tags.first(where: { $0.category == "Tamano" })?.value ?? "",
            "Frescura": tags.first(where: { $0.category == "Frescura" })?.value ?? "",
            "Sabor": tags.first(where: { $0.category == "Sabor" })?.value ?? "",
            "Olor": tags.first(where: { $0.category == "Olor" })?.value ?? ""
        ]

        // Crear el diccionario con los datos formateados
        let productData: [String: Any] = [
            "publisherName": publisherName,
            "publisherType": publisherType,
            "selectedProduct": selectedProduct,
            "selectedVariety": selectedVariety,
            "productDescription": productDescription,
            "priceTonPairs": priceTonPairsFormatted, // Array de objetos
            "productQuantity": String(productQuantity), // Como cadena
            "tags": tagsFormatted // Objeto con propiedades específicas
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: productData, options: []) else {
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
                    clearForm()
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}

struct PublicationCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationCreatorView()
    }
}
