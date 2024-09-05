import SwiftUI
import PhotosUI

// MARK: - Tag
struct Taag: Identifiable {
    let id = UUID()
    var category: String
    var value: String
}

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

    @State private var selectedProduct = "Seleccionar" // Valor inicial, asegúrate de que
//    static let products: [String]? = Stock.productos
    
   @State private var selectedVariery = "Seleccionar" // Valor inicial, asegúrate
//    static let variety: [String]? = Stock.variedades

    @State private var productDescription: String = ""
    @State private var priceRatio:  String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var tags: [Taag] = [
        Taag(category: "Producto", value: ""),
        Taag(category: "Variedad", value: ""),
        Taag(category: "Calidad", value: ""),
        Taag(category: "Región", value: ""),
        Taag(category: "Tamaño", value: ""),
        Taag(category: "Frescura", value: ""),
        Taag(category: "Sabor", value: ""),
        Taag(category: "Color", value: "")
    ]
    
    @Environment(\.dismiss) var dismiss
    
    // Crea un NumberFormatter para números flotantes


    var body: some View {
        NavigationView {
            
            ScrollView {
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
                            Picker("Variedades", selection: $selectedVariery) {
                                // Asumiendo que Stock.variedades es un diccionario [String: [String]]
                                // donde la clave es el nombre del producto y el valor es un array de variedades
                                ForEach(Stock.variedades[selectedProduct] ?? [], id: \.self) { variedad in
                                    Text(variedad).tag(variedad)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
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
                    
                    // MARK: - Price ratio
                    VStack(spacing: 15) {
                        HStack {
                            Text("$")
                                .padding(.trailing) // Añade un poco de espacio
                                .bold()
                            TextField("Ratio de Precio", text: $priceRatio)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                    .containerBox()
                    
                    // MARK: - Tags
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Tags")
                            .font(.headline)
                        TextField("Producto", text: $tags[0].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Variedad", text: $tags[1].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Calidad", text: $tags[2].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Región", text: $tags[3].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Tamaño", text: $tags[4].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Frescura", text: $tags[5].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Sabor", text: $tags[6].value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Color", text: $tags[7].value)
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
    
    // MARK: - Helper Functions
    func isFormValid() -> Bool {
        return !selectedProduct.isEmpty && !productDescription.isEmpty && !priceRatio.isEmpty
    }
    
    func saveToDatabase() {
        // Implementa la lógica para guardar en la base de datos SQL aquí
        // Puedes utilizar frameworks como Alamofire para hacer peticiones HTTP
        
        let productData = [
            "publisherName": publisherName,
            "product": selectedProduct,
            "productDescription": productDescription,
            "tags": tags.map { $0.category },
            // "image": Convertir la imagen a un formato adecuado para enviar
        ] as [String : Any]
        
        print("Datos a guardar:", productData)
        // Añade la lógica de guardado aquí
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
