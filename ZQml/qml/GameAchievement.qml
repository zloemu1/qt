import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Rectangle {
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	height: col1.childrenRect.height < 100 ? 100 : col1.childrenRect.height + 20
	color: "#3B3B3B"
	Component.onCompleted: {
		if (display.dateInt)
			datetxt.text = qsTr('Completed at') + ' ' + Qt.formatDateTime(display.date, "dd.MM.yyyy hh:mm:ss")
		else if (!display.hidden)
			icon.opacity = 0.5
	}
	Image {
		id: icon
		anchors.left: parent.left
		anchors.top: parent.top
		asynchronous: true
		width: 100
		height: 100
		source: display.icon
	}
	Rectangle {
		color: Material.primary
		anchors.fill: parent
		anchors.leftMargin: 105
		anchors.rightMargin: 5
		anchors.topMargin: 5
		anchors.bottomMargin: 5
		RowLayout {
			anchors.fill: parent
			Column {
				id: col1
				Layout.leftMargin: 5
				Layout.fillWidth: true
				Text {
					id: name
					text: display.name
					color: Material.color(Material.Grey)
					font.pixelSize: 15
				}
				Text {
					id: descr
					text: display.descr
					color: Material.color(Material.Grey)
					font.pixelSize: 13
					wrapMode: Text.WordWrap
					width: parent.width
					visible: text.length > 0
				}
			}
			Text {
				id: datetxt
				Layout.rightMargin: 5
				color: Material.color(Material.Grey)
				font.pixelSize: 13
			}
		}
	}
}
