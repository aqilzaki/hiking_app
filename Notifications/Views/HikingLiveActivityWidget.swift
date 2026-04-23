import ActivityKit
import WidgetKit
import SwiftUI

struct HikingLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HikingActivityAttributes.self) { context in
            MinimalLockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { EmptyView() }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                EmptyView()
            } minimal: {
                EmptyView()
            }
        }
    }

    struct MinimalLockScreenView: View {
        let context: ActivityViewContext<HikingActivityAttributes>

        var body: some View {
            HStack {
                Image(systemName: context.state.phase.sfSymbol)
                Text("\(Int(context.state.progress * 100))%")
                    .monospacedDigit()
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(8)
        }
    }
}
