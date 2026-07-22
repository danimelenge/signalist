//
//  BrailleView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 22/07/26.
//

import SwiftUI

struct BrailleView: View {
    @StateObject private var viewModel = BrailleViewModel()
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

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
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Theme.brandGradient)
                    .frame(width: 56, height: 56)
                    .shadow(color: Theme.gradientEnd.opacity(0.35), radius: 10, y: 4)

                Image(systemName: "hand.point.up.braille.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Text("Braille")
                .font(.system(size: 28, weight: .bold, design: .rounded))

            Text("Convierte texto a Braille Unicode al instante")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    // MARK: - Mode Picker

    private var modePicker: some View {
        Picker("Modo", selection: $viewModel.mode.animation(.snappy)) {
            ForEach(BrailleConversionMode.allCases) { option in
                Text(option.rawValue)
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 360)
    }

    // MARK: - Input Card

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(
                viewModel.mode == .textToBraille ? "Texto de entrada" : "Braille de entrada",
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
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                )
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Swap Indicator

    private var swapIndicator: some View {
        Image(systemName: "arrow.down")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(width: 32, height: 32)
            .background(Circle().fill(Color.primary.opacity(0.06)))
    }

    // MARK: - Output Card

    private var outputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label {
                    Text("Resultado")
                        .font(.headline)
                } icon: {
                    Image(systemName: viewModel.outputText.isEmpty ? "circle" : "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(viewModel.outputText.isEmpty ? Color.secondary : Color.green)
                        .scaleEffect(viewModel.outputText.isEmpty ? 1.0 : 1.15)
                        .animation(.spring(response: 0.35, dampingFraction: 0.5), value: viewModel.outputText.isEmpty)
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
                Text(viewModel.outputText.isEmpty ? "Aquí aparecerá el resultado..." : viewModel.outputText)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(viewModel.outputText.isEmpty ? .tertiary : .primary)
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
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.outputText)
        }
        .padding(16)
        .background(cardBackground)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                viewModel.copyOutputToClipboard()
            } label: {
                Label("Copiar resultado", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.outputText.isEmpty)

            Button(role: .destructive) {
                withAnimation(.snappy) {
                    viewModel.clearAll()
                }
            } label: {
                Label("Limpiar", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    // MARK: - Shared Styles

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.regularMaterial)
            .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}

#Preview {
    BrailleView()
}

#Preview("Dark") {
    BrailleView()
        .preferredColorScheme(.dark)
}
