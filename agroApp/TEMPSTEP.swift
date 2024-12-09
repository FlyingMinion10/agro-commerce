//
//  PasosIniciales.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 08/12/24.
//


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
    let screenWidth = UIScreen.main.bounds.width

    @State private var progress: Double = 0.3
    var name: String = "Interlocutor"
    var rating: Int = 5

    // State Variables
    private let myAccountType: String = ProfileView.accountType
    @State var tranStep: Int?

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
                    
                    // MARK: - META 1
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
                    
                    // MARK: - META 2
                    SubTitle(text: "META 2")
                    ZStack(alignment: .leading) {
                        // Fondo de la barra
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 20) // Tamaño de la barra
                        
                        // Progreso
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(progress) * 300, height: 15) // Ancho según el progreso
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        NavigationLink(destination: ContratoStep(interaction_id: interaction_id, step: currentStep)) {
                            meta2style(currentStep: currentStep, step: 1, text: "Contrato compra-venta")
                        }
                        /// Divider()
                        NavigationLink(destination: FormAgr(interaction_id: interaction_id, step: currentStep)) {
                            meta2style(currentStep: currentStep, step: 2, text: "Datos Agricultor")
                        }
                        /// Divider()
                        NavigationLink(destination: FormBodega(interaction_id: interaction_id, step: currentStep)) {
                            meta2style(currentStep: currentStep, step: 3, text: "Datos Bodeguero")
                        }
                        /// Divider()
                        NavigationLink(destination: NegociacionTran(interaction_id: interaction_id, producto_completo: producto_completo)) {
                            meta2style(currentStep: currentStep, step: 4, text: "Negociacion transporte")
                        }
                        /// Divider()
                        NavigationLink(destination: TransportistaPrim(tranStep: tranStep ?? 0, interaction_id: interaction_id)) { // MFM
                            meta2style(currentStep: currentStep, step: 5, text: "Transportista 1 (1-2)")
                        }
                        /// Divider()
                        NavigationLink(destination: PagoSTPStep()) { // MFM
                            meta2style(currentStep: currentStep, step: 6, text: "Pago STP")
                        }
                        /// Divider()
                        NavigationLink(destination: TransportistaSec(tranStep: tranStep ?? 0, interaction_id: interaction_id)) { // MFM
                            meta2style(currentStep: currentStep, step: 7, text: "Transportista 2 (3-7)")
                        }
                        /// Divider()
                        NavigationLink(destination: InspeccionCorreccion(interaction_id: interaction_id, seller: seller)) {
                            meta2style(currentStep: currentStep, step: 8, text: "Inspeccion y correccion")
                        }
                        /// Divider()
                        NavigationLink(destination: ContratoModStep(interaction_id: interaction_id, step: currentStep)) {
                            meta2style(currentStep: currentStep, step: 9, text: "Contrato modificacion")
                        }
                        /// Divider()
                        NavigationLink(destination: TransportistaTer(tranStep: tranStep ?? 0)) {
                            meta2style(currentStep: currentStep, step: 10, text: "Transportista 3 (8-10)")
                        }
                        /// Divider()
                        NavigationLink(destination: LiberarPago()) {
                            meta2style(currentStep: currentStep, step: 11, text: "Liberar pago")
                        }
                        /// Divider()
                        NavigationLink(destination: RatingPage()) {
                            meta2style(currentStep: currentStep, step: 12, text: "Rating")
                        }
                        /// Divider()
                        NavigationLink(destination: FacturaCompraVenta()) {
                            meta2style(currentStep: currentStep, step: 13, text: "Factura compra-venta")
                        }
                        /// Divider()
                        NavigationLink(destination: FinalizarTransaccion()) {
                            meta2style(currentStep: currentStep, step: 14, text: "Finalizar transaccion")
                        }

                    }
                    .frame(width: 340)
                    .padding(10)
                    
                    // MARK: - Pagos y financiamiento
                    SubTitle(text: "Pagos y Financiamento")
                    VStack{
                        // Próximos pagos
                        FinanceView(title: "Próximos Pagos") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Pago transportista - 1 enero")
                                Text("Pago Factura insumo [183405]")
                                Text("Pago cosecha - 5 enero")
                                Text("Pago transportista - 5 enero")
                            }
                            .frame(width: 300)
                        }

                        // Insumos y Financiamiento
                        FinanceView(title: "Insumos y Financiamiento") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Facturas y Pagos de insumos")
                                Text("Factura [183405] [Fecha] [$$$]")
                                    .padding(.leading)

                                Text("Financiamiento Total: $$$")
                                Text("Financiamiento utilizado:")
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("- Plásticos: 50m")
                                    Text("- Semillas: 50kg")
                                    Text("- Semillas: 15")
                                }
                                
                                Button("+ Añadir Financiamiento") {
                                    // Acción al añadir financiamiento
                                }
                            }
                            .frame(width: 300)
                        }

                        // Pagos de Flete
                        FinanceView(title: "Pagos de Flete") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Historial de pagos:")
                                VStack(alignment: .leading) {
                                    Text("- Pago 1 enero $$$ Empresa Trans1")
                                    Text("- Pago 5 enero $$$ Empresa Lum")
                                }
                                Text("Pagos Pendientes:")
                                Text("- Pago 6 enero [Empresa Xmile] $$$")
                                Text("Próximos pagos:")
                                Text("- Pago 14 enero $$$")
                            }
                            .frame(width: 300)
                        }

                        // Pagos del Cultivo
                        FinanceView(title: "Pagos del Cultivo") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Historial de pagos")
                                Text("Pagos Pendientes")
                                Text("Próximos pagos")
                            }
                            .frame(width: 300)
                        }

                        // Estados de Cuenta
                        FinanceView(title: "Estados de Cuenta") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Historial")
                                Text("Tabla de pagos")
                                Text("Total de la transacción")
                                Text("Gráficas")
                            }
                            .frame(width: 300)
                        }
                    }
                    
                    // MARK: - Sección de fletes
                    SubTitle(text: "Sección de fletes")
                    VStack (spacing: 20) {
                        fleteView(fecha: "17 de enero", diasRestantes: 39)
                        fleteView(fecha: "20 de enero", diasRestantes: 42)
                        fleteView(fecha: "25 de enero", diasRestantes: 47)
                        fleteView(fecha: "28 de enero", diasRestantes: 40)
                    }
                    
                    // MARK: - Dudas y reclamos
                    SubTitle(text: "Dudas y Reclamos")
                    VStack(alignment: .leading, spacing: 20) {
                        // Sección de Deudas
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Deudas")
                                .font(.headline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 10) {
                                Text("- $14,500")
                                    .font(.headline)

                                HStack {
                                    Text("[Fecha máxima: 10/12/2024]")
                                    Text("[Penalización: 5%]")
                                    Text("[De dónde: Proveedor A]")
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)

                                Button("Pagar Ahora") {
                                    // Acción para pagar la deuda
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)

                            VStack(alignment: .leading, spacing: 10) {
                                Text("- $120,000")
                                    .font(.headline)

                                HStack {
                                    Text("[Fecha máxima: 15/12/2024]")
                                    Text("[Penalización: 10%]")
                                    Text("[De dónde: Proveedor B]")
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)

                                Button("Pagar Ahora") {
                                    // Acción para pagar la deuda
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }

                        // Sección a Favor
                        VStack(alignment: .leading, spacing: 20) {
                            Text("A favor")
                                .font(.headline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 10) {
                                Text("+ $12,000")
                                    .font(.headline)

                                HStack {
                                    Text("[De dónde: Cliente X]")
                                    Text("[Cuenta de depósito: Banco Y]")
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)

                                Button("Reclamar") {
                                    // Acción para reclamar
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    // MARK: - Facturas
                    SubTitle(text: "Facturas")
                    VStack(alignment: .leading, spacing: 20) {
                        // Sección de Cultivo
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Cultivo")
                                .font(.headline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("1 Febrero")
                                    Text("[Monto]")
                                    Spacer()
                                    Text("[Descargar/Email]")
                                }
                                .font(.subheadline)

                                HStack {
                                    Text("5 Febrero")
                                    Text("[Monto]")
                                    Spacer()
                                    Text("[Descargar/Email]")
                                }
                                .font(.subheadline)
                            }
                        }

                        Divider()

                        // Sección de Insumos
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Insumos")
                                .font(.headline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 10) {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("6 Febrero")
                                        Text("[Monto]")
                                        Text("[I.D. 1]")
                                        Spacer()
                                        Text("[Cotización/Factura]")
                                    }
                                    .font(.subheadline)
                                    Text("PAGADO")
                                        .font(.title3)
                                        .foregroundStyle(Color.blue)
                                }

                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("15 Febrero")
                                        Text("[Monto]")
                                        Text("[Estatus]")
                                        Spacer()
                                        Text("[Cotización/Factura]")
                                    }
                                    .font(.subheadline)

                                    Button("Ir a Pagar") {
                                        // Acción para ir al pago
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }

                        Divider()

                        // Sección de Fletes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Fletes")
                                .font(.headline)
                                .fontWeight(.bold)

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("1 Febrero")
                                    Text("[Monto]")
                                    Spacer()
                                    Text("[Descargar/Email]")
                                }
                                .font(.subheadline)

                                HStack {
                                    Text("15 Febrero")
                                    Text("[Monto]")
                                    Spacer()
                                    Text("[Descargar/Email]")
                                }
                                .font(.subheadline)
                            }
                        }
                    }
                    .padding()

                    // MARK: - Rating
                    SubTitle(text: "Rating")
                    VStack(alignment: .center, spacing: 20) {
                        // Subtítulo
                        Text("Califica tu experiencia:")
                            .font(.headline)

                        // Sección de calificación del sistema
                        VStack(alignment: .center, spacing: 10) {
                            Text("Califica el funcionamiento del sistema")
                                .font(.subheadline)

                            HStack {
                                ForEach(1...5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.yellow)
                                }
                            }
                        }

                        // Sección de calificación del chat
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Califica tu experiencia en el chat")
                                .font(.subheadline)

                            HStack {
                                ForEach(1...5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .font(.title)
                                        .foregroundStyle(Color.yellow)
                                }
                            }
                        }

                        // Comentarios
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Comentario")
                                .font(.subheadline)

                            TextField("Escribe tu comentario aquí", text: .constant(""))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(height: 40)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)

                    // MARK: - Finalizar
                    SubTitle(text: "Finalizar")
                    VStack(alignment: .center, spacing: 20) {
                        Text("Finalizar la transacción, liberar pagos \nmandar resumen a [Email/número].")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .padding(.horizontal)

                        // NIP AFFIN
                        Text("NIP AFFIN")
                            .font(.headline)
                            .fontWeight(.semibold)

                        // Espacios para el NIP
                        HStack(spacing: 15) {
                            ForEach(0..<4, id: \.self) { _ in
                                Rectangle()
                                    .frame(width: 30, height: 2)
                                    .foregroundColor(.black)
                            }
                        }
                        
                        Button(action: {
                            // Acción para finalizar la transacción
                        }) {
                            Text("Finalizar")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.yellow)
                                .cornerRadius(10)
                        }
                        
                    }
                    .cornerRadius(10)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)


                }
                .padding(.horizontal)
            }
            
        }
    }
    func fetchTranStep(interactionID: Int) {
    // func fetchStartingValues() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/tran-step/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interactionID)), // Convertir Int? a String?
        ]

        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al obtener tranStep: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos de la bodega.")
                return
            }

            // Imprimir los datos recibidos en formato JSON
            // if let jsonString = String(data: data, encoding: .utf8) {
            //     print("Datos recibidos del servidor StepView: \(jsonString)") // PRINT FOR DEBUG
            // }

            do {
                let decodedResponse = try JSONDecoder().decode([StepResponse].self, from: data)
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        if let firstResponse = decodedResponse.first {
                            print("Datos decodificados correctamente: \(firstResponse)") // PRINT FOR DEBUG
                            self.tranStep = firstResponse.tran_step
                        }
                    }

                }
            } catch {
                print("Error al decodificar datos de StepView: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let key, let context):
                        print("Tipo no coincide para la clave \(key), \(context.debugDescription)")
                    case .valueNotFound(let key, let context):
                        print("Valor no encontrado para la clave \(key), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Clave no encontrada \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Datos corruptos: \(context.debugDescription)")
                    @unknown default:
                        print("Error desconocido de decodificación")
                    }
                }
            }
        }.resume()
    }
}

