import SwiftUI

struct PasosIniciales: View {
    var label: String
    var body: some View {
        HStack {
            Text(label)
                .lineLimit(1)
                .truncationMode(.tail)
            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                .foregroundStyle(Color.accentColor)
        }
        .padding(.vertical, 3)
    }
}

struct SubTitle: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .font(.system(size: 30))
                .bold()
                .foregroundStyle(Color.black.opacity(0.7))
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
}

struct CalendarView: View {
    @State private var currentDate = Date() // Fecha actual
    @State private var events: [Event] = [
        Event(date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 20))!, title: "Evento 1"),
        Event(date: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 25))!, title: "Evento 2")
    ]

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            // Mes y año
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(currentMonthYear)
                    .font(.headline)
                Spacer()
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            // Días de la semana
            HStack {
                ForEach(["L", "M", "X", "J", "V", "S", "D"], id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                }
            }

            // Días del mes
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(daysInMonth, id: \.self) { day in
                    VStack {
                        Text("\(day)")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                            .background(hasEvent(on: day) ? Color.blue.opacity(0.3) : Color.clear)
                            .clipShape(Circle())
                            .foregroundColor(.black)

                        // Mostrar el título del evento si coincide con la fecha
                        if let event = eventFor(day: day) {
                            Text(event.title)
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .onTapGesture {
                        if let event = eventFor(day: day) {
                            print("Evento seleccionado: \(event.title)")
                        }
                    }
                }
            }
        }
        .padding()
    }

    // Computed property para obtener el mes y el año actual
    private var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    // Computed property para obtener los días del mes actual
    private var daysInMonth: [Int] {
        let range = Calendar.current.range(of: .day, in: .month, for: currentDate)!
        return Array(range)
    }

    // Función para verificar si hay un evento en un día específico
    private func hasEvent(on day: Int) -> Bool {
        guard let date = dateFor(day: day) else { return false }
        return events.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // Obtener el evento asociado a un día específico
    private func eventFor(day: Int) -> Event? {
        guard let date = dateFor(day: day) else { return nil }
        return events.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    // Obtener una fecha completa para un día específico
    private func dateFor(day: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month], from: currentDate)
        components.day = day
        return Calendar.current.date(from: components)
    }
}

struct TransactionScrollView: View {
    @State private var progress: Double = 0.3
    var name: String = "Interlocutor"
    var rating: Int = 5

    // Variables heredadas desde ChatsView para la negociación
    var interaction_id: Int
    var producto_completo: String
    var buyer: String
    var seller: String
    var currentStep: Int

    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("Manzana")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .offset(x: 30)
                    Image("Manzana")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
                HStack {
                    Text("\(name)  \(rating)")
                        .padding(.leading, 10)
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.yellow)
                        .padding(.leading, -5)
                }
                .font(.title2)
                Spacer()
                // Botón de chat
                Button(action: {
                    print("Chat button pressed")
                }) {
                    Image(systemName: "message")
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .overlay(
                Capsule()
                    .frame(height: 1) // Altura del borde
                    .foregroundColor(.accentColor), alignment: .bottom // Color y alineación
            )
            
            ScrollView {
                VStack {
                    // Barra de progreso personalizada
                    SubTitle(text: "Progreso de la transacción")
                    ZStack(alignment: .leading) {
                        // Fondo de la barra
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 20) // Tamaño de la barra
                        
                        // Progreso
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(progress) * 300, height: 20) // Ancho según el progreso
                    }
                    .padding()
                    
                    // Calendario de eventos
                    SubTitle(text: "Calendario de eventos")
                    CalendarView() // Integración del calendario aquí
                    
                    // Tabla de meta 1
                    SubTitle(text: "META 1")
                    VStack {
                        LazyVGrid(columns: [GridItem(.fixed(160)), GridItem(.fixed(160))]) {
                            PasosIniciales(label: "Negociación Inicial")
                            PasosIniciales(label: "Financiamiento de Insumos")
                            PasosIniciales(label: "Cuidados y Siembra")
                            PasosIniciales(label: "Cosecha y entrega")
                            PasosIniciales(label: "Evaluacion de calidad")
                            PasosIniciales(label: "Liquidacion y pagos")
                            PasosIniciales(label: "Garantias y Resp")
                            PasosIniciales(label: "Confidencialidad y restricciones")
                        }
                    }
                    .frame(width: 340)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(1), lineWidth: 1)
                    )
                    // Tabla de meta 2
                    SubTitle(text: "META 2")
                    HStack {
                        Text("Ir a firmar contrato")
//                            .font(.system(size: 20))
                        Image(systemName: "arrowshape.right.fill")
                        
                    }
                    .font(.system(size: 20))
                    .frame(width: 340)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black.opacity(1), lineWidth: 1)
                    )
                    VStack {
                        StepsView(interaction_id: interaction_id, producto_completo: chat.item_preview, buyer: chat.buyer, seller: chat.seller, currentStep: monopoly.first?.step ?? 0)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView()
    }
}
