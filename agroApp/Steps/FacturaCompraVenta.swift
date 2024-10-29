//
//  FacturaCompraVentaView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//
import SwiftUI

struct FacturaCompraVenta: View {
    @State private var empresaPoliciesAccepted: Bool = false
    @State private var confirmProcess: Bool = false
    
    var body: some View {
 
            VStack(spacing: 20) {
                Text("Generación de Factura de Movimiento de Compra-Venta")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Divider()
                    .padding(.horizontal)
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
    }
}



struct FacturaCompraVenta_Previews: PreviewProvider {
    static var previews: some View {
        FacturaCompraVenta()
    }
}
