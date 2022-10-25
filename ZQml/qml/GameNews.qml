import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ZGui 1.0

Page {
	ListView {
		id: list
		anchors.fill: parent
		model: ZNews
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		delegate: NewsItem {
			anchors.rightMargin: 15
			expanded: index < 5
			showTitle: false
		}
	}
}
