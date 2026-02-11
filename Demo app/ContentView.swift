import SwiftUI
import FirebaseFirestore

struct ContentView: View {
    let db = Firestore.firestore()

    @State private var txtFirstName: String = ""
    @State private var txtLastName: String = ""
    @State private var txtPrefName: String = ""
    @State private var txtQuestion: String = ""
    @State private var txtAnswer: String = ""

    @State private var questions: [Question] = []

    var body: some View {
        VStack {
            Spacer()

            Text("Icebreaker")
                .bold()
                .font(.system(size: 40))

            Text("Made By Aravind Ganipisetty")

            Spacer()

            TextField("First Name", text: $txtFirstName)
                .textFieldStyle(.roundedBorder)

            TextField("Last Name", text: $txtLastName)
                .textFieldStyle(.roundedBorder)

            TextField("Preferred Name", text: $txtPrefName)
                .textFieldStyle(.roundedBorder)

            Button(action: {
                setRandomQuestion()
            }) {
                Text("Get a new random question")
                    .font(.system(size: 22))
            }
            .padding(.top, 10)

            Text(txtQuestion)
                .padding(.top, 10)

            TextField("Answer", text: $txtAnswer)
                .textFieldStyle(.roundedBorder)

            Button(action: {
                writeStudentToFirebase()
                resetTxtFields()
            }) {
                Text("Submit")
                    .font(.system(size: 22))
            }
            .padding(30)

            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .onAppear {
            getQuestionsFromFirebase()
        }
    }


    func setRandomQuestion() {
        guard !questions.isEmpty else {
            txtQuestion = "No questions loaded yet"
            return
        }
        txtQuestion = questions.randomElement()!.text
    }

    
    func getQuestionsFromFirebase() {
        questions.removeAll()

        db.collection("question")
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }

                guard let docs = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }

                var loaded: [Question] = []
                for doc in docs {
                    if let q = Question(id: doc.documentID, data: doc.data()) {
                        loaded.append(q)
                    }
                }

                DispatchQueue.main.async {
                    self.questions = loaded
                    print("Loaded questions count: \(self.questions.count)")
                }
            }
    }

    
    func writeStudentToFirebase() {
        // Don’t write empty submissions
        if txtFirstName.isEmpty || txtLastName.isEmpty || txtPrefName.isEmpty || txtQuestion.isEmpty || txtAnswer.isEmpty {
            print("Please fill all fields before submitting.")
            return
        }

        let data: [String: Any] = [
            "first_name": txtFirstName,
            "last_name": txtLastName,
            "pref_name": txtPrefName,
            "question": txtQuestion,
            "answer": txtAnswer,
            "class": "iOS-Spring2026"
        ]

        var ref: DocumentReference? = nil

        ref = db.collection("students")
            .addDocument(data: data) { err in
                if let err = err {
                    print("error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref?.documentID ?? "UNKNOWN")")
                }
            }
    }


    func resetTxtFields() {
        txtFirstName = ""
        txtLastName = ""
        txtPrefName = ""
        txtAnswer = ""
        txtQuestion = ""
    }
}

#Preview {
    ContentView()
}

