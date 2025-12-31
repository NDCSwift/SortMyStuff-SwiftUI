//
// Project: SortMyStuff
//  File: HelpMeSortView.swift
//  Created by Noah Carpenter
//  🐱 Follow me on YouTube! 🎥
//  https://www.youtube.com/@NoahDoesCoding97
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
//  Dream Big, Code Bigger

import SwiftUI

struct HelpMeSortView: View {
    @EnvironmentObject var data: DataManager
    @State private var query = ""
    @State private var result: TrashItem?

    // Branding gradient consistent with Main Menu
    private let brandGradient = LinearGradient(
        colors: [Color.green.opacity(0.85), Color.teal.opacity(0.85), Color.blue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    private var filteredItems: [TrashItem] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return [] }
        return data.items.filter { item in
            if item.name.lowercased().contains(q) { return true }
            if item.imageName.lowercased().contains(q) { return true }
            if item.keywords.contains(where: { $0.lowercased().contains(q) }) { return true }
            return false
        }
    }

    var body: some View {
        ZStack {
            // Background
            brandGradient
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Branded Header
                header
                    .padding(.top, 8)
                    .padding(.horizontal)

                // Search Field
                SearchBar(query: $query) {
                    if result == nil { result = filteredItems.first }
                }
                .padding(.horizontal)

                // Content
                if !filteredItems.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                        result = item
                                    }
                                } label: {
                                    ResultRowCard(item: item, categoryName: data.category(for: item).displayName)
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("\(item.name). Category: \(data.category(for: item).displayName)")
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    // Empty state when no query or no matches
                    EmptyStateView(query: query)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }

                // Selected result details
                if let item = result {
                    DetailCard(item: item, categoryName: data.category(for: item).displayName)
                        .padding(.horizontal)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                                removal: .opacity))
                }

                Spacer(minLength: 0)
            }
        }
        .navigationTitle("Help Me Sort")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if data.items.isEmpty { data.loadItems() }
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(.ultraThinMaterial)
                Image(systemName: "questionmark.circle.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white.opacity(0.95), .teal)
                    .font(.system(size: 24, weight: .bold))
            }
            .frame(width: 48, height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)

            VStack(alignment: .leading, spacing: 2) {
                Text("Find the right bin")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text("Search by name or keyword to sort responsibly.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Find the right bin. Search by name or keyword to sort responsibly.")
    }
}

// MARK: - Search Bar
private struct SearchBar: View {
    @Binding var query: String
    var onSubmit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.9))
            TextField("Search items…", text: $query)
                .textFieldStyle(.plain)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .onSubmit { onSubmit() }
                .foregroundStyle(.white)
            if !query.isEmpty {
                Button {
                    withAnimation(.smooth) { query = "" }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search items")
    }
}

// MARK: - Result Row Card
private struct ResultRowCard: View {
    let item: TrashItem
    let categoryName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(.headline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Text(categoryName)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 8)
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .hoverEffect(.highlight)
    }
}

// MARK: - Detail Card
private struct DetailCard: View {
    let item: TrashItem
    let categoryName: String

    var body: some View {
        VStack(spacing: 12) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 8)

            VStack(spacing: 6) {
                Text(item.name)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)
                Text("Category: \(categoryName)")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))
                if let sub = item.subcategory {
                    Text("Subtype: \(sub.rawValue.capitalized)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.thinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 10)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.name). Category: \(categoryName)")
    }
}

// MARK: - Empty State
private struct EmptyStateView: View {
    let query: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: query.isEmpty ? "leaf.circle" : "exclamationmark.magnifyingglass")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.white.opacity(0.95))
                .font(.system(size: 42, weight: .semibold))
                .padding(6)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
                )
            if query.isEmpty {
                Text("Type to search items by name or keyword.")
                    .foregroundStyle(.white.opacity(0.95))
                    .font(.system(.subheadline, design: .rounded))
            } else {
                Text("No results for \"\(query)\".")
                    .foregroundStyle(.white.opacity(0.95))
                    .font(.system(.subheadline, design: .rounded))
            }
        }
        .multilineTextAlignment(.center)
        .padding(.top, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(query.isEmpty ? "Type to search items by name or keyword." : "No results for \(query)")
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        HelpMeSortView()
            .environmentObject(DataManager())
    }
}
