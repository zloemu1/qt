import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

Rectangle {
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	height: col1.childrenRect.height < 64 ? 64 : col1.childrenRect.height + 20
	color: "#3B3B3B"
	function updateAch()
	{
		if (display.dateInt)
		{
			datetxt.text = qsTr('Completed at') + ' ' + Qt.formatDateTime(display.date, "dd.MM.yyyy hh:mm:ss")
			icon.opacity = 1
			icon.source = display.icon
			visible = true
		}
		else if (display.gray.length)
			icon.source = display.gray
		else
		{
			icon.opacity = 0.5
			icon.source = display.icon
		}
		if (display.hidden && !display.dateInt)
			datetxt.text = 'Hidden'
	}
	Component.onCompleted: updateAch()
	Connections {
		target: display
		function onSignalUpdateAch()
		{
			updateAch()
		}
	}
	Image {
		id: icon
		anchors.left: parent.left
		anchors.verticalCenter: parent.verticalCenter
		asynchronous: true
		width: 64
		height: 64
	}
	Rectangle {
		color: Material.primary
		anchors.fill: parent
		anchors.leftMargin: 69
		anchors.rightMargin: 5
		anchors.topMargin: 5
		anchors.bottomMargin: 5
		RowLayout {
			anchors.fill: parent
			Column {
				id: col1
				Layout.leftMargin: 5
				Layout.fillWidth: true
				Label {
					id: name
					text: display.name
				}
				Label {
					id: descr
					text: display.descr
					wrapMode: Text.WordWrap
					width: parent.width
					visible: text.length > 0
				}
			}
			Label {
				id: datetxt
				Layout.rightMargin: 5
				visible: text.length > 0
			}
		}
	}
}
