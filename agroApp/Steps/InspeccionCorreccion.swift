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
            dismiss_header(title: "Inspección/Corrección")
            Text("¿Qué significa hacer una corrección y qué conlleva?")
                .font(.title2)
                .padding(.bottom, 0)
            Text("Realizar una corrección en la compra-venta del producto implica modificar algún aspecto acordado previamente, como el precio, la cantidad, o los términos del contrato. Esto requiere la aprobación de ambas partes involucradas y conlleva una actualización del contrato original.")
                .foregroundStyle(Color.red)
                .italic()
                .padding()
                .padding(.top, 0)
            
            Divider()
            
            ScrollView {
                // Valores del Monopoly en la negociacion cv
                VStack(alignment: .leading, spacing: 10) {
                    Text("Monopoly")
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

                // Bascula 1
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bascula 1")
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

                // Bascula 2
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bascula 2")
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

                // Bascula 3
                VStack(alignment: .leading, spacing: 10) {
                    Text("Bascula 3")
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

                // Evidencia del camion
                VStack(alignment: .leading, spacing: 10) {
                    Text("Evidencia del camion")
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
        .navigationBarBackButtonHidden(true)
    }
}

struct InspeccionCorreccion_Previews: PreviewProvider {
    static var previews: some View {
        InspeccionCorreccion()
    }
}
