//
//  FinalizarTransaccionView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//
import SwiftUI

struct FinalizarTransaccion: View {
    var body: some View {

            VStack(spacing: 20) {
 
                Text("Finalizar Transacción")
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

                // Resumen de Contratos
                VStack(alignment: .leading, spacing: 10) {
                    Text("Resumen de Contratos")
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

                // Fechas importantes
                VStack(alignment: .leading, spacing: 10) {
                    Text("Fechas Importantes")
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

                // Botón para finalizar transacción
Button(action: {
    // Acción para finalizar la transacción (por implementar)
}) {
    Text("Finalizar Transacción")
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
}
.padding(.horizontal)
.padding(.bottom, 5)

Spacer(minLength: 30)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct FinalizarTransaccion_Previews: PreviewProvider {
    static var previews: some View {
        FinalizarTransaccion()
    }
}
