import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ZGui 1.0

Page {
	ListView {
		ScrollBar.vertical: ScrollBar {
			policy: ScrollBar.AlwaysOn
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		anchors.fill: parent
		clip: true
		model: ZQt.logger
		delegate: TextEdit {
			color: 'red'
			font.pixelSize: 15
			readOnly: true
			selectByMouse: true
			text: modelData
		}
	}
}
