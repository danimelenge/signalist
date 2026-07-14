//
//  WhatsNewView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

// MARK: - What's New View

/// Displays the list of new features available in the latest version
/// of the application.
struct WhatsNewView: View {

    // MARK: - Properties

    /// Features displayed in the What's New screen.
    let features: [WhatsNewFeature]

    /// Action executed when the user dismisses the screen.
    let onContinue: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Header

            VStack(spacing: 16) {

                ZStack {
                    Circle()
                        .fill(Theme.brandGradient)
                        .frame(width: 72, height: 72)
                        .shadow(
                            color: Theme.gradientEnd.opacity(0.35),
                            radius: 12,
                            y: 4
                        )

                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 36)

                Text("Novedades en Signalist")
                    .font(.system(size: 26,
                                  weight: .bold,
                                  design: .rounded))

                Text("Todo lo que puedes hacer con la nueva versión")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 28)

            // MARK: Feature List

            VStack(alignment: .leading, spacing: 22) {

                ForEach(features) { feature in
                    FeatureRow(feature: feature)
                }

                // TODO:
                // Support grouped feature categories in future releases.
            }
            .padding(.horizontal, 40)

            Spacer(minLength: 28)

            // MARK: Continue Button

            Button(action: onContinue) {
                Text("Continuar")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 32)

            // NOTE:
            // This screen is shown only the first time after installing
            // or after a major application update.
        }
        .frame(width: 460)
        .background(Color(nsColor: .windowBackgroundColor))

        // FIXME:
        // Make the window width adaptive for different macOS screen sizes.
    }
}

// MARK: - Feature Row

/// Displays a single feature inside the What's New screen.
private struct FeatureRow: View {

    // MARK: - Properties

    let feature: WhatsNewFeature

    // MARK: - Body

    var body: some View {

        HStack(alignment: .top, spacing: 16) {

            Image(systemName: feature.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(feature.iconColor)
                .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 3) {

                Text(feature.title)
                    .font(.system(size: 14, weight: .semibold))

                Text(feature.description)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                // TODO:
                // Support attributed text or markdown descriptions.
            }
        }

        // NOTE:
        // The row automatically adjusts its height based on the
        // description length.
    }
}

// MARK: - Previews

#Preview {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
}

#Preview("Dark") {
    WhatsNewView(
        features: WhatsNewFeature.currentFeatures,
        onContinue: {}
    )
    .preferredColorScheme(.dark)
}
