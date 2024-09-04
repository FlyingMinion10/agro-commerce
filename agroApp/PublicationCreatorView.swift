import SwiftUI

// MARK: - Tag
struct Taag: Identifiable {
    let id = UUID()
    var name: String
}

struct ContainerBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            // .overlay(
            //     RoundedRectangle(cornerRadius: 16)
            //         .stroke(Color.accentColor, lineWidth: 2)
            // )
    }
}

// Paso 3: Extensión de View para aplicar el estilo fácilmente
extension View {
    func ContainerBox() -> some View {
        self.modifier(ContainerBoxModifier())
    }
}

struct PublicationCreatorView: View {
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    @State private var product: String = ""
    @State private var productDescription: String = ""
    @State private var isShowingImagePicker: Bool = false
    @Environment(\.dismiss) var dismiss

    @State private var tags: [Taag] = [
            Taag(name: "Taag 1"),
            Taag(name: "Taag 2"),
            Taag(name: "Taag 3"),
            Taag(name: "Taag 4"),
            Taag(name: "Taag 5"),
            Taag(name: "Taag 6"),
            Taag(name: "Taag 7"),
            Taag(name: "Taag 8") ]
    var body: some View {
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
                Text("Crear una publicación")
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
            .padding(.bottom, 10)
            
            // MARK: - Publisher Name
            HStack {
                Text(publisherName)
                    .frame(width: 360)
                    .ContainerBox()
                    .font(.custom("Sans Serif", size: 25))
            }
            
            // MARK: - Product Details
            HStack {
                if !product.isEmpty {
                    Image(product)
                        .resizable()
                        .frame(width: 130, height: 222.5)
                        .ContainerBox()
                }
                VStack {
                    TextField("Producto", text: $product)
                        .bold()
                        .font(.custom("Sans Serif", size: 25))
                        .padding(.leading, 10)
                        .frame(width: 217.5)
                        .ContainerBox()
                    TextEditor(text: $productDescription)
                        .padding(.leading, 10)
                        .frame(width: 217.5, height: 152.5)
                        .ContainerBox()
                        .onChange(of: productDescription) { newValue in
                            let limite = 140 // Establece tu límite de caracteres aquí
                            if newValue.count > limite {
                                productDescription = String(newValue.prefix(limite))
                            }
                        }
                }
                .frame(width: 222.5)
            }
            .padding(.top)
            .frame(width: 360)
            
            // MARK: - Tags
            HStack {
                VStack {
                    ForEach(tags.prefix(tags.count / 2), id: \.id) { tag in
                        Text(tag.name)
                        Spacer()
                    }
                }
                .frame(width: 160, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 30)
                VStack {
                    ForEach(tags.suffix(tags.count - tags.count / 2), id: \.id) { tag in
                        Text(tag.name)
                        Spacer()
                    }
                }
                .frame(width: 160, alignment: .leading)
                .padding(.top, 30)
            }
            .frame(width: 360, height: 260)
            .ContainerBox()
            .padding(.top)
            
            Spacer()
        }
        .background(Color.gray.opacity(0.2))
    }
}

struct PublicationCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        PublicationCreatorView()
    }
}
