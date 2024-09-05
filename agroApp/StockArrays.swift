// Productos.swift

import Foundation

public struct Stock {
    static let productos: [String] = ["Seleccionar", "Aguacate", "Cebolla", "Jitomate", "Lechuga", "Limón", "Maíz", "Manzana"]
    
    static let variedades: [String: [String]] = [
        "Aguacate": ["Seleccionar", "Hass", "Fuerte", "Bacon", "Reed"],
        "Cebolla": ["Seleccionar", "Amarilla", "Roja", "Blanca", "Dulce"],
        "Jitomate": ["Seleccionar", "Saladette (Roma)", "Bola", "Cherry", "Tomate de árbol"],
        "Lechuga": ["Seleccionar", "Romana", "Iceberg", "Mantequilla (Boston)", "Escarola"],
        "Limón": ["Seleccionar", "Limón mexicano", "Limón persa", "Limón Meyer", "Limón Eureka"],
        "Maíz": ["Seleccionar", "Maíz amarillo", "Maíz blanco", "Maíz dulce", "Maíz morado"],
        "Manzana": ["Seleccionar", "Golden Delicious", "Red Delicious", "Gala", "Fuji"]
    ]
}

// OtroArchivo.swift

// import Foundation

// class AlgunaClase {
//     func ejemplo() {
//         let aguacates = Stock.variedades["Aguacate"]
//         print(aguacates ?? "No se encontraron aguacates.")
//     }
// }
