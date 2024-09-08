import SwiftUI

struct ChatsView: View {
    var body: some View {
        NavigationView {
            List {
                // Seccion de chats archivados
                Section(header: Text("Archivados")) {
                    NavigationLink(destination: ArchivedView()) {
                        HStack {
                            // Imagen de perfil o icono
                            Image(systemName: "archivebox.fill")
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Chats archivados")
                                    .font(.headline)
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

struct ArchivedView: View {
    var body: some View {
        List {
            // Sección de chats archivados
            Section {
                ForEach(0..<4) { _ in
                    NavigationLink(destination: ChatView()) {
                        HStack {
                            // Imagen de perfil o ícono
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("Nombre de usuario")
                                    .font(.headline)
                                Text("Último mensaje")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Archivados")
        .toolbar {
            // Botón de búsqueda
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Acción al presionar el botón
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            // Botón de crear nuevo chat
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Acción al presionar el botón
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}


// Vista individual del chat

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    let screenWidth = UIScreen.main.bounds.width 
    
    @State private var tons: String = ""
    @State private var price: String = ""
    @State private var transport: String = ""
    @State private var porcentajeIzquierdo = 50
    
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
            .background(Color.white)
            VStack {
                // Tabla de negociación
                HStack (alignment: .top) {
                    VStack {
                        Text("Vendedor")
                        Divider()
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(Color.green)
                            .padding(.vertical, 20)
//                        Spacer()
                        Image(systemName: "paperplane.circle.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(Color.gray)
                            .padding(.vertical, 20)
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
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(Color.gray)
                            .padding(.vertical, 20)
//                        Spacer()
                        Image(systemName: "paperplane.circle.fill")
                            .font(.system(size: 45))
                            .foregroundStyle(Color.blue)
                            .padding(.vertical, 20)
//                        Spacer()
                    }
                    .frame(maxWidth: .infinity) // Asegura el mismo ancho
                }
                .padding(10)
                .frame(width: screenWidth-40, height: 300)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                
                // Lista de mensajes // Lista de mensajes // Lista de mensajes
                List {
                    // Mensajes entrantes
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Mensaje entrante de csaracte")
                                .font(.body)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    // Mensajes salientes
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Mensaje saliente")
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                }
//                .fram
                
            }
            // Barra inferior de escritura de mensaje
            HStack {
                // Icono de adjunto
                Image(systemName: "paperclip")
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
                // Campo de texto para escribir mensaje
                TextField("Escribe un mensaje", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                // Icono de enviar
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
            }
            .padding(10)
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.1))
        .navigationBarHidden(true)
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
//        ChatsView()
        ChatView()
    }
}
