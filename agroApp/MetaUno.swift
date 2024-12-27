import SwiftUI

struct MetaUno: View {
    @State private var isMenuOpen = false
    @State private var confirmado = false
    @State private var showAlert = false

    @State private var banco = ""
    @State private var clabe = ""
    
    var body: some View {
        ZStack {
            // Fondo con degradado
//            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)

            // Contenido principal
            VStack(alignment: .center, spacing: 20) {
                // Encabezado
                HStack {
                    Button(action: {
                        isMenuOpen.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding()
                            .foregroundColor(.accentColor)
                    }
                    Spacer()
                    Text("Pasos")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.black.opacity(0.9))
                        .padding(.vertical, 20)
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .padding()
                    }
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                // Tabla de Resumen de Información
                VStack(alignment: .leading, spacing: 15) {
                    Text("Resumen de Información")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)

                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.accentColor)
                        Text("Deducción por pago (Financiamiento)")
                            .foregroundColor(.black)
                    }

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.accentColor)
                        Text("Frecuencia de Pago")
                            .foregroundColor(.black)
                    }

                    HStack {
                        Image(systemName: "creditcard")
                            .foregroundColor(.accentColor)
                        Text("Forma de Pago STP")
                            .foregroundColor(.black)
                    }
                }
                .cardStyle()

                // Recuadro Banco y CLABE
                VStack(alignment: .leading, spacing: 10) {
                    Text("Información de Pago")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)

                    HStack {
                        Text("Banco/Cuenta:")
                            .foregroundColor(.black)
                        Spacer()
                        // TextField("Introduce el banco", text: $banco)
                        Text("Introduce el banco")
                            .foregroundColor(.gray)
                            
                    }
                    Divider()
                    HStack {
                        Text("CLABE:")
                            .foregroundColor(.black)
                        Spacer()
//                        TextField("Introduce la CLABE", text: $clabe)
                        Text("Introduce la CLABE")
                            .foregroundColor(.gray)
                            
                    }
                }
                .cardStyle()

                // Checkmarks
                Spacer()
                HStack (alignment: .center) {
                    Text("Confirmar datos")
                        .font(.title)
                    Spacer()
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: confirmado ? "checkmark.square.fill" : "square")
                            .font(.title)
                            .foregroundStyle(Color.accentColor)
                            // Mostrar la alerta cuando `showSuccessAlert` es verdadero
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Atención"),
                                    message: Text("Esta seguro que desea confirmar? \nEsta acción no se puede deshacer."),
                                    primaryButton: .default(
                                        Text("Continuar"),
                                        action: {
                                            confirmado = true
                                            showAlert = false
                                        }),
                                    secondaryButton: .destructive(
                                        Text("Cancelar"),
                                        action: {
                                            showAlert = false
                                        })
                                )
                            }
                    }
                    .disabled(confirmado)
                }
                .padding(.horizontal, 20)
                .cardStyle()
            }
            .background(Color.backstage)

            // Fondo semi-transparente que cierra el menú
            if isMenuOpen {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isMenuOpen = false
                    }
            }

            // Menú lateral
            if isMenuOpen {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Menú")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)
                        Divider()
                            .background(Color.white)
                        Group {
                            MenuItem(label: "Resumén", icon: "house")
                            MenuItem(label: "Negociación Inicial", icon: "doc")
                            MenuItem(label: "Cuidados y Siembra", icon: "leaf")
                            MenuItem(label: "Evaluación de Calidad", icon: "star")
                            MenuItem(label: "Garantías", icon: "shield")
                            MenuItem(label: "Financiamiento", icon: "banknote")
                            MenuItem(label: "Cosecha y Entrega", icon: "car")
                            MenuItem(label: "Liquidación y Pagos", icon: "dollarsign.circle")
                            MenuItem(label: "Confidencialidad", icon: "lock")
                            MenuItem(label: "Configuración", icon: "gear")
                        }
                        Spacer()
                    }
                    .frame(width: 200)
                    .padding()
                    .background(Color.accentColor.opacity(0.5))
                    .background(Color.gray)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 0)
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        // .animation(.easeInOut, value: isMenuOpen)
    }
}

// Componente para el menú lateral
struct MenuItem: View {
    let label: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(label)
                .foregroundColor(.white)
                .font(.body)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}



struct MetaUno_Previews: PreviewProvider {
    static var previews: some View {
        MetaUno()
    }
}
