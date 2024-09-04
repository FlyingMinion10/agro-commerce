import SwiftUI
import Combine

struct Publication: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var image: URL?
    var tags: [Tag]
}

struct Tag: Identifiable, Codable {
    var id = UUID()
    var name: String
}

class PublicationViewModel: ObservableObject {
    @Published var publications: [Publication] = []
    @Published var filteredPublications: [Publication] = []
    @Published var selectedTags: [Tag] = []
    @Published var isFilterViewPresented = false

    init() {
        // Dummy data
        publications = [
            Publication(title: "Publication 1", description: "Description 1", image: nil, tags: [Tag(name: "Tag 1"), Tag(name: "Tag 2")]),
            Publication(title: "Publication 2", description: "Description 2", image: nil, tags: [Tag(name: "Tag 2"), Tag(name: "Tag 3")]),
            Publication(title: "Publication 3", description: "Description 3", image: nil, tags: [Tag(name: "Tag 1"), Tag(name: "Tag 3")]),
            // ...
        ]
        filteredPublications = publications
    }

    func filterPublications(by tags: [Tag]) {
        filteredPublications = publications.filter { publication in
            publication.tags.contains(where: { tag in tags.contains(where: { $0.name == tag.name }) })
        }
    }
}

struct CanvasView: View {
    @StateObject var viewModel = PublicationViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.filteredPublications) { publication in
                VStack(alignment: .leading) {
                    Text(publication.title)
                    Text(publication.description)
                }
            }
            .navigationTitle("Publications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filter") {
                        // Mostrar la vista de selección de tags
                    }
                }
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView()
    }
}
