//
// Project: SortMyStuff
//  File: SettingsView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var data: DataManager
    @AppStorage("selectedRegionName") private var selectedRegionName: String = ""

    // Branding gradient
    private let brandGradient = LinearGradient(
        colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85), Color.blue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            brandGradient
                .ignoresSafeArea()

            List {
                Section {
                    header
                        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                }

                Section(header: Text("Region").foregroundStyle(.white.opacity(0.9))) {
                    ForEach(data.regions) { region in
                        Button {
                            selectedRegionName = region.regionName
                            data.selectedRegion = region
                        } label: {
                            HStack {
                                Text(region.regionName)
                                    .foregroundStyle(.white)
                                Spacer()
                                if selectedRegionName == region.regionName {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                        .accessibilityHidden(true)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(region.regionName)\(selectedRegionName == region.regionName ? ", selected" : "")")
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if data.regions.isEmpty { data.loadRegions() }
            // Restore selected region object if persisted name exists
            if data.selectedRegion == nil,
               !selectedRegionName.isEmpty,
               let match = data.regions.first(where: { $0.regionName == selectedRegionName }) {
                data.selectedRegion = match
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
                Image(systemName: "globe.americas.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white.opacity(0.95), .teal)
                    .font(.system(size: 26, weight: .bold))
            }
            .frame(width: 52, height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text("Choose your region")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text("We’ll tailor sorting rules to your area.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Choose your region. We’ll tailor sorting rules to your area.")
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(DataManager())
    }
}
