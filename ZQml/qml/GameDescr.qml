import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ZGui 1.0

Page {
	ScrollView {
		id: scrollView
		anchors.fill: parent
		clip: true
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
		ScrollBar.vertical.policy: (scrollView.contentHeight > scrollView.height) ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
		ScrollBar.vertical.implicitWidth: 10
		ScrollBar.vertical.contentItem: Rectangle {
			color: Material.accent
			radius: 5
		}
		Label {
			text: zgame.longDescr
			wrapMode: Text.WordWrap
			width: scrollView.width - 10
		}
	}
}
