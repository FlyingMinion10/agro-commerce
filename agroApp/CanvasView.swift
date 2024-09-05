import SwiftUI
import Combine

struct Publication: Identifiable, Codable {
    var id = UUID()
    var cPublisherName: String 
    var cPublisherType: String 
    var cSelectedProduct: String
    var cSelectedVariery: String
    var cProductDescription: String
    var cPriceRatio:  String
    var cSelectedImage: UIImage?
    var cTags: [Tag] = [
        Tag(category: "Producto", value: ""),
        Tag(category: "Variedad", value: ""),
        Tag(category: "Calidad", value: ""),
        Tag(category: "Región", value: ""),
        Tag(category: "Tamaño", value: ""),
        Tag(category: "Frescura", value: ""),
        Tag(category: "Sabor", value: ""),
        Tag(category: "Color", value: "")
    ]
}

struct Tag: Identifiable {
    let id = UUID()
    var category: String
    var value: String
}

class PublicationViewModel: ObservableObject {
    @Published var publications: [Publication] = []
    @Published var filteredPublications: [Publication] = []
    @Published var selectedTags: [Tag] = []
    @Published var isFilterViewPresented = false

    init() {
        // Dummy data
        publications = [
            Publication(cPublisherName: "Publisher 1", cPublisherType: "Type 1", cSelectedProduct: "Product 1", cSelectedVariery: "Variety 1", cProductDescription: "Description 1", cPriceRatio: "Ratio 1", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Manzana"),
                Tag(category: "Variedad", value: "Golden"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Valle del Cauca"),
                Tag(category: "Tamaño", value: "Grande"),
                Tag(category: "Frescura", value: "Fresca"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Rojo")
            ]),
            Publication(cPublisherName: "Publisher 2", cPublisherType: "Type 2", cSelectedProduct: "Product 2", cSelectedVariery: "Variety 2", cProductDescription: "Description 2", cPriceRatio: "Ratio 2", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Lechuga"),
                Tag(category: "Variedad", value: "Iceberg"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Local"),
                Tag(category: "Tamaño", value: "Mediano"),
                Tag(category: "Frescura", value: "Fresca"),
                Tag(category: "Sabor", value: "Suave"),
                Tag(category: "Color", value: "Verde")
            ]),
            Publication(cPublisherName: "Publisher 3", cPublisherType: "Type 3", cSelectedProduct: "Product 3", cSelectedVariery: "Variety 3", cProductDescription: "Description 3", cPriceRatio: "Ratio 3", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Tomate"),
                Tag(category: "Variedad", value: "Cherry"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Andalucía"),
                Tag(category: "Tamaño", value: "Pequeño"),
                Tag(category: "Frescura", value: "Fresco"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Rojo")
            ]),
            Publication(cPublisherName: "Publisher 4", cPublisherType: "Type 4", cSelectedProduct: "Product 4", cSelectedVariery: "Variety 4", cProductDescription: "Description 4", cPriceRatio: "Ratio 4", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Maiz"),
                Tag(category: "Variedad", value: "Amarillo"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "América"),
                Tag(category: "Tamaño", value: "Grande"),
                Tag(category: "Frescura", value: "Fresco"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Amarillo")
            ])
            // ...
        ]
        filteredPublications = publications
    }

    func filterPublications(by cTags: [Tag]) {
        filteredPublications = publications.filter { publication in
            publication.cTags.contains(where: { tag in cTags.contains(where: { $0.name == cTags.name }) })
        }
    }
}

struct CanvasView: View {
    @StateObject var viewModel = PublicationViewModel()
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
                
                if selectedDisplayView == .buyer {
                    VStack {
                        VStack {
                            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 8) {
                                ForEach(Stock.productos, id: \.self) { producto in
                                    Text(producto).tag(producto)
                                }
                            }
                            .padding(8)
                        }
                        
//                        Spacer()
                    }
                    .padding()
                } else if selectedDisplayView == .producer {
                    VStack {
                        Text("buyer")
                        Spacer()
                    }
                }
            }
            .background(Color.backstage)
//            .navigationTitle("Publications")
            
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
