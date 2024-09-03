import SwiftUI

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
    
    @State private var publisherName: String = "Juan Felipe Zepeda" // Se añade
    @State private var productDescription: String = ""
    @State private var tags: [String] = []
    @State private var isShowingImagePicker: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
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
            HStack {
                Text(publisherName)
                    .frame(width: 360)
                    .ContainerBox()
                    .font(.custom("Sans Serif", size: 25))
                
            }
            HStack {
                Image("Cards1")
                    .resizable()
                    .frame(width: 130, height: 222.5)
                    .ContainerBox()
                VStack {
                    Text("Producto")
                        .bold()
                        .font(.custom("Sans Serif", size: 30))
                        .frame(width: 217.5)
                        .ContainerBox()
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero.")
                        .frame(width: 217.5, height: 152.5)
                        .ContainerBox()
                }
                .frame(width: 222.5)
            }
            .padding(.top)
            .frame(width: 360)
//            .padding()
            HStack {
                VStack {
                    ForEach(0..<4, id: \.self) { index in // Asume 3
                        Text("Tag \(index)")
                        Spacer()
                    }
                }
                .frame(width: 160, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 30)
                VStack {
                    ForEach(4..<8, id: \.self) { index in // Asume 3
                        Text("Tag \(index)")
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
