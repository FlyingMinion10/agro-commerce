// Productos.swift

import Foundation
import SwiftUICore

public struct Stock {
    // static let productos: [String] = ["Seleccionar", "Aguacate", "Cebolla", "Jitomate", "Lechuga", "Limón", "Maíz", "Manzana"]
    static let productos: [String] = ["Seleccionar", "Aguacate", "Mango", "Plátano", "Papaya", "Piña", "Fresa", "Guayaba", "Lima", 
    "Limón", "Toronja", "Sandía", "Melón", "Manzana", "Pera", "Uva", "Cítricos", "Jitomate", "Tomate verde", "Cebolla", "Chiles", 
    "Zanahoria", "Lechuga", "Espinaca", "Col", "Brócoli", "Coliflor", "Calabacita", "Pepino", "Nopal", "Espárragos", "Apio", "Cilantro", 
    "Berenjena", "Papa", "Camote", "Yuca", "Jícama", "Betabel", "Café", "Cacao"]

    static let variedades: [String: [String]] = [
    // Frutas
    "Aguacate": ["Seleccionar", "Hass", "Fuerte", "Bacon", "Reed"],
    "Mango": ["Seleccionar", "Ataulfo", "Tommy Atkins", "Kent", "Haden"],
    "Plátano": ["Seleccionar", "Dominico", "Tabasco", "Manzano", "Macho"],
    "Papaya": ["Seleccionar", "Maradol", "Solo", "Red Lady"],
    "Piña": ["Seleccionar", "Cayena Lisa", "Queen", "MD2"],
    "Fresa": ["Seleccionar", "Festival", "Albión", "San Andreas"],
    "Guayaba": ["Seleccionar", "Guayaba criolla", "Guayaba pera"],
    "Lima": ["Seleccionar", "Mexicana", "Persa"],
    "Limón": ["Seleccionar", "Mexicano", "Persa", "Eureka"],
    "Toronja": ["Seleccionar", "Roja", "Blanca"],
    "Sandía": ["Seleccionar", "Crimson Sweet", "Charleston Gray", "Sugar Baby"],
    "Melón": ["Seleccionar", "Cantaloupe", "Honeydew", "Galia"],
    "Manzana": ["Seleccionar", "Golden Delicious", "Red Delicious", "Gala", "Fuji"],
    "Pera": ["Seleccionar", "D’Anjou", "Bartlett", "Bosc"],
    "Uva": ["Seleccionar", "Roja", "Verde", "Negra"],
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
    "Brócoli": ["Seleccionar", "De cabeza", "Rabe"],
    "Coliflor": ["Seleccionar", "Blanca", "Morada", "Verde", "Romanesco"],
    "Calabacita": ["Seleccionar", "Zucchini", "Grey", "Amarilla"],
    "Pepino": ["Seleccionar", "Persa", "Europeo", "Americano"],
    "Nopal": ["Seleccionar", "Verdura", "Forrajero"],
    "Espárragos": ["Seleccionar", "Verde", "Blanco", "Morado"],
    "Apio": ["Seleccionar", "Verde", "Blanco"],
    "Cilantro": ["Seleccionar", "Criollo", "Vietnamita"],
    "Berenjena": ["Seleccionar", "Larga", "Redonda", "Morada"],

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

    // MARK: - TAGS
    static let estados: [String] = ["Todas", "Colima", "Jalisco", "Michoacán", "Nayarit"]

    static let calidades: [String] = ["Calidad", "Primera", "Segunda", "Tercera"]

    static let transporte: [String] = ["A cargo del bodeguero", "A cargo de AFFIN"]

    static let colores: [Color] = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.cyan, Color.mint]

    static let videos: [String: String] = [
        "Recolección de Empaque": "https://www.youtube.com/watch?v=nwC9jzTYty4",
        "Báscula 1": "https://www.youtube.com/watch?v=nwC9jzTYty4",
        "Evidencia para Inspección": "https://www.youtube.com/watch?v=nwC9jzTYty4",
        "Báscula 2": "https://www.youtube.com/watch?v=nwC9jzTYty4",
        "Báscula 3": "https://www.youtube.com/watch?v=nwC9jzTYty4"
        ]


}
