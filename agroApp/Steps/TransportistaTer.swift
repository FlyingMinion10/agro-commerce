//
//  TransportistaSec 2.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 23/10/24.
//
import SwiftUI

struct TransportistaTer : View {
    var tranTerStep: Int
    let screenWidth = UIScreen.main.bounds.width
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
                    Text("Transportista 8-13")
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
                ScrollView {
                    VStack(spacing: 20) {
                        NavigationLink(destination: ConfirmacionLlegadaCamionTran()) {
                            HStack {
                                Text("Confirmar llegada de camión")
                            }
                        }
                        .activeStepStyle(color: .green, currentStep: tranTerStep, step: 1)
                        
                        NavigationLink(destination: LiberarPagoTran()) {
                            HStack {
                                Text("Liberar pago")
                            }
                        }
                        .activeStepStyle(color: .teal, currentStep: tranTerStep, step: 2)
                        
                        NavigationLink(destination: RatingPageTran()) {
                            HStack {
                                Text("Rating")
                            }
                        }
                        .activeStepStyle(color: .green, currentStep: tranTerStep, step: 3)
                        
                        NavigationLink(destination: FacturaTran()) {
                            HStack {
                                Text("Factura")
                            }
                        }
                        .activeStepStyle(color: .teal, currentStep: tranTerStep, step: 4)
                        
                        NavigationLink(destination: FinalizarTransaccionTran()) {
                            HStack {
                                Text("Finalizar")
                            }
                        }
                        .activeStepStyle(color: .green, currentStep: tranTerStep, step: 5)
                    }
                    .frame(width: 360)
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ConfirmacionLlegadaCamionTran: View {
    @State private var empresaPoliciesAccepted: Bool = false
    @State private var confirmArrival: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            dismiss_header(title: "Confirmación de Llegada de Camión")
            ScrollView {
                // Información de la transacción
                VStack(alignment: .leading, spacing: 20) {
                    Text("Información de la Transacción")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("- Tipo de Camión")
                        Text("- Cantidad de Kg")
                        Text("- Cultivo")
                        Text("- Precio del Flete")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Foto de la publicación del cultivo
                VStack(alignment: .leading) {
                    Text("Participantes de la Transacción")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Resumen de contratos de la transacción")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Divider()

                // Políticas de la empresa
                HStack {
                    Button(action: {
                        empresaPoliciesAccepted.toggle()
                    }) {
                        Image(systemName: empresaPoliciesAccepted ? "checkmark.square.fill" : "square")
                            .foregroundColor(.blue)
                    }
                    Text("Políticas de la empresa")
                        .font(.system(size: 20))
                }
                .padding()

                // Confirmación de llegada
                Button(action: {
                    // Acción para confirmar la llegada del producto (por implementar)
                }) {
                    Text("Confirmar Llegada del Producto")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct LiberarPagoTran: View {
    var body: some View {
            VStack(spacing: 20) {

            dismiss_header(title: "Liberación de Pago")
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
        .navigationBarBackButtonHidden(true)
    }
}

struct RatingPageTran: View {
    @State private var negotiationRating: Double = 3.0
    @State private var responseTimeRating: Double = 3.0
    @State private var serviceQualityRating: Double = 3.0
    @State private var overallRating: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            
            dismiss_header(title: "Rating transportista")

            // Sección de calidad de la negociación
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Calidad de la negociación")
                        .font(.headline)
                    Slider(value: $negotiationRating, in: 1...5, step: 1)
                }

                VStack(alignment: .leading) {
                    Text("Calidad del tiempo de respuesta")
                        .font(.headline)
                    Slider(value: $responseTimeRating, in: 1...5, step: 1)
                }

                VStack(alignment: .leading) {
                    Text("Calidad de servicio por parte de AFFin")
                        .font(.headline)
                    Slider(value: $serviceQualityRating, in: 1...5, step: 1)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)

            Divider()

            // Calificación de su experiencia en general
Text("Calificación de su experiencia en general")
    .font(.headline)
    .padding(.top, 10)

// Campo de texto para comentarios
TextField("¿Qué podría mejorar?", text: .constant(""))
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding(.horizontal)

// Rating general con estrellas
            VStack(spacing: 10) {
                HStack {
                    ForEach(1..<6) { index in
                        Image(systemName: index <= overallRating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(index <= overallRating ? .yellow : .gray)
                            .onTapGesture {
                                overallRating = index
                            }
                    }
                }
                .padding(.bottom, 10)

                // Botón de continuar
                Button(action: {
                    // Acción para continuar (por implementar)
                }) {
                    Text("Continuar")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct FacturaTran: View {
    @State private var empresaPoliciesAccepted: Bool = false
    @State private var confirmProcess: Bool = false
    
    var body: some View {
 
            VStack(spacing: 20) {
                dismiss_header(title: "Factura transportista")
            ScrollView {
                // Información del movimiento
                VStack(alignment: .leading, spacing: 20) {
                    Text("Información del Movimiento")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("- Tipo de Movimiento")
                        Text("- Cantidad de Producto")
                        Text("- Precio Total")
                        Text("- Método de Pago")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Participantes de la transacción
                VStack(alignment: .leading) {
                    Text("Participantes de la Transacción")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Resumen de la transacción")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Rectangle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(height: 150)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Divider()

            
              
                .padding()

                // Pasos para obtener la factura
                VStack(alignment: .leading, spacing: 15) {
                    Text("Pasos para Obtener la Factura")
                        .font(.headline)
                        .padding(.bottom, 5)
                    InfoTutoRec(number: 1, text: "Revisión de Datos", description: "Verifica la información del movimiento de compra-venta para asegurarte de que sea correcta.")
                    InfoTutoRec(number: 2, text: "Solicitud de Factura", description: "Solicita la factura a través de nuestra plataforma proporcionando los detalles requeridos.")
                    InfoTutoRec(number: 3, text: "Confirmación de la Solicitud", description: "Confirma la solicitud de factura para que podamos procesarla.")
                    InfoTutoRec(number: 4, text: "Recepción de la Factura", description: "Una vez procesada, recibirás la factura en tu correo electrónico registrado.")
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

                // Confirmación del proceso
                HStack {
                    Button(action: {
                        confirmProcess.toggle()
                    }) {
                        Image(systemName: confirmProcess ? "checkmark.square.fill" : "square")
                            .foregroundColor(.blue)
                    }
                    Text("Políticas de provacidad y terminos de uso")
                        .font(.system(size: 20))
                }
                .padding()

                // Botón para generar factura
                Button(action: {
                    // Acción para generar la factura (por implementar)
                }) {
                    Text("Ir a Mifiel y obtener factura")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
    }
}

struct FinalizarTransaccionTran: View {
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
        .navigationBarBackButtonHidden(true)
    }
}


struct TransportistaTer_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaTer(tranTerStep: 5)
    }
}
