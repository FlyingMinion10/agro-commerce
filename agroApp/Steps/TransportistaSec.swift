//
//  TransportistaSec.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 22/10/24.
//
import SwiftUI

struct TransportistaSec : View {
    var currentStep: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    NavigationLink(destination: RecoleccionDeEmpaqueView()) {
                        HStack {
                            Text("Recolección de Empaque")
                        }
                    }
                    .activeStepStyle(color: .mint, currentStep: currentStep, step: 1)
                    
                    NavigationLink(destination: Bascula1View()) {
                        HStack {
                            Text("Báscula 1")
                        }
                    }
                    .activeStepStyle(color: .cyan, currentStep: currentStep, step: 2)
                    
                    NavigationLink(destination: EvidenciaInspeccionView()) {
                        HStack {
                            Text("Evidencia para Inspección")
                        }
                    }
                    .activeStepStyle(color: .blue, currentStep: currentStep, step: 3)
                    
                    NavigationLink(destination: Bascula2View()) {
                        HStack {
                            Text("Báscula 2")
                        }
                    }
                    .activeStepStyle(color: .indigo, currentStep: currentStep, step: 4)
                }
                .frame(width: 360)
            }
            .navigationTitle("Opciones")
        }
    }
}

struct RecoleccionDeEmpaqueView: View {
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            // Instrucciones
            Text("El transportista reliza la recolección de los empaques (ya sean cajas, costales etc) antes de pesar el flete y manda una evidencia de la recolección de los empaques.")
                .italic()
            Spacer()
            // Botones
            Button(action: {
                showConfirmation = true
            }) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Confirmar Acción")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("¿Seguro que quieres confirmar?"),
                    primaryButton: .default(Text("Sí")),
                    secondaryButton: .cancel(Text("No"))
                )
            }
            .padding()
            Spacer()
            // Disclaimer
            Text("El transportista reliza la recolección de los empaques (ya sean cajas, costales etc) antes de pesar el flete y manda una evidencia de la recolección de los empaques.")
                
        }
        .navigationTitle("Recolección de Empaque")
    }
}

struct Bascula1View: View {
    var body: some View {
        VStack {
            Button("Tomar Foto") {
                // Acción para tomar foto
            }
            Button("Importar Foto") {
                // Acción para importar foto
            }
            TextField("Inserte Peso (Incluye foto del camión)", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationTitle("Báscula 1")
    }
}

struct EvidenciaInspeccionView: View {
    var body: some View {
        VStack {
            Button("Tomar Foto") {
                // Acción para tomar foto
            }
            Button("Importar Foto") {
                // Acción para importar foto
            }
            TextField("Insertar descripción o estado de producto inspeccionado", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationTitle("Evidencia para Inspección")
    }
}

struct Bascula2View: View {
    var body: some View {
        VStack {
            Button("Tomar Foto") {
                // Acción para tomar foto
            }
            Button("Importar Foto") {
                // Acción para importar foto
            }
            TextField("Inserte Peso (Incluye foto del camión)", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationTitle("Báscula 2")
    }
}

struct TransportistaSec_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaSec(currentStep: 4)
    }
}
