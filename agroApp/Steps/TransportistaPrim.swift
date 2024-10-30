//
//  TransportistaSec 2.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 23/10/24.
//
import SwiftUI

struct TransportistaPrim : View {
    let screenWidth = UIScreen.main.bounds.width
    var tranStep: Int
    var interaction_id: Int
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    Text("Transportista 1-3")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.black.opacity(0.9))
                        .padding(.vertical, 20)
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: ContratoServicioTP(interaction_id: interaction_id)) {
                            HStack {
                                Text("Contrato transportista")
                            }
                        }
                        .activeStepStyle(color: .red, currentStep: tranStep, step: 1)
                        
                        NavigationLink(destination: PagoSTP_TP(interaction_id: interaction_id)) {
                            HStack {
                                Text("Pago 15% STP")
                            }
                        }
                        .activeStepStyle(color: .orange, currentStep: tranStep, step: 2)
                        
                    }
                    .frame(width: 360)
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Paso secundario 1
struct ContratoServicioTP: View {
    @State private var termsAccepted = false
    var interaction_id: Int
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        dismiss_header(title: "Contrato de Servicio de Flete")
        ScrollView {
            VStack(spacing: 20) {
                // Información Importante
                VStack(alignment: .leading, spacing: 10) {
                    Text("Firma de Contrato mediante Mifiel")
                        .font(.headline)
                        .padding(.top, 10)

                    Text("MiFiel es una plataforma que facilita la firma electrónica de contratos y documentos de manera segura y legal, utilizando la Firma Electrónica Avanzada (FIEL) proporcionada por el SAT. La FIEL tiene la misma validez legal que una firma autógrafa en México.")
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Instrucciones")
                        .font(.title)
                        .padding(.top, 10)

                    VStack(alignment: .leading, spacing: 15) {
                        InfoTutoRec(number: 1, text: "Negocia los términos", description: "Primero, tú y la otra parte acuerdan los detalles del contrato directamente en nuestra plataforma.")
                        InfoTutoRec(number: 2, text: "Generación automática", description: "Una vez que ambos estén de acuerdo, el contrato se genera automáticamente con los términos que negociaron.")
                        InfoTutoRec(number: 3, text: "Revisión en MiFiel", description: "El contrato se enviará directamente a tu cuenta de MiFiel. Ahí podrás revisarlo antes de firmar.")
                        InfoTutoRec(number: 4, text: "Firma el contrato", description: "Desde MiFiel, podrás firmar el contrato con tu Firma Electrónica (FIEL) de manera segura.")
                        InfoTutoRec(number: 5, text: "Espera la firma de la otra parte", description: "La otra parte también firmará el contrato desde su cuenta de MiFiel.")
                        InfoTutoRec(number: 6, text: "Contrato completo", description: "Una vez que ambas partes hayan firmado, el contrato estará completo y podrás descargarlo.")
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
                    updateToTranStep2()
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
        .navigationBarBackButtonHidden(true)
    }

    func updateToTranStep2() { 
        guard let url = URL(string: "\(Stock.endPoint)/api/tran/step-one/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos formateados
        let idToUpdateTranStep: [String: Any] = [
            "interaction_id": interaction_id
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: idToUpdateTranStep, options: []) else {
            print("Error al serializar los datos para confirmar la recolección de empaque")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar los datos: \(error)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error en la respuesta del servidor updateToTranStep2()")
                return
            }

            do {
            //    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            //        print("Respuesta del servidor: \(json)")
            //        // Aquí puedes manejar la respuesta del servidor
            //    }
                
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

// MARK: - Paso secundario 2
struct PagoSTP_TP: View {
    @State private var termsAccepted = false
    var interaction_id: Int
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        dismiss_header(title: "Pago STP de flete")
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
                    updateToTranStep3()
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

    func updateToTranStep3() { 
        guard let url = URL(string: "\(Stock.endPoint)/api/tran/step-two/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos formateados
        let idToUpdateTranStep: [String: Any] = [
            "interaction_id": interaction_id
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: idToUpdateTranStep, options: []) else {
            print("Error al serializar los datos para confirmar la recolección de empaque")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar los datos: \(error)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error en la respuesta del servidor updateToTranStep3()")
                return
            }

            do {
            //    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            //        print("Respuesta del servidor: \(json)")
            //        // Aquí puedes manejar la respuesta del servidor
            //    }
                
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct TransportistaPrim_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaPrim(tranStep: 4, interaction_id: 3)
    }
}
