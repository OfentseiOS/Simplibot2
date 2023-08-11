//
//  ContentView.swift
//  SimpliBot
//
//  Created by DA MAC M1 137 on 2023/08/10.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
   
    
    let openAIService = OpenAIService()
    @State var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in
                        messageView(message: message)
                    }
                }
            }
            
            messageInputView() // Add the input view here
        }
    }
    
    func messageView(message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? Color.blue : Color.gray.opacity(0.1))
                .cornerRadius(16)
                
            if message.sender == .SimpliBot { Spacer() }
        }
    }
    
    func messageInputView() -> some View { // Renamed the function
        HStack {
            TextField("Enter a message", text: $messageText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            Button(action: {
                messageText = ""
                sendMessage()
            }) {
                Text("Send")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
            }
        }
        .padding()
        .onAppear {
            openAIService.sendMessage(message: "Generate a tagline for a banking app")
        }
        // Add padding to the whole HStack
    }
    
    func sendMessage() {
        let myMessage = ChatMessage(id: UUID().uuidString, content:
            messageText, dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        
        openAIService.sendMessage(message: messageText).sink { completion in
            //Handle error
        } receiveValue: { response in
            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {
                return

            }
            let SimpliBotMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .SimpliBot)
            chatMessages.append(SimpliBotMessage)
        }
        .store(in: &cancellables)
        
        messageText = ""
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

enum MessageSender {
    case me
    case SimpliBot
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Hello", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Hi, I am SimpliBot. How can I assist?", dateCreated: Date(), sender: .SimpliBot),
        ChatMessage(id: UUID().uuidString, content: "How can I save money?", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample message from SimpliBot", dateCreated: Date(), sender: .SimpliBot)
    ]
}
