import SwiftUI

struct ChatsView: View {
    var body: some View {
        NavigationView {
            List {
                // Seccion de chats archivados
                Section(header: Text("Archivados")) {
                    NavigationLink(destination: ChatView()) {
                        HStack {
                            // Imagen de perfil o icono
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Nombre de usuario")
                                    .font(.headline)
                                Text("Ultimo mensaje")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                // Seccion de chats activos
                Section(header: Text("Activos")) {
                    ForEach(0..<4) { _ in
                        NavigationLink(destination: ChatView()) {
                            HStack {
                                // Imagen de perfil o icono
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("Nombre de usuario")
                                        .font(.headline)
                                    Text("Ultimo mensaje")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
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
                        // Accion al presionar el boton
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// Vista individual del chat

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                }
            }
            .padding()
            
            // Lista de mensajes
            List {
                // Mensajes entrantes
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Mensaje entrante")
                            .font(.body)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                // Mensajes salientes
                HStack {
                    VStack(alignment: .leading) {
                        Text("Mensaje saliente")
                            .font(.body)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            // Barra inferior de escritura de mensaje
            HStack {
                // Icono de adjunto
                Image(systemName: "paperclip")
                    .foregroundColor(.gray)
                // Campo de texto para escribir mensaje
                TextField("Escribe un mensaje", text: /*@START_MENU_TOKEN@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                // Icono de enviar
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
