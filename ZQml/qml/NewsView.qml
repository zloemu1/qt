import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	function pageChange(vis) {
		if (vis)
			ZNews.filter(0)
	}
	ListView {
		id: list
		anchors.leftMargin: 10
		anchors.topMargin: 10
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
			anchors.rightMargin: list.contentHeight > list.height ? 15 : 10
			expanded: index < 5
		}
	}
}
