//
//  HorizontalWeekCalendar.swift
//  Hyperdrive
//
//  Created by Alvin Ta on 2025-08-20.
//

import SwiftUI

/// Horizontal week calendar with a selected date binding.
struct HorizontalWeekCalendar: View {
    @Binding private var selectedDate: Date
    @State private var anchorDate: Date
    private var firstWeekday: Int

    init(selectedDate: Binding<Date>, firstWeekday: Int = 1) {
        self._selectedDate = selectedDate
        self._anchorDate = State(initialValue: selectedDate.wrappedValue)
        self.firstWeekday = firstWeekday
    }

    // MARK: Calendar helpers
    private var cal: Calendar {
        var c = Calendar.current
        c.firstWeekday = firstWeekday   // 1=Sun, 2=Mon
        return c
    }

    private var weekDates: [Date] {
        let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: anchorDate))!
        return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: start) }
    }

    // MARK: Body
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                NavButton(systemName: "chevron.left") {
                    anchorDate = cal.date(byAdding: .weekOfYear, value: -1, to: anchorDate)!
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(weekDates, id: \.self) { day in
                            DayCell(
                                date: day,
                                isSelected: cal.isDate(day, inSameDayAs: selectedDate),
                                cal: cal
                            )
                            .onTapGesture {
                                selectedDate = day
                                anchorDate = day
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 64)
                }

                NavButton(systemName: "chevron.right") {
                    anchorDate = cal.date(byAdding: .weekOfYear, value: 1, to: anchorDate)!
                }
            }

            Text(selectedDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Subviews

private struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let cal: Calendar

    var body: some View {
        let dayNum = cal.component(.day, from: date)
        let label = Color(uiColor: .label)                 // dynamic: black ↔︎ white
        let bg    = Color(uiColor: .systemBackground)      // dynamic: white ↔︎ black

        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.weekday(.narrow))) // S, M, T, …
                .font(.caption2)
                .foregroundStyle(.secondary)

            ZStack {
                if isSelected {
                    Circle()
                        .fill(label)
                        .frame(width: 32, height: 32)
                    Text("\(dayNum)")
                        .font(.headline)
                        .foregroundStyle(bg)               // contrasts with circle
                } else {
                    Text("\(dayNum)")
                        .font(.headline)
                        .foregroundStyle(label)
                }
            }
        }
        .frame(width: 44)
        .contentShape(Rectangle())
        .accessibilityLabel(date.formatted(date: .complete, time: .omitted))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct NavButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.headline)
                .foregroundStyle(Color(uiColor: .label))   // dynamic chevron color
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Option A Preview

private struct CalendarPreviewHost: View {
    @State var selected = Date()
    var body: some View {
        HorizontalWeekCalendar(selectedDate: $selected, firstWeekday: 1)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

//#Preview("HorizontalWeekCalendar (Light)") {
//    CalendarPreviewHost()
//}

#Preview("HorizontalWeekCalendar (Dark)") {
    CalendarPreviewHost().preferredColorScheme(.dark)
}
