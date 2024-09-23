import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

// Estructura auxiliar para manejar la conversión de 0/1 a false/true
struct Archived: Decodable {
    var value: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(Int.self)
        self.value = intValue == 1
    }
}

// Elementos de los chats
struct Chat: Identifiable, Decodable {
    var id: Int?
    var interaction_id: Int
    var buyer: String
    var seller: String
    var last_message: String
    var archived: Archived // Usar la estructura auxiliar
}

// MARK: - Vista principal de chats
struct ChatsView: View {
    @State private var chats: [Chat] = []
    @State private var activeChats: [Chat] = []
    @State private var archivedChats: [Chat] = []

    private let publisherUserName: String = ProfileView.userName
    
    var body: some View {
        NavigationView {
            List {
                // Sección de chats archivados
//                Section(header: Text("Archivados")) {
//                    NavigationLink(destination: ArchivedView()) {
//                        HStack {
//                            Image(systemName: "archivebox.fill")
//                                .foregroundColor(.gray)
//                            VStack(alignment: .leading) {
//                                Text("Chats archivados")
//                                    .font(.headline)
//                            }
//                        }
//                    }
//                }

                // Sección de chats activos
                Section(header: Text("Activos")) {
                    ForEach(chats) { chat in
                        NavigationLink(destination: ChatView(chat: chat)) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("Chat con \(ProfileView.accountType == "Bodeguero" ? chat.seller : chat.buyer)")
                                        .font(.headline)
                                    Text(chat.last_message) // Mostrar el último mensaje
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .swipeActions {
                            Button(action: {
                                // Funcion para archivar chat
                            }) {
                                Label("Archivar", systemImage: "archivebox")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .onAppear {
                fetchChats()
            }
            .navigationTitle("Chats")
            .toolbar {
                // Boton de busqueda
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Accion al presionar el boton
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
    
    // MARK: - Funcion para obtener chats
    func fetchChats() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/chats/get") else {
            print("URL no válida")
            return
        }
        
        print("User:", publisherUserName)
        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "userName", value: publisherUserName),
            URLQueryItem(name: "archived", value: "0")
        ]
        
        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        print("URL final: \(url)") // PRINT FOR DEBUG

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
                print("Datos recibidos del servidor: \(jsonString)") // PRINT FOR DEBUG
            }

            do {
                let decodedChats = try JSONDecoder().decode([Chat].self, from: data)
                DispatchQueue.main.async {
                    self.chats = decodedChats
                    print("Chats decodificados correctamente: \(decodedChats)") // PRINT FOR DEBUG
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

struct Message: Identifiable, Codable {
    var id: Int?
    var interaction_id: Int
    var sender: String
    var text: String
    var timestamp: Date
}

// MARK: - Vista individual del chat
struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    let screenWidth = UIScreen.main.bounds.width 
    let publisherType: String = UserData.shared.accountType
    // Negociacion Monopoly
    @State private var mostrarHStack = false
    @State private var tons: String = ""
    @State private var price: String = ""
    @State private var transport: String = ""
    @State private var porcentajeIzquierdo = 50
    // Mensajes
    @State private var messages: [Message] = []
    @State private var messageText: String = ""
    let db = Firestore.firestore()
    var chat: Chat // Assume you have a `Publication` model

    // Formatear fecha y mensaje
    private let messageFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        ZStack {
            VStack {
                // Barra superior del chat
                HStack {
                    // Boton para volver a la vista anterior
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    // Imagen de perfil o icono
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                    Text(ProfileView.accountType == "Bodeguero" ? chat.seller : chat.buyer)
                        .font(.headline)
                    Spacer()
                    //                Button(action: {
                    //                    // Accion al presionar el boton
                    //                }) {
                    //                    Image(systemName: "video.fill")
                    //                        .foregroundColor(.blue)
                    //                }
                    Button(action: {
                        // Accion al presionar el boton
                    }) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 20))
                    }
                }
                .padding()
                .background(Color.white)
                VStack {
                    // Tabla de negociación
                    Button("Tablero de negociación") {
                        withAnimation {
                            mostrarHStack.toggle() // Cambia el estado para mostrar/ocultar el HStack
                        }
                    }
                }
                    
                Spacer()

                HStack {
                    // Campo de texto para escribir mensaje
                    TextField("Escribe un mensaje", text: $messageText)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    // Botón de enviar
                    Button(action: {}) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 30))
                    }
                }
                .padding(10)
                .background(Color.white)

            }
            .background(Color.gray.opacity(0.1))
            .navigationBarHidden(true)
            .blur(radius: mostrarHStack ? 3 : 0) // Aplica desenfoque si mostrarHStack es true
            
            // MARK: - Agrega el HStack con una condición
            if mostrarHStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            mostrarHStack = false
                        }
                    }
                HStack (alignment: .top) {
                    VStack {
                        Text("Vendedor")
                        Divider()
                        Button(action: {
                            if publisherType == "Productor" {
                                mostrarHStack = false
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(Color.gray)
                                .padding(.vertical, 20)
                        }
                        //                        Spacer()
                        Button(action: {
                            if publisherType == "Productor" {
                                mostrarHStack = false
                            }
                        }) {
                            Image(systemName: "paperplane.circle.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(Color.blue)
                                .padding(.vertical, 20)
                        }
                        //                        Spacer()
                    }
                    .frame(maxWidth: .infinity) // Asegura el mismo ancho
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Negociación")
                        Divider()
                        Text("Cantidad:")
                        HStack {
                            TextField("Toneladas", text: $tons)
                            Text("ton")
                        }
                        Spacer()
                        Text("Precio:")
                        HStack {
                            Text("$")
                            TextField("MXN", text: $price)
                            Text("/kg")
                        }
                        Spacer()
                        Text("Transporte:")
                        Text("\(porcentajeIzquierdo)% - \(100 - porcentajeIzquierdo)%")
                        HStack {
                            Button(action: {
                                if porcentajeIzquierdo > 0 {
                                    porcentajeIzquierdo -= 1
                                }
                            }) {
                                Image(systemName: "arrow.left")
                            }
                            
                            Button(action: {
                                if porcentajeIzquierdo < 100 {
                                    porcentajeIzquierdo += 1
                                }
                            }) {
                                Image(systemName: "arrow.right")
                            }
                        }
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .frame(width: 120) // Asegura el mismo ancho
                    Divider()
                    VStack {
                        Text("Comprador")
                        Divider()
                        Button(action: {
                            if publisherType == "Bodeguero" {
                                mostrarHStack = false
                            }
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(Color.green)
                                .padding(.vertical, 20)
                        }
                        //                        Spacer()
                        Button(action: {
                            if publisherType == "Bodeguero" {
                                mostrarHStack = false
                            }
                        }) {
                            Image(systemName: "paperplane.circle.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(Color.gray)
                                .padding(.vertical, 20)
                        }
                        //                        Spacer()
                    }
                    .frame(maxWidth: .infinity) // Asegura el mismo ancho
                }
                .padding(10)
                .frame(width: screenWidth-40, height: 300)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                // New Mods
                .shadow(radius: 10)
                .transition(.opacity) // Transición suave
                
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
