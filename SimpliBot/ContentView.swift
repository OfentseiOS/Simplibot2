//
//  ContentView.swift
//  SimpliBot
//
//  Created by DA MAC M1 137 on 2023/08/10.
//

import SwiftUI

struct ContentView: View {
    @State var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State var messageText: String = ""
    let openAIService = OpenAIService()
    
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
        openAIService.sendMessage(message: messageText).sink(compl: <#T##((Subscribers.Completion<Error>) -> Void)##((Subscribers.Completion<Error>) -> Void)##(Subscribers.Completion<Error>) -> Void#>, receiveValue: <#T##((OpenAIService.OpenAICompletionResponse) -> Void)##((OpenAIService.OpenAICompletionResponse) -> Void)##(OpenAIService.OpenAICompletionResponse) -> Void#>)
        print(messageText)
        // Implement your message sending logic here
        // You can update the chatMessages array with the new message
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
