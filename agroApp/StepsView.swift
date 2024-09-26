import SwiftUI

struct StepsView: View {
    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        VStack(spacing: 20) {
            ForEach(1...8, id: \.self) { step in
                let opacity: Double = Double(step)/8
                HStack {
                    Text("Paso \(step)")
                        .foregroundColor(.blue.opacity(opacity))
                        .font(.headline)
                }
                .frame(width: screenWidth-60, height: 35)
                .padding(10)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView()
    }
}
