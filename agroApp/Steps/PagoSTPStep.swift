
//
//  PagoSTPFleteView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 23/10/24.
//
import SwiftUI

struct PagoSTPStep: View {
    @State private var termsAccepted = false
    
    var body: some View {
        dismiss_header(title: "Pago STP C-V")
        ScrollView {
            VStack(spacing: 20) {
                // Información Importante
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pago mediante STP")
                        .font(.headline)
                        .padding(.top, 10)

                    Text("STP es una plataforma que permite realizar pagos electrónicos de manera rápida y segura, utilizando transferencias interbancarias en tiempo real.")
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pasos para realizar el pago mediante STP")
                        .font(.title)
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        InfoTutoRec(number: 1, text: "Registra tu cuenta", description: "Ingresa a la plataforma y registra tu cuenta bancaria para poder realizar pagos.")
                        InfoTutoRec(number: 2, text: "Genera la orden de pago", description: "Crea una orden de pago con los detalles del flete que deseas pagar.")
                        InfoTutoRec(number: 3, text: "Confirma el pago", description: "Revisa los detalles de la orden y confirma el pago a través de la plataforma STP.")
                        InfoTutoRec(number: 4, text: "Verificación", description: "STP realizará la verificación de la transferencia de manera rápida y segura.")
                        InfoTutoRec(number: 5, text: "Pago completado", description: "Una vez completado el proceso, recibirás la confirmación de que el pago ha sido realizado exitosamente.")
                    }
                    .padding()
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Aceptar terminos
                HStack {
                    Button(action: {
                        termsAccepted.toggle()
                    }) {
                        Image(systemName: termsAccepted ? "checkmark.square.fill" : "square")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                    Text("Acepto los términos y condiciones")
                        .font(.system(size: 20))
                }

                // Botón para firmar
                Button(action: {
                    // Acción para ir al sitio externo de Mifiel (por implementar)
                }) {
                    Text("Hacer pago mediante STP")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(termsAccepted ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .padding(10)
                .frame(maxWidth: 330)
                .disabled(!termsAccepted)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
}
