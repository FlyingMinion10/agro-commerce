import SwiftUI

struct InfoTutoRec: View {
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

struct dismiss_header: View {
    var title: String
    let screenWidth = UIScreen.main.bounds.width
    @Environment(\.dismiss) var dismiss
    var body: some View {
        HStack{
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 24))
            }
            Spacer()
            Text(title)
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

    }
}

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
                            
                            NavigationLink(destination: NegociacionTran(interaction_id: interaction_id, producto_completo: producto_completo)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 4)
                            
                            NavigationLink(destination: TransportistaPrim(tranPrimStep: 2)) { // MFM
                                HStack {
                                    Text("Transportista 1 (1-3)")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 5)
                            
                            NavigationLink(destination: PagoSTPStep()) { // MFM
                                HStack {
                                    Text("Pago STP")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 6)

                            NavigationLink(destination: TransportistaSec(tranSecStep: 4)) { // MFM
                                HStack {
                                    Text("Transportista 2 (4-7)")
                                }
                            }
                            .activeStepStyle(color: .purple, currentStep: currentStep, step: 7)
                            
                            NavigationLink(destination: InspeccionCorreccion()) {
                                HStack {
                                    Text("Inspeción Corrección")
                                }
                            }
                            .activeStepStyle(color: .blue, currentStep: currentStep, step: 8)

                            NavigationLink(destination: ContratoModStep(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Contrato Modificado")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 9)

                            NavigationLink(destination: TransportistaTer(tranTerStep: 5)) {
                                HStack {
                                    Text("Transportista 3 (8-13)")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 10)

                            NavigationLink(destination: LiberarPago()) {
                                HStack {
                                    Text("Liberar Pago")
                                }
                            }
                            .activeStepStyle(color: .orange, currentStep: currentStep, step: 11)

                            NavigationLink(destination: RatingPage()) {
                                HStack {
                                    Text("Rating")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 12)

                            NavigationLink(destination: FacturaCompraVenta()) {
                                HStack {
                                    Text("Factura compra-venta")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 13)

                            NavigationLink(destination: FinalizarTransaccion()) {
                                HStack {
                                    Text("Finalizar Transacción")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 14)

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
                            
                            NavigationLink(destination: NegociacionTran(interaction_id: interaction_id, producto_completo: producto_completo)) {
                                HStack {
                                    Text("Negociacion transporte")
                                }
                            }
                            .activeStepStyle(color: .green, currentStep: currentStep, step: 4)
                            NavigationLink(destination: TransportistaPrim(tranPrimStep: 2)) {
                                HStack {
                                    Text("Transportista 1 (1-3)")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 5)

                            NavigationLink(destination: PagoSTPStep()) {
                                HStack {
                                    Text("Pago STP")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 6)

                            NavigationLink(destination: TransportistaSec(tranSecStep: 4)) {
                                HStack {
                                    Text("Transportista 2 (4-7)")
                                }
                            }
                            .activeStepStyle(color: .purple, currentStep: currentStep, step: 7)

                            NavigationLink(destination: InspeccionCorreccion()) {
                                HStack {
                                    Text("Inspeción Corrección")
                                }
                            }
                            .activeStepStyle(color: .blue, currentStep: currentStep, step: 8)

                            NavigationLink(destination: ContratoModStep(interaction_id: interaction_id, step: currentStep)) {
                                HStack {
                                    Text("Contrato Modificado")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 9)

                            NavigationLink(destination: TransportistaTer(tranTerStep: 5)) {
                                HStack {
                                    Text("Transportista 3 (8-13)")
                                }
                            }
                            .activeStepStyle(color: .yellow, currentStep: currentStep, step: 10)

                            NavigationLink(destination: LiberarPago()) {
                                HStack {
                                    Text("Liberar Pago")
                                }
                            }
                            .activeStepStyle(color: .orange, currentStep: currentStep, step: 11)

                            NavigationLink(destination: RatingPage()) {
                                HStack {
                                    Text("Rating")
                                }
                            }
                            .activeStepStyle(color: .pink, currentStep: currentStep, step: 12)

                            NavigationLink(destination: FacturaCompraVenta()) {
                                HStack {
                                    Text("Factura compra-venta")
                                }
                            }
                            .activeStepStyle(color: .cyan, currentStep: currentStep, step: 13)

                            NavigationLink(destination: FinalizarTransaccion()) {
                                HStack {
                                    Text("Finalizar Transacción")
                                }
                            }
                            .activeStepStyle(color: .gray, currentStep: currentStep, step: 14)
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

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(interaction_id: 3, producto_completo: "Aguacate Hass", buyer: "p", seller: "j", currentStep: 15)
    }
}
