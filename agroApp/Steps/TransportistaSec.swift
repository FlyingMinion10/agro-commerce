import SwiftUI

struct TransportistaSec : View {
    var tranSecStep: Int
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
                    Text("Transportista 4-7")
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
                        NavigationLink(destination: RecoleccionDeEmpaqueView()) {
                            HStack {
                                Text("Recolección de Empaque")
                            }
                        }
                        .activeStepStyle(color: .mint, currentStep: tranSecStep, step: 1)
                        
                        NavigationLink(destination: BasculaGenericView(
                            instructionText: "Tome o importe una foto y registre el peso del camión en la báscula 1.", 
                            navigationTitle: "Báscula 1")) {
                            HStack {
                                Text("Báscula 1")
                            }
                        }
                        .activeStepStyle(color: .cyan, currentStep: tranSecStep, step: 2)
                        
                        NavigationLink(destination: BasculaGenericView(
                            instructionText: "Tome o importe una foto y registre la evidencia de inspección del producto.", 
                            navigationTitle: "Evidencia para Inspección")) {
                            HStack {
                                Text("Evidencia para Inspección")
                            }
                        }
                        .activeStepStyle(color: .blue, currentStep: tranSecStep, step: 3)
                        
                        NavigationLink(destination: BasculaGenericView(
                            instructionText: "Tome o importe una foto y registre el peso del camión en la báscula 2.", 
                            navigationTitle: "Báscula 2")) {
                            HStack {
                                Text("Báscula 2")
                            }
                        }
                        .activeStepStyle(color: .indigo, currentStep: tranSecStep, step: 4)
                    }
                    .frame(width: 360)
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RecoleccionDeEmpaqueView: View {
    @State private var showConfirmation = false
    @State private var termsAccepted = false
    
    var body: some View {
        VStack {
            dismiss_header(title: "Recolección de empaque")
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
        .navigationBarBackButtonHidden(true)
    }
}

struct BasculaGenericView: View {
    let instructionText: String
    let navigationTitle: String
    @State private var termsAccepted = false
    
    var body: some View {
        VStack {
            dismiss_header(title: navigationTitle)
            // Instrucciones
            Text(instructionText)
                .padding()
            
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
            HStack {
                Button(action: {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        let picker = UIImagePickerController()
                        picker.sourceType = .camera
                        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
                    }
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Tomar Foto")
                    }
                    .padding(.vertical, 15)
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
                        Text("Subir Foto")  
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                }
                .padding()
            }
            
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
                .frame(maxWidth: .infinity)
                .background(termsAccepted ? Color.green : Color.gray)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
            Spacer()
            // Disclaimer        
            Text("Descargo de responsabilidad: Este documento es solo para fines informativos y no constituye asesoramiento legal. No nos hacemos responsables de ninguna acción tomada en base a la información proporcionada en este documento. Se recomienda encarecidamente buscar asesoramiento legal profesional antes de tomar cualquier decisión o acción relacionada con el contenido de este documento.")
                .font(.footnote)
                .foregroundStyle(Color.red)
                .italic()
                .padding()
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
        .navigationBarBackButtonHidden(true)
    }
}

struct TransportistaSec_Previews: PreviewProvider {
    static var previews: some View {
        TransportistaSec(tranSecStep: 4)
    }
}
