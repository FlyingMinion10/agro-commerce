import SwiftUI
import Combine

struct Publication: Identifiable {
    var id = UUID()
    var cPublisherName: String 
    var cPublisherType: String 
    var cPublisherScore: Int 
    var cPublisherPhoto: String 
    var cSelectedProduct: String
    var cSelectedVariery: String
    var cProductDescription: String
    var cPriceRatio:  String
    var cProductQuantity: String
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
            Publication(cPublisherName: "Felipe", cPublisherType: "Productor1", cPublisherScore: 5, cPublisherPhoto: "TuLogo", cSelectedProduct: "Manzana", cSelectedVariery: "Golden", cProductDescription: "Description 1", cPriceRatio: "17.4", cProductQuantity: "25", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Manzana"),
                Tag(category: "Variedad", value: "Golden"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "California"),
                Tag(category: "Tamaño", value: "Grande"),
                Tag(category: "Frescura", value: "Fresca"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Rojo")
            ]),
            Publication(cPublisherName: "Pablo", cPublisherType: "Productor2", cPublisherScore: 4, cPublisherPhoto: "TuLogo", cSelectedProduct: "Lechuga", cSelectedVariery: "Iceberg", cProductDescription: "Description 2", cPriceRatio: "29.92", cProductQuantity: "10", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Lechuga"),
                Tag(category: "Variedad", value: "Iceberg"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Michoacan"),
                Tag(category: "Tamaño", value: "Mediano"),
                Tag(category: "Frescura", value: "Fresca"),
                Tag(category: "Sabor", value: "Suave"),
                Tag(category: "Color", value: "Verde")
            ]),
            Publication(cPublisherName: "Dustin", cPublisherType: "Productor3", cPublisherScore: 3, cPublisherPhoto: "TuLogo", cSelectedProduct: "Jitomate", cSelectedVariery: "Cherry", cProductDescription: "Description 3", cPriceRatio: "48.5", cProductQuantity: "17", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Tomate"),
                Tag(category: "Variedad", value: "Cherry"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Colima"),
                Tag(category: "Tamaño", value: "Pequeño"),
                Tag(category: "Frescura", value: "Fresco"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Rojo")
            ]),
            Publication(cPublisherName: "Paco", cPublisherType: "Productor4", cPublisherScore: 5, cPublisherPhoto: "TuLogo", cSelectedProduct: "Maíz", cSelectedVariery: "Amarillo", cProductDescription: "Description 4", cPriceRatio: "2.63", cProductQuantity: "32", cSelectedImage: nil, cTags: [
                Tag(category: "Producto", value: "Maiz"),
                Tag(category: "Variedad", value: "Amarillo"),
                Tag(category: "Calidad", value: "Alta"),
                Tag(category: "Región", value: "Jalisco"),
                Tag(category: "Tamaño", value: "Grande"),
                Tag(category: "Frescura", value: "Fresco"),
                Tag(category: "Sabor", value: "Dulce"),
                Tag(category: "Color", value: "Amarillo")
            ])
            // ...
        ]
        filteredPublications = publications
    }

    func filterPublications(by selectedTags: [Tag]) {
    if selectedTags.isEmpty {
        filteredPublications = publications
    } else {
        filteredPublications = publications.filter { publication in
            for tag in selectedTags {
                if publication.cTags.contains(where: { $0.category == tag.category && $0.value == tag.value }) {
                    return true
                }
            }
            return false
        }
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
                    ScrollView {
                        // NavigationView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(viewModel.filteredPublications) { publication in
                                    NavigationLink(destination: DetailView(publication: publication)) {
                                        VStack {
                                            Image(publication.cSelectedProduct)
                                                .resizable()
                                            Text(publication.cSelectedProduct + " " + publication.cSelectedVariery)
                                            Divider()
                                            HStack {
                                                Image(publication.cPublisherPhoto)
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                Spacer()
                                                VStack {
                                                    HStack {
                                                        ForEach(1...5, id: \.self) { index in
                                                            Image(systemName: index <= publication.cPublisherScore ? "star.fill" : "star")
                                                                .foregroundColor(index <= publication.cPublisherScore ? .yellow : .gray)
                                                                .padding(-5)
                                                        }
                                                    }
                                                    .frame(width: 50)
                                                    Text(publication.cPublisherName)
                                                }
                                                Spacer()
                                            }
                                            Divider()
                                            Text("$" + publication.cPriceRatio + "/kg")
                                            Divider()
                                            Text(publication.cProductQuantity + " Toneladas")
                                        }
                                        .foregroundColor(.black)
                                        .frame(width: 140, height: 250)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            // .navigationTitle("Publicaciones")
                            .padding()
                        // }
                    }
                    Spacer()
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

struct DetailView: View {
    @StateObject var viewModel = PublicationViewModel()
    let screenWidth = UIScreen.main.bounds.width 
    let screenHeight = UIScreen.main.bounds.height 
    var publication: Publication // Asume que tienes un modelo `Publication`

    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image(publication.cPublisherPhoto)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal, 20)
//                    Spacer()
                    VStack {
                        HStack {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= publication.cPublisherScore ? "star.fill" : "star")
                                    .foregroundColor(index <= publication.cPublisherScore ? .yellow : .gray)
                                    .padding(-5)
                            }
                        }
                        .frame(width: 50)
                        Text(publication.cPublisherName)
                    }
                    .padding(.horizontal, 20)
                }
                Divider()
                HStack {
                    Image(publication.cSelectedProduct)
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    VStack {
                        Text(publication.cSelectedProduct + " " + publication.cSelectedVariery)
                            .bold()
                        Text(publication.cProductDescription)
                    }
                }
                .frame(height: 150)
                Divider()
                
                Text("$" + publication.cPriceRatio + "/kg")
                
                Divider()
                Text(publication.cProductQuantity + " Toneladas")
                Spacer()
            }
            .frame(width: screenWidth-10, height: 600)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray, radius: 8, x: 0, y: 4) // Corrección aplicada aquí
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(publication: Publication(cPublisherName: "Felipe", cPublisherType: "Productor1", cPublisherScore: 5, cPublisherPhoto: "TuLogo", cSelectedProduct: "Manzana", cSelectedVariery: "Golden", cProductDescription: "Manzana gala producida en california importada por grupo Alcaraz SA de CV.", cPriceRatio: "17.4", cProductQuantity: "25", cSelectedImage: nil, cTags: [
            Tag(category: "Producto", value: "Manzana"),
            Tag(category: "Variedad", value: "Golden"),
            Tag(category: "Calidad", value: "Alta"),
            Tag(category: "Región", value: "California"),
            Tag(category: "Tamaño", value: "Grande"),
            Tag(category: "Frescura", value: "Fresca"),
            Tag(category: "Sabor", value: "Dulce"),
            Tag(category: "Color", value: "Rojo")
        ]))
    }
}
