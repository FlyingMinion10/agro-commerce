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
    var buyer: String
    var seller: String
    var buyer_name: String
    var seller_name: String
    var item_preview: String
    var publication_id: Int
    var archived: Archived
}

// MARK: - Vista principal de chats
struct ChatsView: View {
    @State private var chats: [Chat] = []
//    @State private var activeChats: [Chat] = []
//    @State private var archivedChats: [Chat] = []

    private let myEmail: String = ProfileView.email
    private let myAccountType: String = ProfileView.accountType
    
    var body: some View {
        NavigationView {
            List {
                // Sección de chats archivados

                // Sección de chats activos
                Section(header: Text("Activos")) {
                    ForEach(chats) { chat in
                        NavigationLink(destination: ChatView(chat:chat, interaction_id: chat.id ?? 0, publication_id: chat.publication_id)) {
                            ChatRow(chat: chat, myAccountType: myAccountType)
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
        
//         print("User:", myEmail)
        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: myEmail),
            URLQueryItem(name: "archived", value: "0")
        ]
        
        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

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
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("Datos recibidos del servidor fetchChats: \(jsonString)") // PRINT FOR DEBUG
            // }

            do {
                let decodedChats = try JSONDecoder().decode([Chat].self, from: data)
                DispatchQueue.main.async {
                    self.chats = decodedChats
                    print("Chats decodificados correctamente ") // PRINT FOR DEBUG
                }
            } catch {
                print("Error al decodificar los chats: \(error)")
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

struct ChatRow: View {
    var chat: Chat
    var myAccountType: String
    
    var body: some View {
        HStack {
            Image(chat.item_preview.split(separator: " ").first.map(String.init) ?? "")
                .resizable()
                .frame(width: 40, height: 40)
//                .foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text("Chat con \(myAccountType == "Bodeguero" ? chat.seller_name : chat.buyer_name)")
                    .font(.headline)
                Text(chat.item_preview) // Mostrar el último mensaje
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Message: Identifiable, Codable {
    var id: Int? // Real UU id
    var sender: String
    var text: String
//    var timestamp: Date
}

// Modelo Monopoly
struct Monopoly: Identifiable, Decodable {
    var id: Int? // interaction_id ON server
    var price: String
    var quantity: String
    var transport: String
    var percentages: String
    var accepted: Bool
    var last_mod: String
}

// MARK: - Vista individual del chat
struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    let screenWidth = UIScreen.main.bounds.width
    
    private let myEmail: String = ProfileView.email
    var chat: Chat

    @State private var monopoly: [Monopoly] = []
    @State private var messages: [Message] = []
    var interaction_id: Int // Id de chat & interaction
    var publication_id: Int // Id de la publicacion del producto

    // Negociación Monopoly
    @State private var mostrarMonopoly = false
    @State private var tons: String = ""
    @State private var price: String = ""
    @State private var transport: String = ""
    @State private var percentages: String = ""
    
    @State private var justEdited: Bool = false
    @State private var showSteps: Bool = false

    // Mensajes
    @State private var newMessageText: String = ""

    var body: some View {
        ZStack {
            VStack {
                // Barra superior del chat
                HStack {
                    // Botón para volver a la vista anterior
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
                    Text(ProfileView.accountType == "Bodeguero" ? chat.seller_name : chat.buyer_name)
                        .font(.headline)
                    Spacer()
                    NavigationLink (destination: StepsView(interaction_id: interaction_id, publication_id: publication_id, buyer: chat.buyer, seller: chat.seller)) {
                        Image(systemName: "arrowshape.right.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 30))
                            .opacity(monopoly.first?.accepted == false ? 0 : 1)
                    }
                    .disabled(monopoly.first?.accepted == false)
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)
                VStack {
                    // Botón para mostrar el Monopoly
                    Button("Tablero de negociación") {
                        withAnimation {
                            mostrarMonopoly.toggle() // Cambia el estado para mostrar/ocultar el HStack
                        }
                    }
                }

                Spacer()

                ScrollViewReader { proxy in
                    List {
                        ForEach(messages) { message in
                            HStack {
                                if message.sender == myEmail {
                                    Spacer()
                                    Text(message.text)
                                        .padding()
                                        .background(Color.accentColor.opacity(1))
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                } else {
                                    Text(message.text)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            }
                            .id(message.id) // Asegúrate de que cada mensaje tenga un id único
                        }
                    }
                    .onAppear {
                        if let lastMessage = messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .frame(width: screenWidth)

                HStack {
                    // Campo de texto para escribir mensaje
                    TextField("Escribe un mensaje...", text: $newMessageText, onCommit: {
                        sendMessageAction()
                    })
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    // Botón de enviar
                    Button(action: {
                        sendMessageAction()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.accentColor)
                            .font(.system(size: 30))
                    }
                }
                .padding(10)
                .background(Color.white)

            }
            .onAppear {
                fetchMonopoly()
                fetchMessages()
            }
            .padding(0) // MFT
            .background(Color.gray.opacity(0.1))
            .navigationBarHidden(true)
            .blur(radius: mostrarMonopoly ? 3 : 0) // Aplica desenfoque si mostrarMonopoly es true

            // MARK: - Mostrar Monopoly
            if mostrarMonopoly {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            mostrarMonopoly = false
                        }
                    }
                HStack(alignment: .top) {
                    // Columna "Yo mero"
                    VStack {
                        Text("Yo mero")
                        Divider()

                        if let firstMonopoly = monopoly.first, firstMonopoly.accepted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 45))
                                .foregroundStyle(Color.green)
                                .padding(.vertical, 20)
                        } else if justEdited {
                            Button(action: {
                                editMonopoly()
                                mostrarMonopoly = false
                            }) {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(Color.gray)
                                    .padding(.vertical, 20)
                            }
                        } else if let firstMonopoly = monopoly.first, myEmail != firstMonopoly.last_mod {
                            Button(action: {
                                acceptDeal()
                                mostrarMonopoly = false
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(Color.gray)
                                    .padding(.vertical, 20)
                            }
                        } else {
                            Button(action: {
                                // Acción para aceptar la propuesta
                                mostrarMonopoly = false
                            }) {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(Color.blue)
                                    .padding(.vertical, 20)
                            }
                        }

                    }
                    .frame(maxWidth: .infinity) // Asegura el mismo ancho

                    Divider()
                    // Columna "Negociación"
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Negociación")
                        Divider()
                        Text("Cantidad:")
                        HStack {
                            if let firstMonopoly = monopoly.first {
                                if myEmail != firstMonopoly.last_mod && !firstMonopoly.accepted {
                                    TextField("Cantidad", text: $tons)
                                        .onChange(of: tons) { _ in
                                            justEdited = true
                                        }
                                } else {
                                    Text(firstMonopoly.quantity)
                                }
                            }
                        }

                        Text("Precio:")
                        HStack {
                            if let firstMonopoly = monopoly.first {
                                if myEmail != firstMonopoly.last_mod && !firstMonopoly.accepted{
                                    TextField("Precio", text: $price)
                                        .onChange(of: price) { _ in
                                            justEdited = true
                                        }
                                } else {
                                    Text(firstMonopoly.price)
                                }
                            }
                        }

                        Text("Transporte:")
                        HStack {
                            if let firstMonopoly = monopoly.first {
                                if myEmail != firstMonopoly.last_mod && !firstMonopoly.accepted {
                                    TextField("Transporte", text: $transport)
                                        .onChange(of: transport) { _ in
                                            justEdited = true
                                        }
                                } else {
                                    Text(firstMonopoly.transport)
                                }
                            }
                        }

                        if let firstMonopoly = monopoly.first, firstMonopoly.transport == "A cargo de AFFIN" {
                            Text("Porcentajes:")
                            HStack {
                                if myEmail != firstMonopoly.last_mod && !firstMonopoly.accepted {
                                    TextField("Porcentajes", text: $percentages)
                                        .onChange(of: percentages) { _ in
                                            justEdited = true
                                        }
                                } else {
                                    Text(firstMonopoly.percentages)
                                }
                            }
                        }

                    }
                    .frame(width: 120) // Asegura el mismo ancho
                    Divider()
                    // Columna "Interlocutor"
                    VStack {
                        Text("Interlocutor")
                        Divider()

                        if let firstMonopoly = monopoly.first, myEmail != firstMonopoly.last_mod {
                            Button(action: {
                                // Acción para aceptar la propuesta
                                mostrarMonopoly = false
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(Color.green)
                                    .padding(.vertical, 20)
                            }
                        } else {
                            Button(action: {
                                // Acción para aceptar la propuesta
                                mostrarMonopoly = false
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(Color.gray)
                                    .padding(.vertical, 20)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity) // Asegura el mismo ancho
                }
                .padding(10)
                .frame(width: screenWidth - 40, height: 300)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 10)
                .transition(.opacity) // Transición suave

            }
        }
    }

    private func sendMessageAction() {
        let newId = (messages.last?.id ?? 0) + 1
        messages.append(Message(id: newId, sender: myEmail, text: newMessageText))
        sendMessage()
        newMessageText = ""
    }

    // MARK: - Func Get Mply
    func fetchMonopoly() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/monopoly/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interaction_id)), // Convertir Int? a String?
        ]

        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching publications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos Monopoly.")
                return
            }

            // Imprimir los datos recibidos en formato JSON
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
//            }

            do {
                let decodedMonopoly = try JSONDecoder().decode([Monopoly].self, from: data)
                DispatchQueue.main.async {
                    self.monopoly = decodedMonopoly
                    print("Monopoly decodificado correctamente: \(decodedMonopoly)") // PRINT FOR DEBUG

                    if let firstMonopoly = decodedMonopoly.first {
                        self.tons = firstMonopoly.quantity
                        self.price = firstMonopoly.price
                        self.transport = firstMonopoly.transport
                        self.percentages = firstMonopoly.percentages
                    }
                }
            } catch {
                print("Error al decodificar el monopoly: \(error)")
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

    // MARK: - Func Get Msj
    func fetchMessages() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/messages/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interaction_id)), // Convertir Int? a String?
        ]

        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching publications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos Monopoly.")
                return
            }

            // Imprimir los datos recibidos en formato JSON
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("Datos recibidos del servidor Messages: \(jsonString)") // PRINT FOR DEBUG
            // }

            do {
                let decodedMessages = try JSONDecoder().decode([Message].self, from: data)
                DispatchQueue.main.async {
                    self.messages = decodedMessages
                    print("Mensajes decodificado correctamente: \(decodedMessages)") // PRINT FOR DEBUG

                }
            } catch {
                print("Error al decodificar los mensajes: \(error)")
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
    
    // MARK: - Func Accept Deal
    func acceptDeal() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/monopoly/accept") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos formateados
        let idToAcceptDeal: [String: Any] = [
            "interaction_id": interaction_id
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: idToAcceptDeal, options: []) else {
            print("Error al serializar los datos para aceptar monopoly")
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
                print("Error en la respuesta del servidor acceptDeal()")
                return
            }

            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Respuesta del servidor: \(json)")
//                    // Aquí puedes manejar la respuesta del servidor
//                }
                self.fetchMonopoly()
                self.showSteps = true
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }

    // MARK: - Func Edit Mply
    func editMonopoly() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/monopoly/edit") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos actualizados
        let monopolyData: [String: Any] = [
            "interaction_id": interaction_id,
            "price": price,
            "quantity": tons,
            "transport": transport,
            "percentages": percentages,
            "last_mod": myEmail
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: monopolyData, options: []) else {
            print("Error al serializar los datos para editar monopoly")
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
                print("Error en la respuesta del servidor editMonopoly()")
                return
            }

            do {
//              Aquí puedes manejar la respuesta del servidor
                print("Monopoly editado exitosamente")
                // Una vez que la solicitud se complete exitosamente, llamar a fetchMonopoly() en el hilo principal
                DispatchQueue.main.async {
                    self.fetchMonopoly()
                    // Opcionalmente, restablecer el estado de justEdited si es necesario
                    self.justEdited = false
                    // Opcionalmente, puedes cerrar la vista de Monopoly si así lo deseas
                    self.mostrarMonopoly = false
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
    
    // MARK: - Func Send Msj
    func sendMessage() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/messages/send") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
        // Crear el diccionario con los datos del mensaje
        let messageData: [String: Any] = [
            "interaction_id": interaction_id, // Asumiendo que tienes un ID de chat
            "sender": myEmail,
            "text": newMessageText
        ]
//        "timestamp": Date().timeIntervalSince1970, MFI
    
        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: messageData, options: []) else {
            print("Error al serializar los datos del mensaje")
            return
        }
    
        request.httpBody = httpBody
    
        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al enviar el mensaje: \(error)")
                return
            }
    
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error en la respuesta del servidor al enviar el mensaje")
                return
            }
    
            do {
//                Aquí puedes manejar la respuesta del servidor
                print("Mensaje enviado exitosamente")
                self.newMessageText = ""
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
