import SwiftUI

struct ContentView: View {
    @ObservedObject var settings = Settings.instance
    @ObservedObject var transcriber = SpeechCore()
    @State private var result = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text(transcriber.transcribedText)
                    .font(.system(size: settings.fontSize))
                    .frame(maxWidth: .infinity, alignment: .leading).environment(\.layoutDirection, settings.layoutDirection)
                    .truncationMode(.middle)
            }
            Text(transcriber.error ?? "").font(.system(size: 25)).foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            HStack {
                FontToolbar().padding()
                Spacer()
                if transcriber.isRunning {
                    HStack {
                        Button(action: { transcriber.restart() }, label: {
                            Image(systemName: "clear.fill").foregroundColor(.yellow)
                        })
                        .padding()
                        Button(action: { transcriber.tryStop() }, label: {
                            Image(systemName: "stop.fill").foregroundColor(.red)
                        })
                        .padding()
                        Spacer()
                        if #available(iOS 14.0, *) {
                            ProgressView()
                        }
                        else {
                            ProgressViewPolyfill()
                        }
                    }
                } else {
                    Button(action: { transcriber.restart() }, label: {
                        Image(systemName: "mic.fill")
                    })
                    .padding()
                }
                Spacer()
                LanguageMenu(notifyLanguageChanged: {
                    if !self.transcriber.isRunning { return }
                    self.transcriber.restart()
                }).padding()
            }
        }
    }
}
