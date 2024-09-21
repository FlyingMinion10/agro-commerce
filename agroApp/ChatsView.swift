import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

// Elementos de los chats
struct Chat: Identifiable {
    var id: String
    var participants: [String]
    var lastMessage: String
    var timestamp: Timestamp
    var isArchived: Bool
}

// MARK: - Vista principal de chats
struct ChatsView: View {
    @State private var chats: [Chat] = []
    let db = Firestore.firestore()
    
    @State private var activeChats: [Chat] = []
    @State private var archivedChats: [Chat] = []
    @State private var newChatId: String? = nil

    
    var body: some View {
        NavigationView {
            List {
                // Sección de chats archivados
                Section(header: Text("Archivados")) {
                    NavigationLink(destination: ArchivedView()) {
                        HStack {
                            Image(systemName: "archivebox.fill")
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Chats archivados")
                                    .font(.headline)
                            }
                        }
                    }
                }

                // Sección de chats activos
                Section(header: Text("Activos")) {
                    ForEach(activeChats) { chat in
                        NavigationLink(destination: ChatView(chatId: chat.id)) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("Chat con \(getChatPartnerName(chat: chat))")
                                        .font(.headline)
                                    Text(chat.lastMessage)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .swipeActions {
                            Button(action: {
                                archiveChat(chatId: chat.id)
                            }) {
                                Label("Archivar", systemImage: "archivebox")
                            }
                            .tint(.orange)
                        }
                    }
                }
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
                // Boton de crear nuevo chat
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Acción para crear un nuevo chat
                        createNewChat(with: "userIdDelOtroUsuario") // AGREGAR EL ID DEL OTRO USUARIO
                    }) {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
    
    // MARK: - Funcion para crear chats
    func createNewChat(with otherUserId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let chatData = [
            "participants": [userId, otherUserId],
            "lastMessage": "",
            "timestamp": Timestamp(date: Date()),
            "isArchived": false
        ] as [String : Any]

        var ref: DocumentReference? = nil
        ref = db.collection("chats").addDocument(data: chatData) { error in
            if let error = error {
                print("Error al crear chat: \(error.localizedDescription)")
            } else if let chatId = ref?.documentID {
                // Actualiza newChatId para activar la navegación
                self.newChatId = chatId
            }
        }
    }
    
    // Funcion para guardar chats
    func getChats() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        // Obtener chats activos
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .whereField("isArchived", isEqualTo: false)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No hay documentos de chats activos")
                    return
                }

                self.activeChats = documents.map { docSnapshot -> Chat in
                    let data = docSnapshot.data()
                    let id = docSnapshot.documentID
                    let participants = data["participants"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                    let isArchived = data["isArchived"] as? Bool ?? false
                    return Chat(id: id, participants: participants, lastMessage: lastMessage, timestamp: timestamp, isArchived: isArchived)
                }
            }

        // Obtener chats archivados
        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .whereField("isArchived", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No hay documentos de chats archivados")
                    return
                }

                self.archivedChats = documents.map { docSnapshot -> Chat in
                    let data = docSnapshot.data()
                    let id = docSnapshot.documentID
                    let participants = data["participants"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                    let isArchived = data["isArchived"] as? Bool ?? false
                    return Chat(id: id, participants: participants, lastMessage: lastMessage, timestamp: timestamp, isArchived: isArchived)
                }
            }
    }
    
    // MARK: - Archive & Unarchive
    func archiveChat(chatId: String) {
        db.collection("chats").document(chatId).updateData([
            "isArchived": true
        ]) { error in
            if let error = error {
                print("Error al archivar chat: \(error.localizedDescription)")
            } else {
                print("Chat archivado con éxito")
            }
        }
    }
    
    func unarchiveChat(chatId: String) {
        db.collection("chats").document(chatId).updateData([
            "isArchived": false
        ]) { error in
            if let error = error {
                print("Error al desarchivar chat: \(error.localizedDescription)")
            } else {
                print("Chat desarchivado con éxito")
            }
        }
    }
    
    func getChatPartnerName(chat: Chat) -> String {
        guard let userId = Auth.auth().currentUser?.uid else { return "Usuario" }
        let partnerId = chat.participants.first { $0 != userId } ?? "Usuario"
        // Si tienes una colección de usuarios en Firestore, puedes obtener el nombre real del usuario usando su ID.
        return partnerId
    }

    
}

