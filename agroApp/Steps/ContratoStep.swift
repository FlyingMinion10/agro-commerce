import SwiftUI

struct ContratoStepView: View {
    @State private var isAccepted: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Términos y Condiciones")
                .font(.title)
                .padding(.bottom, 10)
            
            ScrollView {
                Text("""
                Aquí van los términos y condiciones detallados...
                """)
                .padding()
            }
            .frame(height: 300)
            .border(Color.gray, width: 1)
            
            HStack {
                CheckBoxView(isChecked: $isAccepted)
                Text("Acepto los términos y condiciones")
            }
            
            Button(action: {
                // Acción al enviar
            }) {
                Text("Enviar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isAccepted ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isAccepted)
        }
        .padding()
    }
}

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .blue : .gray)
                .font(.system(size: 20))
        }
    }
}

struct ContratoStepView_Previews: PreviewProvider {
    static var previews: some View {
        ContratoStepView()
    }
}
