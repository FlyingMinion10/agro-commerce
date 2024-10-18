import SwiftUI

struct StepsView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    private let myAccountType: String = ProfileView.accountType
    
    // Variables heredadas desde ChatsView para la negociación
    var interaction_id: Int
    var producto_completo: String
    var buyer: String
    var seller: String
    var currentStep: Int
    
    // Importar elemento para volver a la vista anterior
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
                    Text("Pasos")
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
                    if myAccountType == "Bodeguero" {
                        // MARK: - STEPS DEL BODEGUERO // STEPS DEL BODEGUERO
                        // STEPS DEL BODEGUERO // STEPS DEL BODEGUERO // STEPS DEL BODEGUERO
                        VStack(spacing: 20) {
                            NavigationLink(destination: ContratoStep(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Contrato C-V")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 1)
                            
                            HStack {
                                Image(systemName: "lock")
                                Text("Form Agro")
                            }
                            .lockedStepStyle(currentStep: currentStep, step: 2)
                        
                            NavigationLink(destination: FormBodega(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Form Bodeguero")
                                }
                            }
                            .activeStepStyle(color: .blue, currentStep: currentStep, step: 3)
                            
                            NavigationLink(destination: TransporteStep(interaction_id: interaction_id, producto_completo: producto_completo)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 4)
                            
                            NavigationLink(destination: Paso5View()) {
                                HStack {
                                    Text("Paso 5")
                                }
                            }
                            .activeStepStyle(color: .purple, currentStep: currentStep, step: 5)
                            
                            NavigationLink(destination: Paso6View()) {
                                HStack {
                                    Text("Paso 6")
                                }
                            }
                            .activeStepStyle(color: .orange, currentStep: currentStep, step: 6)

                            NavigationLink(destination: Paso7View()) {
                                HStack {
                                    Text("Transportista 1 (1,2,3)")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 7)

                            NavigationLink(destination: Paso8View()) {
                                HStack {
                                    Text("Pago STP")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 8)

                            NavigationLink(destination: Paso9View()) {
                                HStack {
                                    Text("Transportista 2 (4,5,6,7)")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 9)

                            NavigationLink(destination: Paso10View()) {
                                HStack {
                                    Text("Inspeccion")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 10)

                            NavigationLink(destination: Paso11View()) {
                                HStack {
                                    Text("Corrección")
                                }
                            }
                            .activeStepStyle(color: .blue, currentStep: currentStep, step: 11)

                            NavigationLink(destination: Paso12View()) {
                                HStack {
                                    Text("Contrato C-V (modificado)opcional")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 12)

                            NavigationLink(destination: Paso13View()) {
                                HStack {
                                    Text("Transportista 3 (8,9,10, 11, 12)")
                                }
                            }
                            .activeStepStyle(color: .purple, currentStep: currentStep, step: 13)

                            NavigationLink(destination: Paso14View()) {
                                HStack {
                                    Text("Liberar Pago")
                                }
                            }
                            .activeStepStyle(color: .orange, currentStep: currentStep, step: 14)

                            NavigationLink(destination: Paso15View()) {
                                HStack {
                                    Text("Rating")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 15)

                            NavigationLink(destination: Paso16View()) {
                                HStack {
                                    Text("Factura")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 16)

                            NavigationLink(destination: Paso17View()) {
                                HStack {
                                    Text("Finalizar Transacción")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 17)

                        }
                        .padding(.top, 20)
                        .frame(width: screenWidth, height: .infinity)
                    } else {
                        // MARK: - STEPS DEL AGRICULTOR // STEPS DEL AGRICULTOR
                        // STEPS DEL AGRICULTOR // STEPS DEL AGRICULTOR // STEPS DEL AGRICULTOR
                        VStack(spacing: 20) {
                            NavigationLink(destination: ContratoStep(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Contrato C-V")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 1)

                            NavigationLink(destination: FormAgr(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Form Agro")
                                }
                            }
                            .activeStepStyle(color: .red, currentStep: currentStep, step: 2)
                            
                            HStack {
                                    Image(systemName: "lock")
                                    Text("Form Bodeguero")
                            }
                            .lockedStepStyle(currentStep: currentStep, step: 3)
                            
                            NavigationLink(destination: TransporteStep(interaction_id: interaction_id, producto_completo: producto_completo)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 4)
                            
                            NavigationLink(destination: Paso5View()) {
                                HStack {
                                    Text("Paso 5")
                                }
                            }
                            .activeStepStyle(color: .purple, currentStep: currentStep, step: 5)
                            
                            NavigationLink(destination: Paso6View()) {
                                HStack {
                                    Text("Paso 6")
                                }
                            }
                            .activeStepStyle(color: .orange, currentStep: currentStep, step: 6)
                        }
                        .padding(.top, 20)
                        .frame(width: screenWidth, height: .infinity)
                    }
                }
            }
//            .background(Color.gray.opacity(0.1))
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension View {
    func activeStepStyle(color: Color, currentStep: Int, step: Int) -> some View {
        self
            .frame(width: 330, height: 65)
            .background(Color.white)
            .foregroundStyle(Color.black.opacity(currentStep < step ? 0.5 : 1))
            .font(.system(size: 25))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .disabled(currentStep < step)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(currentStep < step ? 0.5 : 1), lineWidth: 2)
            )
    }
}

extension View {
    func lockedStepStyle(currentStep: Int, step: Int) -> some View {
        self
            .frame(width: 330, height: 65)
            .foregroundStyle(Color.black.opacity(currentStep < step ? 0.5 : 1))
            .font(.system(size: 25))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(currentStep < step ? 0.5 : 1), lineWidth: 2)
            )
    }
}

struct Paso1View: View {
    var body: some View {
        Text("Paso uno insption")
    }
}

struct Paso2View: View {
    var body: some View {
        Text("Paso dos insption")
    }
}

struct Paso4View: View {
    var body: some View {
        Text("Paso cuatro insption")
    }
}

struct Paso5View: View {
    var body: some View {
        Text("Paso cinco insption")
    }
}

struct Paso6View: View {
    var body: some View {
        Text("Paso seis insption")
    }
}

struct Paso7View: View {
    var body: some View {
        Text("Paso siete insption")
    }
}

struct Paso8View: View {
    var body: some View {
        Text("Paso ocho insption")
    }
}

struct Paso9View: View {
    var body: some View {
        Text("Paso nueve insption")
    }
}

struct Paso10View: View {
    var body: some View {
        Text("Paso diez insption")
    }
}

struct Paso11View: View {
    var body: some View {
        Text("Paso once insption")
    }
}

struct Paso12View: View {
    var body: some View {
        Text("Paso doce insption")
    }
}

struct Paso13View: View {
    var body: some View {
        Text("Transportista 3")
    }
}

struct Paso14View: View {
    var body: some View {
        Text("Liberar Pago")
    }
}

struct Paso15View: View {
    var body: some View {
        Text("Rating")
    }
}

struct Paso16View: View {
    var body: some View {
        Text("Factura")
    }
}

struct Paso17View: View {
    var body: some View {
        Text("Finalizar Transacción")
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(interaction_id: 3, producto_completo: "Aguacate Hass", buyer: "p", seller: "j", currentStep: 15)
    }
}
