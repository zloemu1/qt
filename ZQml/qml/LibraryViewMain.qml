import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1 as Platform
import ZGui 1.0

Page {
	Menu {
		id: gameMenu
		property int zid
		property int zsys
		function show(_id, _sys)
		{
			gameMenu.zid = _id
			gameMenu.zsys = _sys
			popup()
		}
		MenuItem {
			text: qsTr('Install')
			onTriggered: libraryView.show(gameMenu.zid, false, gameMenu.zsys)
		}
		MenuItem {
			text: qsTr('From HDD')
			onTriggered: folderDialog.show(gameMenu.zid, gameMenu.zsys)
		}
	}
	RowLayout {
		id: row
		Text {
			Layout.margins: 10
			color: Material.color(Material.Grey)
			font.pixelSize: 15
			text: 'Filter'
		}
		Rectangle {
			width: 200
			height: childrenRect.height
			color: "#3B3B3B"
			TextInput {
				anchors.left: parent.left
				anchors.right: parent.right
				font.pointSize: 13
				color: "Gray"
				onTextEdited: ZLibrary.filterName(text)
				selectByMouse: true
				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.RightButton
					onDoubleClicked: if (parent.text === '32167') setPage('steamdumper')
				}
			}
		}
	}
	GridView {
		id: grid
		anchors.margins: 5
		anchors.top: row.bottom
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		model: ZLibrary
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: grid.contentHeight > grid.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		property int spacing: 5
		cellWidth: 200 + spacing
		cellHeight: 280 + spacing
		delegate: MouseArea {
				id: ma
				height: grid.cellHeight - grid.spacing
				width: grid.cellWidth - grid.spacing
				acceptedButtons: Qt.LeftButton | Qt.RightButton
				onClicked: if (decoration.owned) gameMenu.show(decoration.id, decoration.sys)
				hoverEnabled: true
				Image {
					id: cover
					anchors.fill: parent
					asynchronous: true
					source: display.cover
					fillMode: Image.PreserveAspectFit
					opacity: ma.containsMouse ? 0.2 : 1
				}
				Label {
					anchors.fill: parent
					text: display.name
					font.bold: true
					font.pixelSize: 15
					wrapMode: Text.WordWrap
					visible: ma.containsMouse
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
				}
		}
	}
	Platform.FolderDialog {
		id: folderDialog
		property int gid
		property int sys
		function show(_gid, _sys)
		{
			gid = _gid
			sys = _sys
			open()
		}
		onAccepted: {
			libraryView.folder = folder
			libraryView.show(gid, true, sys)
		}
	}
}
