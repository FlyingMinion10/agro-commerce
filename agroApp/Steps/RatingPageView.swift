//
//  RatingPageView.swift
//  affinApp
//
//  Created by Juan Felipe Zepeda on 24/10/24.
//


import SwiftUI

struct RatingPage: View {
    @State private var negotiationRating: Double = 3.0
    @State private var responseTimeRating: Double = 3.0
    @State private var serviceQualityRating: Double = 3.0
    @State private var overallRating: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Rating")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Divider()
                .padding(.horizontal)

            // Sección de calidad de la negociación
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Calidad de la negociación")
                        .font(.headline)
                    Slider(value: $negotiationRating, in: 1...5, step: 1)
                }

                VStack(alignment: .leading) {
                    Text("Calidad del tiempo de respuesta")
                        .font(.headline)
                    Slider(value: $responseTimeRating, in: 1...5, step: 1)
                }

                VStack(alignment: .leading) {
                    Text("Calidad de servicio por parte de AFFin")
                        .font(.headline)
                    Slider(value: $serviceQualityRating, in: 1...5, step: 1)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)

            Divider()

            // Calificación de su experiencia en general
Text("Calificación de su experiencia en general")
    .font(.headline)
    .padding(.top, 10)

// Campo de texto para comentarios
TextField("¿Qué podría mejorar?", text: .constant(""))
    .textFieldStyle(RoundedBorderTextFieldStyle())
    .padding(.horizontal)

// Rating general con estrellas
            VStack(spacing: 10) {
                HStack {
                    ForEach(1..<6) { index in
                        Image(systemName: index <= overallRating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(index <= overallRating ? .yellow : .gray)
                            .onTapGesture {
                                overallRating = index
                            }
                    }
                }
                .padding(.bottom, 10)

                // Botón de continuar
                Button(action: {
                    // Acción para continuar (por implementar)
                }) {
                    Text("Continuar")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct RatingPage_Previews: PreviewProvider {
    static var previews: some View {
        RatingPage()
    }
}
