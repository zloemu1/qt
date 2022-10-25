import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Column {
	property alias expanded: contentrect.visible
	property bool showTitle: true
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	bottomPadding: 10
	Component.onCompleted: {
		if (display.game.length && showTitle)
			titletxt.text = "[" + display.game + "] " + display.title
		else
			titletxt.text = display.title
		datetxt.text = "[" + Qt.formatDateTime(new Date(display.date), "dd.MM.yyyy hh:mm:ss") + "]"
	}
	Rectangle {
		anchors.left: parent.left
		anchors.right: parent.right
		color: "#3D3D3D"
		height: 30
		Text {
			id: titletxt
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			leftPadding: 10
			color: Material.color(Material.Grey)
			font.pixelSize: parent.height * 0.6
		}
		Text {
			id: datetxt
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			rightPadding: 10
			color: Material.color(Material.Grey)
			font.pixelSize: parent.height * 0.6
		}
		MouseArea {
			anchors.fill: parent
			onClicked: parent.parent.children[1].visible = !parent.parent.children[1].visible
		}
	}
	Rectangle {
		id: contentrect
		anchors.left: parent.left
		anchors.right: parent.right
		color: "#262626"
		height: childrenRect.height + 10
		Text {
			topPadding: 10
			leftPadding: 20
			color: Material.color(Material.Grey)
			font.pixelSize: 15
			wrapMode: Text.WordWrap
			width: parent.width
			text: display.content
		}
	}
}
