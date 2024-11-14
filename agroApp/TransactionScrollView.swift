import SwiftUI

struct TransactionScrollView: View {
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 40, height: 40)
                        .offset(x: 30)
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 40, height: 40)
//                        .offset(x: 40)
                }
                Spacer()
                VStack {
                    Text("Comprador 1")
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= 5 ? "star.fill" : "star")
                                .foregroundColor(index <= 5 ? .yellow : .gray)
                                .padding(-7)
                        }
                    }
                }
                .padding(.leading, 30)
                // Spacer()
                VStack {
                    Text("Vendedor 2")
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= 5 ? "star.fill" : "star")
                                .foregroundColor(index <= 5 ? .yellow : .gray)
                                .padding(-7)
                        }
                    }
                }
                Spacer()
                // Chat button
                Button(action: {
                    print("Chat button pressed")
                }) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                }
                
            }
            .padding(.horizontal, 20)
            ScrollView {
                VStack {
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
                        .padding(.horizontal, 20)
                    }
                    Section(header: Text("META 1")) {}
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        HStack {
                            Text("Negociacin Inicial")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Financiamiento de Insumos")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Cuidados y Siembra")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Cosecha y entrega")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Evaluacion de calidad")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Liquidacion y pagos")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Garantias y Resp")
                            Image(systemName: "checkmark")
                        }
                        HStack {
                            Text("Confidencialidad y rest")
                            Image(systemName: "checkmark")
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                }
            }
        }
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView()
    }
}

