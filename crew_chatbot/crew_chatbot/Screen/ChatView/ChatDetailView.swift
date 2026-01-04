//
//  ChatDetailView.swift
//  crew_chatbot
//
//  Created by Sanju on 04/01/26.
//


import SwiftUI
import PhotosUI

struct ChatDetailView: View {
    private let chat: Chat
    @State private var loadingAnswer: Bool = false
    @State private var text: String = ""
    @StateObject private var viewModel: ChatDetailViewModel
    
    
    @State private var showPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var selectedImages: Image? = nil
    
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    
    init(chat: Chat) {
        self.chat = chat
        let vm = ChatDetailViewModel(chat: chat)
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
                ZStack(alignment: .bottom) {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                MessageView(message: message)
                                    .id(message.id)
                            }
                            
                            if loadingAnswer {
                                TypingMessageView()
                            }
                            Spacer()
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        Divider()
                            .frame(height: 52 + geo.safeAreaInsets.bottom + 16 + imageContainerHeight)
                            .opacity(0)
                            .id("LoadingMessage")
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .defaultScrollAnchor(.top)
                    
                    inputField
                        .padding(.bottom, geo.safeAreaInsets.bottom + 16)
                }
                .ignoresSafeArea(edges: .vertical)
                .onAppear {
                    proxy.scrollTo("LoadingMessage", anchor: .top)
                }
                .onChange(of: viewModel.messages.count) {
                    withAnimation {
                        proxy.scrollTo("LoadingMessage", anchor: .bottom)
                    }
                }
                .onChange(of: loadingAnswer) {
                    withAnimation {
                        proxy.scrollTo("LoadingMessage", anchor: .bottom)
                    }
                }
                .photosPicker(
                    isPresented: $showPhotoPicker,
                    selection: $selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                )
                .onChange(of: selectedPhotoItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            if let uiImage = UIImage(data: data) {
                                selectedImages = Image(uiImage: uiImage)
                            }
                        }
                    }
                }
                .onChange(of: capturedImage) { oldValue, newValue in
                    if let uiImage = newValue {
                        selectedImages = Image(uiImage: uiImage)
                    }
                }
                
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(selectedImage: $capturedImage)
        }
       
    }
    
    private var imageContainerHeight: CGFloat {
        selectedImages == nil ? 0 : 112
    }
    
    private var inputField: some View {
        VStack(spacing: 8) {
            pickedImageView
            HStack(spacing: 6) {
                filePickerMenu
                textFieldView
                sendButton
            }
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private var pickedImageView: some View {
        if let selectedImages {
            HStack {
                selectedImages
                    .resizable()
                    .frame(width: 80, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            self.selectedImages = nil
                            selectedPhotoItem = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.black.opacity(0.5)))
                        }
                        .offset(x: 16 / 2, y: -16 / 2)
                    }
                    .padding(12)
                
                Spacer()
            }
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 24)
        }
    }
    
    private var filePickerMenu: some View {
        Menu {
            Button(action: {
                showPhotoPicker.toggle()
            }, label: {
                Text("Gallery")
                Image(systemName: "photo")
            })
            
            Button(action: {
                showCamera.toggle()
            }, label: {
                Text("Camera")
                Image(systemName: "camera.aperture")
            })
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.green)
                .rotationEffect(.degrees(90), anchor: .center)
                .padding()
        }
        .glassEffect()
    }
    
    private var sendButton: some View {
        Button {
            sendMessage()
        } label: {
            Image(systemName: "location.north.fill")
                .foregroundStyle(.green)
                .rotationEffect(.degrees(90), anchor: .center)
                .padding()
        }
        .glassEffect()
        .disabled(
            !(selectedImages == nil || !text
                .trimmingCharacters(in: .whitespaces).isEmpty)
        )
    }
    
    private var textFieldView: some View {
        TextField("Enter message", text: $text)
            .lineLimit(0)
            .padding(.horizontal)
            .frame(minHeight: 32)
            .multilineTextAlignment(.leading)
            .multilineTextAlignment(
                strategy: .layoutBased
            )
            .frame(maxHeight: 52)
            .glassEffect()
    }
    
    private func sendMessage() {
        guard !text.isEmpty else { return }
        viewModel.add(text)
        text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingAnswer = true
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
//                let newMessage = Messagea(content: "Not able to understand", isCurrentUser: false)
//                messages.append(newMessage)
                self.loadingAnswer = false
            }
        }
    }

}
