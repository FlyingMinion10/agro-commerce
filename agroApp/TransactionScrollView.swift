import SwiftUI

struct PasosIniciales: View {
    var label: String
    var body: some View {
        HStack {
            Text(label)
                .lineLimit(1)
                .truncationMode(.tail)
            Image(systemName: "checkmark")
        }
    }
}

struct TransactionScrollView: View {
    @State private var progress: Double = 0.3
    var rating: Int = 5
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("Manzana")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .offset(x: 30)
                    Image("Manzana")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
                HStack {
                    Text("Interlocutor \(rating)")
                        .padding(.leading,10)
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                }
                .font(.title2)
                Spacer()
                // Chat button
                Button(action: {
                    print("Chat button pressed")
                }) {
                    Image(systemName: "message")
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .overlay(
                Capsule()
                    .frame(height: 1) // Altura del borde
                    .foregroundColor(.accentColor), alignment: .bottom // Color y alineación
            )
            ScrollView {
                VStack {

                    // Barra de progreso personalizada
                    Text("Progreso de la transacción")
                    ZStack(alignment: .leading) {
                        // Fondo de la barra
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 20) // Tamaño de la barra
                        
                        // Progreso
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(progress) * 300, height: 20) // Ancho según el progreso
                    }
                    .padding()
                    // Tabla de transacciones
                    ForEach(1...3, id: \.self) { index in
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text("Producto \(index)")
                                Text("Precio: $\(index * 100)")
                            }
                            Spacer()
                            Button(action: {
                                print("Ver detalles de la transacción")
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.accentColor)
                            }
                        }

                    }
                    // Calendario de eventos
                    Section(header: Text("Calendario de eventos")) {}
                    

                    // Tabla de meta 1
                    Section(header: Text("META 1")) {}
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        PasosIniciales(label: "Negociación Inicial")
                        PasosIniciales(label: "Financiamiento de Insumos")
                        PasosIniciales(label: "Cuidados y Siembra")
                        PasosIniciales(label: "Cosecha y entrega")
                        PasosIniciales(label: "Evaluacion de calidad")
                        PasosIniciales(label: "Liquidacion y pagos")
                        PasosIniciales(label: "Garantias y Resp")
                        PasosIniciales(label: "Confidencialidad y restricciones")
                    }
                    .background(Color.gray.opacity(0.2))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView()
    }
}

