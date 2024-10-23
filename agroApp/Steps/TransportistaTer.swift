//
//  TransportistaSec 2.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 23/10/24.
//


import SwiftUI

struct TransportistaTer : View {
    var currentStep: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink(destination: LiberarPago()) {
                        HStack {
                            Text("Confirmar llegada de camión")
                        }
                    }
                    .activeStepStyle(color: .green, currentStep: currentStep, step: 1)
                    
                    NavigationLink(destination: LiberarPago()) {
                        HStack {
                            Text("Liberar pago")
                        }
                    }
                    .activeStepStyle(color: .teal, currentStep: currentStep, step: 2)
                    
                    NavigationLink(destination: LiberarPago()) {
                        HStack {
                            Text("Rating")
                        }
                    }
                    .activeStepStyle(color: .green, currentStep: currentStep, step: 3)
                    
                    NavigationLink(destination: LiberarPago()) {
                        HStack {
                            Text("Factura")
                        }
                    }
                    .activeStepStyle(color: .teal, currentStep: currentStep, step: 4)
                    
                    NavigationLink(destination: LiberarPago()) {
                        HStack {
                            Text("Finalizar")
                        }
                    }
                    .activeStepStyle(color: .green, currentStep: currentStep, step: 5)
                }
                .frame(width: 360)
            }
            .navigationTitle("Opciones")
        }
    }
}

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

struct TransportistaTer_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaTer(currentStep: 5)
    }
}
