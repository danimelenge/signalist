//
//  ContentView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 9/07/26.
//

import SwiftUI

// MARK: - Main View

struct ContentView: View {

    // MARK: - ViewModel

    /// Handles the Morse conversion logic and application state.
    @StateObject private var viewModel = MorseViewModel()

    // MARK: - App Storage

    /// Stores the selected appearance theme.
    @AppStorage("appTheme")
    private var appTheme: AppTheme = .system

    /// Indicates whether the user has already seen the What's New screen.
    @AppStorage("hasSeenWhatsNew")
    private var hasSeenWhatsNew: Bool = false

    // MARK: - View State

    @State private var showWhatsNew: Bool = false

    // MARK: - Environment

    @EnvironmentObject private var helpCenter: HelpCenter
    @Environment(\.colorScheme) private var systemColorScheme

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header
                modePicker
                inputCard
                swapIndicator
                outputCard
                actionButtons
            }
            .padding(28)
        }
        .frame(minWidth: 520, minHeight: 640)
        .background(Color(nsColor: .windowBackgroundColor))
        .preferredColorScheme(appTheme.colorScheme)

        // MARK: Toolbar

        .toolbar {
            ToolbarItem(placement: .navigation) {
                Spacer()
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    showWhatsNew = true
                } label: {
                    Image(systemName: "sparkles")
                }
                .help("Ver novedades")
            }

            ToolbarItem(placement: .primaryAction) {
                themeMenu
            }
        }

        // MARK: Lifecycle

        .onAppear {
            if !hasSeenWhatsNew {
                showWhatsNew = true
            }

            // TODO:
            // Add additional initialization logic if needed in future versions.
        }

        // MARK: Sheet Presentation

        .sheet(isPresented: $showWhatsNew) {
            WhatsNewView(features: WhatsNewFeature.currentFeatures) {
                hasSeenWhatsNew = true
                showWhatsNew = false
            }
        }
        .sheet(isPresented: $helpCenter.isShowingHelp) {
            HelpView()
        }
    }

    // MARK: - Theme Menu

    /// Allows the user to change the application's appearance.
    private var themeMenu: some View {
        Menu {
            ForEach(AppTheme.allCases) { theme in
                Button {
                    withAnimation(.easeInOut) {
                        appTheme = theme
                    }
                } label: {
                    Label(theme.rawValue, systemImage: theme.icon)

                    if appTheme == theme {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: appTheme.icon)
        }
        .help("Apariencia")
    }

    // MARK: - Header

    /// Application logo and title.
    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 56, height: 56)
                    .shadow(
                        color: Theme.gradientEnd.opacity(0.35),
                        radius: 10,
                        y: 4
                    )

                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Signalist")
                .font(.system(size: 28,
                              weight: .bold,
                              design: .rounded))

            Text("Convierte texto a código Morse al instante")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Conversion Mode Picker

    /// Allows switching between Text → Morse and Morse → Text.
    private var modePicker: some View {
        Picker("Modo", selection: $viewModel.mode.animation(.snappy)) {
            ForEach(ConversionMode.allCases) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }

    // MARK: - Input Card

    /// User input area.
    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Label(
                viewModel.mode == .textToMorse ?
                "Texto de entrada" :
                "Código Morse de entrada",
                systemImage: "text.cursor"
            )
            .font(.headline)
            .foregroundStyle(.primary)

            TextEditor(text: $viewModel.inputText)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .frame(height: 110)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(nsColor: .textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            Color.primary.opacity(0.08),
                            lineWidth: 1
                        )
                )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Swap Indicator

    /// Decorative arrow indicating conversion direction.
    private var swapIndicator: some View {
        Image(systemName: "arrow.down")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(Color.primary.opacity(0.06))
            )
    }

    // MARK: - Output Card

    /// Displays the converted result.
    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Label {
                    Text("Resultado")
                        .font(.headline)
                } icon: {

                    Image(systemName:
                            viewModel.outputText.isEmpty
                          ? "circle"
                          : "checkmark.circle.fill")

                        .font(.headline)
                        .foregroundStyle(
                            viewModel.outputText.isEmpty
                            ? Color.secondary
                            : Color.green
                        )
                        .scaleEffect(
                            viewModel.outputText.isEmpty ? 1.0 : 1.15
                        )
                        .animation(
                            .spring(response: 0.35,
                                    dampingFraction: 0.5),
                            value: viewModel.outputText.isEmpty
                        )
                }

                Spacer()

                if !viewModel.outputText.isEmpty {
                    Text("\(viewModel.outputText.count) caracteres")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }

            ScrollView {
                Text(
                    viewModel.outputText.isEmpty
                    ? "Aquí aparecerá el resultado..."
                    : viewModel.outputText
                )
                .font(.system(.body, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(
                    viewModel.outputText.isEmpty
                    ? .tertiary
                    : .primary
                )
                .textSelection(.enabled)
                .padding(12)
            }
            .frame(height: 110)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        Color.primary.opacity(0.08),
                        lineWidth: 1
                    )
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: viewModel.outputText
            )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Action Buttons

    /// Copy and clear actions.
    private var actionButtons: some View {
        HStack(spacing: 12) {

            Button {
                viewModel.copyOutputToClipboard()

                // NOTE:
                // Consider showing a confirmation toast after copying.
            } label: {
                Label("Copiar resultado",
                      systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.outputText.isEmpty)

            Button(role: .destructive) {
                withAnimation(.snappy) {
                    viewModel.clearAll()
                }

                // FIXME:
                // Ask for confirmation before deleting if future versions
                // include persistent history.
            } label: {
                Label("Limpiar",
                      systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    // MARK: - Shared Styles

    /// Shared card appearance used across the interface.
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.regularMaterial)
            .shadow(
                color: .black.opacity(0.06),
                radius: 8,
                y: 2
            )
    }
}

// MARK: - Previews

#Preview {
    ContentView()
        .environmentObject(HelpCenter())
}

#Preview("Dark") {
    ContentView()
        .environmentObject(HelpCenter())
        .preferredColorScheme(.dark)
}
