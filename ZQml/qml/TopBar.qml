import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ZGui 1.0

ToolBar {
	property alias currentIndex : tab.currentIndex
	property alias statusOwnText: statusTextTop.text
	Material.foreground: Material.Grey
	Menu {
		id: statusMenu
		width: 100
		property int tstatus
		MenuItem {
			text: qsTr('Online')
			onClicked: ZUser.status = 1;
			enabled: statusMenu.tstatus !== 1
		}
		MenuItem {
			text: qsTr('Away')
			onClicked: ZUser.status = 2;
			enabled: statusMenu.tstatus !== 2
		}
		MenuItem {
			text: qsTr('DND')
			onClicked: ZUser.status = 3;
			enabled: statusMenu.tstatus !== 3
		}
		MenuItem {
			text: qsTr('Invisible')
			onClicked: ZUser.status = 0;
			enabled: statusMenu.tstatus !== 0
		}
	}
	RowLayout {
		anchors.fill: parent
		spacing: 5
/*
		Rectangle {
			Layout.leftMargin: 10
			Layout.rightMargin: 15
			Layout.preferredHeight: parent.height * 0.6
			Layout.preferredWidth: height
			radius: 5
			color: "#333331"
			Text {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
				text: "Z"
				color: "#DE504F"
				font.pixelSize: parent.height * 0.9
				font.bold: true
			}
		}
*/
		TabBar {
			id: tab
			Layout.topMargin: 10
			Layout.bottomMargin: 10
			font.pointSize: 13
			font.family: rootWindow.font.name
			TabButton {
				onClicked: setPage('news')
				text: qsTr('News')
				width: implicitWidth
			}
			TabButton {
				onClicked: setPage('games')
				text: qsTr('My Games')
				width: implicitWidth
			}
			TabButton {
				onClicked: setPage('downloads')
				text: qsTr('Downloads')
				width: implicitWidth
				Rectangle {
					visible: ZGames.getDownloadModel().downloadCount > 0
					anchors.horizontalCenter: parent.contentItem.right
					anchors.verticalCenter: parent.contentItem.top
					color: Material.accent
					radius: 8
					width: childrenRect.width + 4
					height: childrenRect.height
					Text {
						anchors.left: parent.left
						anchors.leftMargin: 2
						text: ZGames.getDownloadModel().downloadCount
						font.bold: true
						font.pixelSize: 11
						color: Material.foreground
					}
				}
			}
			TabButton {
				onClicked: setPage('library')
				text: qsTr('Library')
				width: implicitWidth
			}
			TabButton {
				onClicked: setPage('community')
				text: 'Community'
				width: implicitWidth
			}
			TabButton {
				onClicked: setPage('settings')
				text: qsTr('Settings')
				width: implicitWidth
			}
			TabButton {
				onClicked: setPage('log')
				text: 'Log'
				width: implicitWidth
				Rectangle {
					visible: ZQt.logger.length > 0
					anchors.horizontalCenter: parent.contentItem.right
					anchors.verticalCenter: parent.contentItem.top
					color: Material.accent
					radius: 8
					width: childrenRect.width + 4
					height: childrenRect.height
					Text {
						anchors.left: parent.left
						anchors.leftMargin: 2
						text: ZQt.logger.length
						font.bold: true
						font.pixelSize: 11
						color: Material.foreground
					}
				}
			}
		}
		Item {
			Layout.fillWidth: true
		}
		Button {
			text: "\ue7ef"
			font.family: "Material Icons"
			font.pointSize: 15
			Layout.preferredWidth: height
			onClicked: {
				friendsWindow.show()
				friendsWindow.requestActivate()
			}
		}
		Button {
			text: "\ue0be"
			font.family: "Material Icons"
			font.pointSize: 15
			Layout.preferredWidth: height
			onClicked: {
				chatsWindow.show()
				chatsWindow.requestActivate()
			}
			Rectangle {
				visible: ZChats.unreaded > 0
				anchors.horizontalCenter: parent.contentItem.right
				anchors.verticalCenter: parent.contentItem.top
				color: Material.accent
				radius: 8
				width: childrenRect.width + 4
				height: childrenRect.height
				Text {
					anchors.left: parent.left
					anchors.leftMargin: 2
					text: ZChats.unreaded
					font.bold: true
					font.pixelSize: 11
					color: Material.foreground
				}
			}
		}
/*
		Button {
			text: "\ue7f4" //notification
			font.family: "Material Icons"
			font.pointSize: 15
			Layout.preferredWidth: height
			Rectangle {
				visible: true
				anchors.horizontalCenter: parent.contentItem.right
				anchors.verticalCenter: parent.contentItem.top
				color: Material.accent
				radius: width*0.5
				width: 15
				height: 15
				Text {
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter
					text: "5"
					font.bold: true
					font.pixelSize: parent.width * 0.7
					color: Material.foreground
				}
			}
		}
*/
		Image {
			source: "image://ZAvatar/" + ZUser.id
			Layout.preferredWidth: height
			Layout.maximumHeight: 40
			Layout.maximumWidth: 40
		}

		ColumnLayout {
			Layout.rightMargin: 15
			Text {
				text: ZUser.name
				font.pointSize: 13
				color: Material.color(Material.Grey)
			}
			RowLayout {
				Text {
					id: statusTextTop
					text: onlineStatusStr(ZUser.status, true)
					color: Material.color(Material.Grey)
				}
				Text {
					color: '#ACACAC'
					font.family: "Material Icons"
					text: '\ue313'
					MouseArea {
						anchors.fill: parent
						onClicked: {
							statusMenu.tstatus = ZUser.status
							statusMenu.popup()
						}
					}
				}
			}
		}
	}
}
