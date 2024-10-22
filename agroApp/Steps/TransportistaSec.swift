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
    @State private var termsAccepted = false
    
    var body: some View {
        VStack {
            // Instrucciones
            Text("El transportista realiza la recolección de los empaques (ya sean cajas, costales etc) antes de pesar el flete y manda una evidencia de la recolección de los empaques.")
            
            // Video de YouTube
            VStack {
                Text("Instrucciones en Video")
                    .font(.headline)
                    .padding(.bottom, 10)
                VStack {
                    WebView(url: URL(string: "https://www.youtube.com/watch?v=nwC9jzTYty4")!)
                        .frame(height: 200)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding()
            }
            // Boton
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
                .background(termsAccepted ? Color.green : Color.gray)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .disabled(!termsAccepted)
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("¿Seguro que quieres confirmar?"),
                    primaryButton: .default(Text("Sí")),
                    secondaryButton: .cancel(Text("No"))
                )
            }
            .padding()
            // Disclaimer
            Text("El transportista realiza la recolección de los empaques (ya sean cajas, costales etc) antes de pesar el flete y manda una evidencia de la recolección de los empaques.")
                .italic()
                .foregroundStyle(Color.red)
            HStack {
                Button(action: {
                    termsAccepted.toggle()
                }) {
                    Image(systemName: termsAccepted ? "checkmark.square.fill" : "square")
                        .foregroundColor(.blue)
                }
                Text("Acepto los términos y condiciones")
                    .font(.system(size: 20))
            }
            .padding()
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
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
            Button("Importar Foto") {
                // Acción para importar foto
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
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
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
            Button("Importar Foto") {
                // Acción para importar foto
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
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
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
            Button("Importar Foto") {
                // Acción para importar foto
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
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
