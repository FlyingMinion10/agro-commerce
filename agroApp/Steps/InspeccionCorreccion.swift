//
//  InspeccionCorreccionView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//
import SwiftUI

struct InspeccionCorreccion: View {
    var body: some View {
            VStack(spacing: 20) {

                Text("Inspección/Corrección")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Divider()
                    .padding(.horizontal)
            ScrollView {
                // Participantes de la transacción
                VStack(alignment: .leading, spacing: 10) {
                    Text("Participantes de la Transacción")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Datos de la transacción
                VStack(alignment: .leading, spacing: 10) {
                    Text("Datos de la Transacción")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Precios de la transacción
                VStack(alignment: .leading, spacing: 10) {
                    Text("Precios de la Transacción")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                Divider()

                // Explicación de corrección
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Qué significa hacer una corrección y qué conlleva?")
                        .font(.headline)
                    Text("Realizar una corrección en la compra-venta del producto implica modificar algún aspecto acordado previamente, como el precio, la cantidad, o los términos del contrato. Esto requiere la aprobación de ambas partes involucradas y conlleva una actualización del contrato original.")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Botones para corrección
                VStack(spacing: 15) {
                    Button(action: {
                        // Acción para hacer una corrección (por implementar)
                    }) {
                        Text("Quiero hacer una corrección en la compra venta del producto")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        // Acción para no hacer una corrección (por implementar)
                    }) {
                        Text("No quiero hacer una corrección")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }

                Spacer(minLength: 40)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct InspeccionCorreccion_Previews: PreviewProvider {
    static var previews: some View {
        InspeccionCorreccion()
    }
}
