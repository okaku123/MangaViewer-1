//
//  PreviewContextMenu.swift
//  MangaViewer
//
//  Created by vgoyun on 2021/5/28.
//

import SwiftUI

struct PreviewContextMenu_ContentView  : View {
    var body: some View {
        NavigationView {
            Text("Hello, World!")
                .contextMenu(PreviewContextMenu(destination: Text("Destination"), actionProvider: { items in
                    return UIMenu(title: "My Menu", children: items)
                }))
        }
    }
}

struct PreviewContextMenu_ContentView2 : View {

let deleteAction = UIAction(
title: "Remove rating",
image: UIImage(systemName: "delete.left"),
identifier: nil,
    attributes: UIMenuElement.Attributes.destructive, handler: {_ in print("Foo")})

var body: some View {
    NavigationView {
        Text("Hello, World!")
            .contextMenu(PreviewContextMenu(destination: Text("Destination"), actionProvider: { items in
                return UIMenu(title: "My Menu", children: [deleteAction])
            }))
    }
}}



struct PreviewContextMenu_ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        PreviewContextMenu_ContentView()
        PreviewContextMenu_ContentView2()
    }
}



// MARK: - Custom Menu Context Implementation
struct PreviewContextMenu<Content: View> {
    let destination: Content
    let actionProvider: UIContextMenuActionProvider?
    
    init(destination: Content, actionProvider: UIContextMenuActionProvider? = nil) {
        self.destination = destination
        self.actionProvider = actionProvider
    }
}

// UIView wrapper with UIContextMenuInteraction
struct PreviewContextView<Content: View>: UIViewRepresentable {
    
    let menu: PreviewContextMenu<Content>
    let didCommitView: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let menuInteraction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(menuInteraction)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(menu: self.menu, didCommitView: self.didCommitView)
    }
    
    class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        
        let menu: PreviewContextMenu<Content>
        let didCommitView: () -> Void
        
        init(menu: PreviewContextMenu<Content>, didCommitView: @escaping () -> Void) {
            self.menu = menu
            self.didCommitView = didCommitView
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: { () -> UIViewController? in
                UIHostingController(rootView: self.menu.destination)
            }, actionProvider: self.menu.actionProvider)
        }
        
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            animator.addCompletion(self.didCommitView)
        }
        
    }
}

// Add context menu modifier
extension View {
    func contextMenu<Content: View>(_ menu: PreviewContextMenu<Content>) -> some View {
        self.modifier(PreviewContextViewModifier(menu: menu))
    }
}

struct PreviewContextViewModifier<V: View>: ViewModifier {
    
    let menu: PreviewContextMenu<V>
    @Environment(\.presentationMode) var mode
    
    @State var isActive: Bool = false
    
    func body(content: Content) -> some View {
        Group {
            if isActive {
                menu.destination
            } else {
                content.overlay(PreviewContextView(menu: menu, didCommitView: { self.isActive = true }))
            }
        }
    }
}
