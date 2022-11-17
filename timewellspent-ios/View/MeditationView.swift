//
//  MeditationView.swift
//  timewellspent-ios
//
//  Created by Adam Novak on 2022/11/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore

struct MeditationView: View {
    
    @State var isBreathing: Bool = false
    @State var breatheIn: Bool = false
    @Environment(\.meditation) var isMeditating
    
    let breatheTimeInSeconds: UInt64 = 4
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Mindberry")
            Spacer()
            Text(isBreathing ? (breatheIn ? "Breathe in" : "Breathe out") : "Right now I'm feeling...")
            VStack(spacing: 30) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(1..<6, id: \.self) { id in
                        Button {
                            handleButtonPress(id)
                        } label: {
                            Image("face" + String(id))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                        }
                    }
                }
            }
            .isHidden(isBreathing, remove: true)
            Circle()
                .frame(width: UIScreen.main.bounds.width / 1.5, alignment: .center)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 0)
                .isHidden(!isBreathing, remove: true)
                .scaleEffect(breatheIn ? 0.9 : 0.5)
                .animation(.easeInOut(duration: Double(breatheTimeInSeconds) - 0.3), value: breatheIn)
            Spacer()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .background(.tint)
        .foregroundColor(.white)
        .font(.title2)
        .fontWeight(.bold)
    }
    
    func postToFirebase() {
//        FirebaseApp.configure()
//        let db = Firestore.firestore()
//        let currentSession = Session(beforeRating: 1, afterRating: 4, timestamp: Date())
//        db.collection("session").document(UUID().uuidString).setData(currentSession.dictionary)
    }
    
    func handleButtonPress(_ index: Int) {
        postToFirebase()
        //do something with the index
        Task {
            await startMeditation()
        }
    }
    
    func startMeditation() async {
        isBreathing = true
        do {
            try await Task.sleep(nanoseconds: 10)
            for _ in 0..<10 {
                breatheIn = !breatheIn
                try await Task.sleep(nanoseconds: breatheTimeInSeconds * NSEC_PER_SEC)
            }
            MyManagedSettings.shared.pauseUntilNextHour()
            isMeditating.wrappedValue.toggle()
        } catch {
            print("lmfao")
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MeditationView()
            MeditationView()
        }
    }
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}

public struct Session: Codable {
    let beforeRating: Int
    let afterRating: Int
    let timestamp: Date
}
