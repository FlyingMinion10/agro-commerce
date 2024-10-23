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
                    
                    NavigationLink(destination: BasculaGenericView(
                        instructionText: "Tome o importe una foto y registre el peso del camión en la báscula 1.", 
                        navigationTitle: "Báscula 1")) {
                        HStack {
                            Text("Báscula 1")
                        }
                    }
                    .activeStepStyle(color: .cyan, currentStep: currentStep, step: 2)
                    
                    NavigationLink(destination: BasculaGenericView(
                        instructionText: "Tome o importe una foto y registre la evidencia de inspección del producto.", 
                        navigationTitle: "Evidencia para Inspección")) {
                        HStack {
                            Text("Evidencia para Inspección")
                        }
                    }
                    .activeStepStyle(color: .blue, currentStep: currentStep, step: 3)
                    
                    NavigationLink(destination: BasculaGenericView(
                        instructionText: "Tome o importe una foto y registre el peso del camión en la báscula 2.", 
                        navigationTitle: "Báscula 2")) {
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
            
            Spacer()
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
            Text("Descargo de responsabilidad: Este documento es solo para fines informativos y no constituye asesoramiento legal. No nos hacemos responsables de ninguna acción tomada en base a la información proporcionada en este documento. Se recomienda encarecidamente buscar asesoramiento legal profesional antes de tomar cualquier decisión o acción relacionada con el contenido de este documento.")
                .font(.footnote)
                .foregroundStyle(Color.red)
                .italic()
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

struct BasculaGenericView: View {
    let instructionText: String
    let navigationTitle: String
    @State private var termsAccepted = false
    
    var body: some View {
        VStack {
            // Instrucciones
            Text(instructionText)
                .padding()
            
            Spacer()
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
                }
            }) {
                HStack {
                    Image(systemName: "camera.fill")
                        .font(.title)
                    Text("Tomar Foto")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .padding()
            
            Button(action: {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
                }
            }) {
                HStack {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .font(.title)
                    Text("Importar Foto")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            .padding()
            
            TextField("Inserte Peso (Incluye foto del camión)", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                // Code to handle button tap
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    Text("Enviar")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(width: 300)
                .background(Color.green)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            Spacer()
            // Disclaimer        
            Text("Descargo de responsabilidad: Este documento es solo para fines informativos y no constituye asesoramiento legal. No nos hacemos responsables de ninguna acción tomada en base a la información proporcionada en este documento. Se recomienda encarecidamente buscar asesoramiento legal profesional antes de tomar cualquier decisión o acción relacionada con el contenido de este documento.")
                .font(.footnote)
                .foregroundStyle(Color.red)
                .italic()
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
        .navigationTitle(navigationTitle)
    }
}

struct TransportistaSec_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaSec(currentStep: 4)
    }
}
