import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    // let navigationDelegate = WebViewNavigationDelegate()

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true // Deshabilita el desplazamiento
        // webView.navigationDelegate = navigationDelegate
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

// // Disparador de enlaces web
// class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
//     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//         if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
//             UIApplication.shared.open(url)
//             decisionHandler(.cancel)
//         } else {
//             decisionHandler(.allow)
//         }
//     }
// }

// Modificadores para input boxes
struct StockBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.custom("Sans Serif", size: 20))
            .frame(width: UIScreen.main.bounds.width - 30)
            .padding(.vertical, 10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Modificadores para desplegar anuncios
struct AddBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, 15)
            .font(.custom("Sans Serif", size: 20))
            .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
            .padding(.vertical, 10)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Modificadores para mostrar noticias
struct NewsBoxModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading, 15)
            .font(.custom("Sans Serif", size: 20))
            .frame(width: UIScreen.main.bounds.width - 30, alignment: .leading)
            .padding(.vertical, 10)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}


// Paso 3: Extensión de View para aplicar el estilo fácilmente
extension View {
    func StockBox() -> some View {
        self.modifier(StockBoxModifier())
    }
    func AddBox() -> some View {
        self.modifier(AddBoxModifier())
    }
    func NewsBox() -> some View {
        self.modifier(NewsBoxModifier())
    }
}

struct HomeView: View {
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // TOP MENU // TOP MENU // TOP MENU //
                    Text("AFFIN")
                    //                    .font(.system(size: 40))
                        .font(.custom("Rockwell", size: 40))
                        .foregroundStyle(Color.accentColor)
                        .padding([.top, .leading], 15)
                    Spacer()
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 20)
                        .foregroundStyle(Color.accentColor)
                }
                .padding(.top, 10)
                .frame(width: screenWidth, height: 50)
                .background(Color.white)
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.gray), alignment: .bottom // Color y alineación del borde
                )
                
                ScrollView {
                    // PRIMER ANUNCIO // PRIMER ANUNCIO
                    HStack {
                        Image(systemName: "dollarsign")
                            .font(.system(size: 25))
                        Image("Aguacate")
                            .resizable()
                            .frame(width: 60, height: 80)
                            .padding(.leading, -5)
                        VStack {
                            Text("Aguacate Hass")
                                .textCase(.uppercase)
                                .bold()
                            Text("Aguacate Hass de michoacan a dos semanas de la cosecha")
                                .font(.system(size: 16))
                        }
                    }
                    .AddBox()
                    .padding(.top, 10)
                    
                    // PRECIOS DE CULTIVOS // PRECIOS DE CULTIVOS
                    VStack {
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
                        .StockBox()
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
                        .StockBox()
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
                        .StockBox()
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
                        .StockBox()
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
                        .StockBox()
                    }
                    .padding(.top, 10)
                    
                    // VIDEO TUTORIAL YT // VIDEO TUTORIAL YT
                    HStack {
                        WebView(url: URL(string: "https://www.youtube.com/watch?v=73Hw-bgS_IQ")!)
                            .frame(width: 360, height: 250)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 10)
                    
                    // NOTICIAS WEB // NOTICIAS WEB
                    NavigationLink(destination: NewsView()) {
                        HStack {
                            WebView(url: URL(string: "https://agronoticias.com.mx/2024/09/02/frijoles-y-quelites-tesoros-nutritivos-en-riesgo-de-olvido/")!)
                                .frame(width: 360, height: 300)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.top, 10)
                    }
                    
                    HStack {
                        WebView(url: URL(string: "https://agronoticias.com.mx/2024/09/02/frijoles-y-quelites-tesoros-nutritivos-en-riesgo-de-olvido/")!)
                            .frame(width: 360, height: 300)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 10)
                    
                    
                    // SEGUNDO ANUNCIO // SEGUNDO ANUNCIO
                    HStack {
                        Image(systemName: "dollarsign")
                            .font(.system(size: 25))
                        Image("Jitomate")
                            .resizable()
                            .frame(width: 60, height: 80)
                            .padding(.leading, -5)
                        VStack {
                            Text("Jitomate")
                                .textCase(.uppercase)
                                .bold()
                            Text("Jitomate de la region de Colima")
                                .font(.system(size: 16))
                        }
                    }
                    .AddBox()
                    .padding(.top, 10)
                }
            }
            .background(Color.gray.opacity(0.1))
        }
    }
}

struct NewsView: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla
        let screenHeight = UIScreen.main.bounds.height // Obtiene el ancho de la pantalla
        VStack {
            HStack {
                WebView(url: URL(string: "https://agronoticias.com.mx/2024/09/02/frijoles-y-quelites-tesoros-nutritivos-en-riesgo-de-olvido/")!)
                    .frame(width: screenWidth-30, height: 600)
            }
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.blue, lineWidth: 4) // Cambia el color y el grosor del borde según necesites
            )
            .padding(.top, 10)
        }
        .frame(width: screenWidth, height: screenHeight)
        // .background(Color.gray.opacity(0.2))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
//        LoginView()
        NewsView()
    }
}
