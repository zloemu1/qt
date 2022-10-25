import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import Qt.labs.platform 1.1 as Platform
import ZGui 1.0

Page {
	function pageChange(vis)
	{
		if (!vis)
			return
		gamesDefaultLang.currentIndex = gamesDefaultLang.indexOfValue(ZQt.getLangSelectModel().fillUserLangs())
	}
	Column {
/*
		Text {
			text: 'ZClient lang'
			color: Material.color(Material.Grey)
			font.pixelSize: 13
		}
*/
		Text {
			text: 'Games default lang'
			color: Material.color(Material.Grey)
			font.pixelSize: 13
		}
		ComboBox {
			id: gamesDefaultLang
			model: ZQt.getLangSelectModel()
			textRole: 'display'
			valueRole: 'edit'
			onActivated: ZQt.setDefaultGameLang(parseInt(currentValue))
		}

		Text {
			text: 'Install locations'
			color: Material.color(Material.Grey)
			font.pixelSize: 13
		}
		Rectangle {
			width: 200
			height: 200
			color: "#3B3B3B"
			ListView {
				id: installLocations
				anchors.fill: parent
				model: ZQt.getInstallLocationsModel()
				clip: true
				currentIndex: -1
				boundsBehavior: Flickable.StopAtBounds
				highlightMoveVelocity: -1
				delegate: Text {
					property string folder: model.display
					anchors.left: parent ? parent.left : undefined
					anchors.right: parent ? parent.right : undefined
					color: Material.color(Material.Grey)
					font.pixelSize: 13
					text: model.display + ' ' + ZQt.formattedDataSize(model.edit)
					MouseArea {
						anchors.fill: parent
						onClicked: installLocations.currentIndex = index
					}
				}
				highlight: Rectangle {
					anchors.left: parent ? parent.left : undefined
					anchors.right: parent ? parent.right : undefined
					color: "#232323"
				}
			}
		}
		Row {
			Button {
				text: qsTr("Add")
				onClicked: folderDialog.open()
			}
			Button {
				text: qsTr("Del")
				enabled: installLocations.currentIndex > -1
				onClicked: ZQt.getInstallLocationsModel().del(installLocations.currentItem.folder)
			}
		}
	}
	Platform.FolderDialog {
		id: folderDialog
		onAccepted: ZQt.getInstallLocationsModel().add(folder)
	}
}
