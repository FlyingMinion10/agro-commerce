// Productos.swift

import Foundation

public struct Stock {
    // static let productos: [String] = ["Seleccionar", "Aguacate", "Cebolla", "Jitomate", "Lechuga", "Limón", "Maíz", "Manzana"]
    static let productos: [String] = ["Seleccionar", "Aguacate", "Mango", "Plátano", "Papaya", "Piña", "Fresa", "Guayaba", "Lima", 
    "Limón", "Toronja", "Sandía", "Melón", "Manzana", "Pera", "Uva", "Cítricos", "Jitomate", "Tomate verde", "Cebolla", "Chiles", 
    "Zanahoria", "Lechuga", "Espinaca", "Col", "Brócoli", "Coliflor", "Calabacita", "Pepino", "Nopal", "Espárragos", "Apio", "Cilantro", 
    "Berenjena", "Papa", "Camote", "Yuca", "Jícama", "Betabel", "Café", "Cacao"]

    
    // static let variedades: [String: [String]] = [
    //     "Aguacate": ["Seleccionar", "Hass", "Fuerte", "Bacon", "Reed"],
    //     "Cebolla": ["Seleccionar", "Amarilla", "Roja", "Blanca", "Dulce"],
    //     "Jitomate": ["Seleccionar", "Saladette (Roma)", "Bola", "Cherry", "Tomate de árbol"],
    //     "Lechuga": ["Seleccionar", "Romana", "Iceberg", "Mantequilla (Boston)", "Escarola"],
    //     "Limón": ["Seleccionar", "Limón mexicano", "Limón persa", "Limón Meyer", "Limón Eureka"],
    //     "Maíz": ["Seleccionar", "Maíz amarillo", "Maíz blanco", "Maíz dulce", "Maíz morado"],
    //     "Manzana": ["Seleccionar", "Golden Delicious", "Red Delicious", "Gala", "Fuji"]
    // ]

    static let variedades: [String: [String]] = [
    // Frutas
    "Aguacate": ["Seleccionar", "Hass", "Fuerte", "Bacon", "Reed"],
    "Mango": ["Seleccionar", "Ataulfo", "Tommy Atkins", "Kent", "Haden"],
    "Plátano": ["Seleccionar", "Dominico", "Tabasco", "Manzano", "Macho"],
    "Papaya": ["Seleccionar", "Maradol", "Solo", "Red Lady"],
    "Piña": ["Seleccionar", "Cayena Lisa", "Queen", "MD2"],
    "Fresa": ["Seleccionar", "Festival", "Albión", "San Andreas"],
    "Guayaba": ["Seleccionar", "Guayaba criolla", "Guayaba pera"],
    "Lima": ["Seleccionar", "Lima mexicana", "Lima persa"],
    "Limón": ["Seleccionar", "Limón mexicano", "Limón persa", "Limón Eureka"],
    "Toronja": ["Seleccionar", "Roja", "Blanca"],
    "Sandía": ["Seleccionar", "Crimson Sweet", "Charleston Gray", "Sugar Baby"],
    "Melón": ["Seleccionar", "Cantaloupe", "Honeydew", "Galia"],
    "Manzana": ["Seleccionar", "Golden Delicious", "Red Delicious", "Gala", "Fuji"],
    "Pera": ["Seleccionar", "D’Anjou", "Bartlett", "Bosc"],
    "Uva": ["Seleccionar", "Uva roja", "Uva verde", "Uva negra"],
    "Cítricos": ["Seleccionar", "Naranja Valencia", "Naranja Navel", "Mandarina Murcott", "Mandarina Clementina"],
    
    // Verduras y Hortalizas
    "Jitomate": ["Seleccionar", "Saladette (Roma)", "Bola", "Cherry", "Tomate de árbol"],
    "Tomate verde": ["Seleccionar", "Milpero", "Tomate grande"],
    "Cebolla": ["Seleccionar", "Amarilla", "Roja", "Blanca", "Dulce"],
    "Chiles": ["Seleccionar", "Poblano", "Jalapeño", "Serrano", "Habanero"],
    "Zanahoria": ["Seleccionar", "Nantesa", "Chantenay", "Imperator"],
    "Lechuga": ["Seleccionar", "Romana", "Iceberg", "Mantequilla (Boston)", "Escarola"],
    "Espinaca": ["Seleccionar", "Savoy", "Semi-Savoy", "Lisas"],
    "Col": ["Seleccionar", "Verde", "Morada", "Col de Bruselas"],
    "Brócoli": ["Seleccionar", "Brócoli de cabeza", "Brócoli rabe"],
    "Coliflor": ["Seleccionar", "Blanca", "Morada", "Verde", "Romanesco"],
    "Calabacita": ["Seleccionar", "Zucchini", "Grey", "Amarilla"],
    "Pepino": ["Seleccionar", "Pepino persa", "Pepino europeo", "Pepino americano"],
    "Nopal": ["Seleccionar", "Nopal verdura", "Nopal forrajero"],
    "Espárragos": ["Seleccionar", "Verde", "Blanco", "Morado"],
    "Apio": ["Seleccionar", "Apio verde", "Apio blanco"],
    "Cilantro": ["Seleccionar", "Cilantro criollo", "Cilantro vietnamita"],
    "Berenjena": ["Seleccionar", "Berenjena larga", "Berenjena redonda", "Berenjena morada"],

    // Tubérculos y Raíces
    "Papa": ["Seleccionar", "Papa blanca", "Papa roja", "Papa cambray", "Papa morada"],
    "Camote": ["Seleccionar", "Camote naranja", "Camote morado", "Camote blanco"],
    "Yuca": ["Seleccionar", "Yuca amarga", "Yuca dulce"],
    "Jícama": ["Seleccionar", "Jícama criolla", "Jícama agua"],
    "Betabel": ["Seleccionar", "Betabel rojo", "Betabel dorado", "Betabel chioggia"],

    // Otros
    "Café": ["Seleccionar", "Arábica", "Robusta"],
    "Cacao": ["Seleccionar", "Criollo", "Forastero", "Trinitario"]
    ]

    static let transporte: [String] = ["A cargo del productor", "A cargo del bodeguero", "A cargo de AFFIN"]
}

// OtroArchivo.swift

// import Foundation

// class AlgunaClase {
//     func ejemplo() {
//         let aguacates = Stock.variedades["Aguacate"]
//         print(aguacates ?? "No se encontraron aguacates.")
//     }
// }
