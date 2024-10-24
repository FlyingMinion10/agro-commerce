//
//  TransportistaSec 2.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 23/10/24.
//
import SwiftUI

struct TransportistaPrim : View {
    var tranPrimStep: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink(destination: ContratoServicioFleteView()) {
                        HStack {
                            Text("Contrato transportista")
                        }
                    }
                    .activeStepStyle(color: .orange, currentStep: tranPrimStep, step: 1)
                    
                    NavigationLink(destination: PagoSTPStep()) {
                        HStack {
                            Text("Pago 15% STP")
                        }
                    }
                    .activeStepStyle(color: .red, currentStep: tranPrimStep, step: 2)
                    
                }
                .frame(width: 360)
            }
            .navigationTitle("Opciones")
        }
    }
}

struct ContratoServicioFleteView: View {
    @State private var termsAccepted = false
    
    var body: some View {
        Text("Contrato de flete")
            .font(.largeTitle)
//            .fontWeight(.bold)
            .padding(.bottom, 10)
        Divider()
        
        ScrollView {
            VStack(spacing: 20) {
                // Información Importante
                VStack(alignment: .leading, spacing: 10) {
                    Text("Firma de Contrato mediante Mifiel")
                        .font(.headline)
                        .padding(.top, 10)

                    Text("MiFiel es una plataforma que facilita la firma electrónica de contratos y documentos de manera segura y legal, utilizando la Firma Electrónica Avanzada (FIEL) proporcionada por el SAT. La FIEL tiene la misma validez legal que una firma autógrafa en México.")
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instrucciones")
                        .font(.title)
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        StepView(number: 1, text: "Negocia los términos", description: "Primero, tú y la otra parte acuerdan los detalles del contrato directamente en nuestra plataforma.")
                        StepView(number: 2, text: "Generación automática", description: "Una vez que ambos estén de acuerdo, el contrato se genera automáticamente con los términos que negociaron.")
                        StepView(number: 3, text: "Revisión en MiFiel", description: "El contrato se enviará directamente a tu cuenta de MiFiel. Ahí podrás revisarlo antes de firmar.")
                        StepView(number: 4, text: "Firma el contrato", description: "Desde MiFiel, podrás firmar el contrato con tu Firma Electrónica (FIEL) de manera segura.")
                        StepView(number: 5, text: "Espera la firma de la otra parte", description: "La otra parte también firmará el contrato desde su cuenta de MiFiel.")
                        StepView(number: 6, text: "Contrato completo", description: "Una vez que ambas partes hayan firmado, el contrato estará completo y podrás descargarlo.")
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
                    Text("Ir a firmar mi contrato en Mifiel")
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
    }
}

struct StepView: View {
    let number: Int
    let text: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(number)")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 30, height: 30)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(text)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct PagoSTPFleteView: View {
    @State private var termsAccepted = false
    
    var body: some View {
        Text("Pago STP de flete")
            .font(.largeTitle)
//            .fontWeight(.bold)
            .padding(.bottom, 10)
        Divider()
        
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
                        StepView(number: 1, text: "Registra tu cuenta", description: "Ingresa a la plataforma y registra tu cuenta bancaria para poder realizar pagos.")
                        StepView(number: 2, text: "Genera la orden de pago", description: "Crea una orden de pago con los detalles del flete que deseas pagar.")
                        StepView(number: 3, text: "Confirma el pago", description: "Revisa los detalles de la orden y confirma el pago a través de la plataforma STP.")
                        StepView(number: 4, text: "Verificación", description: "STP realizará la verificación de la transferencia de manera rápida y segura.")
                        StepView(number: 5, text: "Pago completado", description: "Una vez completado el proceso, recibirás la confirmación de que el pago ha sido realizado exitosamente.")
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
                    Text("Ir a firmar mi contrato en Mifiel")
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
    }
}

struct TransportistaPrim_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaPrim(tranPrimStep: 4)
    }
}