struct fleteView: View {
    var fecha: String
    var diasRestantes: Int
    
    var body : some View {
        HStack {
            HStack {
                Text(fecha)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundStyle(Color.red.opacity(1.5))
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Faltan \(diasRestantes) días para esta cosecha")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Button("Info. y Recom.") {
                        // Acción para mostrar información adicional
                    }
                    .font(.footnote)
                    .foregroundColor(.blue)
                }
            }
            Button("Consigue \n un Flete") {
                // Acción para conseguir un flete
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.2))
            .cornerRadius(8)
        }
        .padding(10)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct meta2style: View {
    var currentStep: Int
    var step: Int
    var text: String

    var body: some View {
        HStack {
            Text(text)
                .frame(width: 260, height: 35)
                .foregroundStyle(Color.black.opacity(currentStep < step ? 0.5 : 1))
                .font(.system(size: 20))
                .disabled(currentStep < step)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                .foregroundStyle(Color.superGreen)
                .font(.system(size: 20))
                .padding(.horizontal, 20)

        }
        .frame(width: 330, height: 40)
    }
}

// Reutilizable para secciones
struct FinanceView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            content
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
        
    }
}

extension View {
    func activeStepStyle(currentStep: Int, step: Int) -> some View {
        self
            .frame(width: 330, height: 50)
            .background(Color.white)
            .foregroundStyle(Color.black.opacity(currentStep < step ? 0.5 : 1))
            .font(.system(size: 25))
            .disabled(currentStep < step)
            
    }
}

extension View {
    func lockedStepStyle(currentStep: Int, step: Int) -> some View {
        self
            .frame(width: 330, height: 50)
            .foregroundStyle(Color.black.opacity(currentStep < step ? 0.5 : 1))
            .font(.system(size: 25))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
    }
}

struct TransactionScrollView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionScrollView(interaction_id: 3, producto_completo: "Aguacate Hass", buyer: "p", seller: "j", currentStep: 15)
    }
}
