import SwiftUI

struct StepsView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    private let myAccountType: String = ProfileView.accountType
    
    // Variables heredadas desde ChatsView para la negociación
    var interaction_id: Int
    var publication_id: Int
    var item_preview: String
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
                        // MARK: - STEPS DEL BODEGUERO
                        VStack(spacing: 20) {
                            HStack {
                                Image(systemName: "lock")
                                Text("Ubicación Rancho")
                            }
                            .lockedStepStyle(currentStep: currentStep, step: 1)
                        
                            NavigationLink(destination: BodegaStep(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Ubicación bodega")
                                }
                            }
                            .activeStepStyle(color: .blue, currentStep: currentStep, step: 2)
                            
                            NavigationLink(destination: TransporteStep(interaction_id: interaction_id, publication_id: publication_id, item_preview: item_preview)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 3)
                            
                            NavigationLink(destination: Paso4View()) {
                                HStack {
                                    Text("Contrato bodeguero")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 4)
                            
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
                    } else {
                        // MARK: - STEPS DEL AGRICULTOR
                        VStack(spacing: 20) {
                            NavigationLink(destination: RanchoStep(interaction_id: interaction_id)) {
                                HStack {
                                    Text("Ubicación Rancho")
                                }
                            }
                            .activeStepStyle(color: .red, currentStep: currentStep, step: 1)
                            
                            HStack {
                                    Image(systemName: "lock")
                                    Text("Ubicación bodega")
                            }
                            .lockedStepStyle(currentStep: currentStep, step: 2)
                            
                            NavigationLink(destination: TransporteStep(interaction_id: interaction_id, publication_id: publication_id, item_preview: item_preview)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 3)
                            
                            HStack {
                                    Image(systemName: "lock")
                                    Text("Contrato bodeguero")
                            }
                            .lockedStepStyle(currentStep: currentStep, step: 4)
                            
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

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(interaction_id: 3, publication_id: 30, item_preview: "Aguacate", buyer: "p", seller: "j", currentStep: 4)
    }
}
