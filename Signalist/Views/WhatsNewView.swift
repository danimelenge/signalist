//
//  WhatsNewView.swift
//  Signalist
//
//  Created by Daniel Melenge Rojas on 10/07/26.
//

import SwiftUI

struct WhatsNewView: View {
    let features: [WhatsNewFeature]
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.brandGradient)
                        .frame(width: 72, height: 72)
                        .shadow(color: Theme.gradientEnd.opacity(0.35), radius: 12, y: 4)
                    
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.top, 36)
                
                Text("Novedades en Signalist")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Text("Todo lo que puedes hacer con la nueva versión")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 28)
            
            VStack(alignment: .leading, spacing: 22) {
                ForEach(features) { feature in
                    FeatureRow(feature: feature)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer(minLength: 28)
            
            Button(action: onContinue) {
                Text("Continuar")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
        }
        .frame(width: 460)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

private struct FeatureRow: View {
    let feature: WhatsNewFeature
    
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
            }
        }
    }
}

#Preview {
    WhatsNewView(features: WhatsNewFeature.currentFeatures, onContinue: {})
}

#Preview("Dark") {
    WhatsNewView(features: WhatsNewFeature.currentFeatures, onContinue: {})
        .preferredColorScheme(.dark)
}
