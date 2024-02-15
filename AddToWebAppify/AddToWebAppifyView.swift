import SwiftUI

struct AddToWebAppifyView: View {
    @State private var text: String

    init(text: String) {
        self.text = text
    }

    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Text", text: $text, axis: .vertical)
                    .lineLimit(3...6)
                    .textFieldStyle(.roundedBorder)

                Button {
                    // TODO: save text
                    // TODO: close()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Share Extension")
            .toolbar {
                Button("Cancel") {
                    // TODO: close()
                }
            }
        }
    }

    func close() {
        NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
    }
}

#Preview {
    AddToWebAppifyView(text: "preview")
}
