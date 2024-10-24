//
//  LiberarPagoView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//


import SwiftUI

struct LiberarPago: View {
    var body: some View {
            VStack(spacing: 20) {

                Text("Liberar Pago")
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

                // Explicación de la liberación de pago en STP
                VStack(alignment: .leading, spacing: 10) {
                    Text("¿Cómo funciona la liberación de pago en STP?")
                        .font(.headline)
                    Text("La liberación de pago en STP se realiza mediante una transferencia bancaria segura y rápida, en la cual los fondos se transfieren desde la cuenta del comprador a la cuenta del vendedor una vez que ambas partes han confirmado que se cumplen los términos de la transacción.")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Botón para liberar pago
                Button(action: {
                    // Acción para liberar el pago (por implementar)
                }) {
                    Text("Liberar Pago")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
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

struct LiberarPago_Previews: PreviewProvider {
    static var previews: some View {
        LiberarPago()
    }
}