// MARK: - Vista de chats archivados
struct ArchivedView: View {
    @State private var archivedChats: [Chat] = []
    let db = Firestore.firestore()

    var body: some View {
        List {
            ForEach(archivedChats) { chat in
                NavigationLink(destination: ChatView(chatId: chat.id)) {
                    HStack {
                        Image(systemName: "archivebox.fill")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Chat con \(getChatPartnerName(chat: chat))")
                                .font(.headline)
                            Text(chat.lastMessage)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .swipeActions {
                    Button(action: {
                        unarchiveChat(chatId: chat.id)
                    }) {
                        Label("Desarchivar", systemImage: "arrow.up.square")
                    }
                    .tint(.blue)
                }
            }
        }
        .navigationTitle("Archivados")
        .onAppear {
            getArchivedChats()
        }
    }

    func getArchivedChats() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .whereField("isArchived", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No hay documentos de chats archivados")
                    return
                }

                self.archivedChats = documents.map { docSnapshot -> Chat in
                    let data = docSnapshot.data()
                    let id = docSnapshot.documentID
                    let participants = data["participants"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                    let isArchived = data["isArchived"] as? Bool ?? false
                    return Chat(id: id, participants: participants, lastMessage: lastMessage, timestamp: timestamp, isArchived: isArchived)
                }
            }
    }

    func unarchiveChat(chatId: String) {
        db.collection("chats").document(chatId).updateData([
            "isArchived": false
        ]) { error in
            if let error = error {
                print("Error al desarchivar chat: \(error.localizedDescription)")
            } else {
                print("Chat desarchivado con éxito")
            }
        }
    }

    func getChatPartnerName(chat: Chat) -> String {
        guard let userId = Auth.auth().currentUser?.uid else { return "Usuario" }
        let partnerId = chat.participants.first { $0 != userId } ?? "Usuario"
        return partnerId
    }
}


// MARK: - Estructura de objeto de mensajes
struct Message: Identifiable {
    var id: String
    var text: String
    var senderId: String
    var timestamp: Timestamp
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
    var chatId: String

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
                    Text("Nombre de usuario")
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
                    
                    
                    // MARK: - Lista de mensajes
                    List(messages) { message in
                        if message.senderId == Auth.auth().currentUser?.uid {
                            // Mensaje saliente
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(message.text)
                                        .font(.body)
                                        .padding()
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(10)
                                    Text("\(message.timestamp.dateValue(), formatter: messageFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        } else {
                            // Mensaje entrante
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(message.text)
                                        .font(.body)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    Text("\(message.timestamp.dateValue(), formatter: messageFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                // MARK: - Barra inferior de escritura de mensaje
                HStack {
                    // Campo de texto para escribir mensaje
                    TextField("Escribe un mensaje", text: $messageText)
                        .padding(10)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    // Botón de enviar
                    Button(action: sendMessage) {
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
            
            // Paso 4: Agrega el HStack con una condición
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
    
    // MARK: - Funcion para obtener mensajes
    func getMessages() {
        db.collection("chats").document(chatId).collection("messages") // Cambiar chat_id por el id unico
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No hay documentos")
                    return
                }

                self.messages = documents.map { docSnapshot -> Message in
                    let data = docSnapshot.data()
                    let id = docSnapshot.documentID
                    let text = data["text"] as? String ?? ""
                    let senderId = data["senderId"] as? String ?? ""
                    let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                    return Message(id: id, text: text, senderId: senderId, timestamp: timestamp)
                }
            }
    }
    // MARK: - Funcion para enviar mensajes
    func sendMessage() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let newMessage = [
            "text": messageText,
            "senderId": userId,
            "timestamp": Timestamp(date: Date())
        ] as [String : Any]

        let chatRef = db.collection("chats").document(chatId)
        let messagesRef = chatRef.collection("messages")

        messagesRef.addDocument(data: newMessage) { error in
            if let error = error {
                print("Error al enviar mensaje: \(error.localizedDescription)")
            } else {
                self.messageText = ""
                // Actualizar último mensaje en el chat
                chatRef.updateData([
                    "lastMessage": newMessage["text"] ?? "",
                    "timestamp": newMessage["timestamp"] ?? Timestamp(date: Date())
                ])
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
