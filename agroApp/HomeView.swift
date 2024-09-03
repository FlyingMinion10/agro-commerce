import SwiftUI

// Modificadores para input boxes
struct ContainerBoxModifierH: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Sans Serif", size: 20))
            .frame(width: UIScreen.main.bounds.width - 30)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StockBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
// Modificadores para indicadores de precios


// Paso 3: Extensión de View para aplicar el estilo fácilmente
extension View {
    func ContainerBoxH() -> some View {
        self.modifier(ContainerBoxModifierH())
    }
    func StockBox() -> some View {
        self.modifier(StockBoxModifier())
    }
}

struct HomeView: View {
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla
    
    var body: some View {
        VStack {
            HStack {
                // TOP MENU // TOP MENU // TOP MENU //
                Text("Agro App")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.accentColor)
                    .padding(.leading, 15)
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 15)
                    .foregroundStyle(Color.accentColor)
            }
            .padding(.bottom,10)
            .frame(width: screenWidth)
            .background(Color.white)
            .overlay(
                Capsule()
                    .frame(height: 1) // Altura del borde
                    .foregroundColor(.gray), alignment: .bottom // Color y alineación del borde
            )
//            ScrollView {
//                VStack {
//                    
//                    // ENCABEZADO // ENCABEZADO // ENCABEZADO //
//                    HStack {
//                        Text("Noticias relevantes de la semana:")
//                            .font(.system(size: 30))
//                            .multilineTextAlignment(.center)
//                    }
//                    .frame(width: screenWidth)
//                    .padding(.bottom, 10)
//                    .background(Color.white)
//                    // CAROUSEL // CAROUSEL // CAROUSEL //
//                    TabView(selection: $currentIndex) {
//                        ForEach(0..<3, id: \.self) { index in // Asume 3 imágenes, ajusta según sea necesario
//                            Image("Carrousel\(index)")
//                                .resizable()
//                                .tag(index)
//                                .frame(width: screenWidth, height: 200)
//                        }
//                    }
//                    .padding(.top,-15)
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Estilo de TabView para carrusel
//                    .frame(width: screenWidth, height: 200)
//                    .onReceive(timer) { _ in
//                        withAnimation {
//                            currentIndex = (currentIndex + 1) % 3 // Cambia la imagen automáticamente
//                        }
//                    }
//                    
//                    // NOTICIAS // NOTICIAS // NOTICIAS //
//                    VStack {
//                        ForEach(0..<3, id: \.self) { index in
//                            VStack {
//                                Image("Cards\(index)")
//                                    .resizable()
//                                    .clipped()
//                                    .frame(height: 220)
////                                    .padding(0)
//                                VStack {
//                                    Text("Titulo de noticia")
//                                        .font(Font.custom("Noteworthy", size: 30))
//                                    Text("Lorem ipsum") // Texto debajo de la imagen
//                                        .font(Font.custom("Sans Serif", size: 20))
//                                }
//                                .padding(.bottom)
//                                .frame(height: 80)
//                                
//                            }
//                            .frame(width: screenWidth-30, height: 300)
//                            .background(Color.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 16))
//                            .padding(.bottom,20)
////                            .background(
////                                RoundedRectangle(cornerRadius: 16)
////                                    .fill(Color.white)
////                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
////                            )
//                        }
////                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//                    }
////                    .padding(.top, 15)
//                }
//                .background(Color.gray.opacity(0.2))
//            }
//            .background(Color.white)
            ScrollView {
                VStack {
                }
                    HStack {
                        HStack {
                            Image("postImage1")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Aguacate")
                        }
                        .frame(width: 200, alignment: .leading)
                        Image(systemName: "arrowshape.up.fill")
                            .foregroundStyle(Color.green)
                        Text("$40/kg")
                        Spacer()
                    }
                    .modifier(StockBoxModifier())
                    .ContainerBoxH()
                    HStack {
                        HStack {
                            Image("postImage4")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Maiz")
                        }
                        .frame(width: 200, alignment: .leading)
                        Image(systemName: "arrowshape.down.fill")
                            .foregroundStyle(Color.red)
                        Text("$12/kg")
                        Spacer()
                    }
                    .modifier(StockBoxModifier())
                    .ContainerBoxH()
                    HStack {
                        HStack {
                            Image("postImage0")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Jitomate")
                        }
                        .frame(width: 200, alignment: .leading)
                        Image(systemName: "arrowshape.up.fill")
                            .foregroundStyle(Color.green)
                        Text("$21/kg")
                        Spacer()
                    }
                    .modifier(StockBoxModifier())
                    .ContainerBoxH()
                    HStack {
                        HStack {
                            Image("postImage3")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Maiz")
                        }
                        .frame(width: 200, alignment: .leading)
                        Image(systemName: "arrowshape.up.fill")
                            .foregroundStyle(Color.green)
                        Text("$32/kg")
                        Spacer()
                    }
                    .modifier(StockBoxModifier())
                    .ContainerBoxH()
                    HStack {
                        HStack {
                            Image("postImage5")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Cebolla")
                        }
                        .frame(width: 200, alignment: .leading)
                        Image(systemName: "arrowshape.down.fill")
                            .foregroundStyle(Color.red)
                        Text("$25/kg")
                        Spacer()
                    }
                    .modifier(StockBoxModifier())
                    .ContainerBoxH()
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
//        LoginView()
        HomeView()
    }
}
