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
		langUICombo.currentIndex = ZQt.getModelLangUI().fillUI()
		langUICombo.recalculateWidth()
		langInstallerCombo.currentIndex = ZQt.getModelLangInstaller().fillInstaller()
		langInstallerCombo.recalculateWidth()
		overlayHotkeyCombo.currentIndex = overlayHotkeyCombo.indexOfValue(ZQt.getOverlayHotkey())
		overlayHotkeyCombo.recalculateWidth()
	}
	Column {
		Row {
			spacing: 5
			Label {
				anchors.verticalCenter: parent.verticalCenter
				text: qsTr('ZClient language')
			}
			AutoResizingComboBox {
				id: langUICombo
				model: ZQt.getModelLangUI()
				textRole: 'display'
				valueRole: 'edit'
				onActivated: {
					ZQt.setLangUI(parseInt(currentValue))
					langUIButton.visible = true
				}
			}
			Button {
				id: langUIButton
				height: langUICombo.height
				visible: false
				text: qsTr('Restart')
				onClicked: ZQt.restartClient()
			}
		}
		Row {
			spacing: 5
			Label {
				anchors.verticalCenter: parent.verticalCenter
				text: qsTr('Default installer language')
			}
			AutoResizingComboBox {
				id: langInstallerCombo
				model: ZQt.getModelLangInstaller()
				textRole: 'display'
				valueRole: 'edit'
				onActivated: ZQt.setLangInstaller(parseInt(currentValue))
			}
		}
		Label {
			text: qsTr('Install locations')
		}
		Rectangle {
			width: childrenRect.width
			height: childrenRect.height
			color: "#3B3B3B"
			ListView {
				id: installLocations
				width: 600
				height: 300
				model: ZQt.getInstallLocationsModel()
				clip: true
				currentIndex: -1
				boundsBehavior: Flickable.StopAtBounds
				highlightMoveVelocity: -1
				delegate: Label {
					property string folder: model.display
					anchors.left: parent ? parent.left : undefined
					anchors.right: parent ? parent.right : undefined
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
			spacing: 5
			Button {
				text: qsTr('Add')
				onClicked: folderDialog.open()
			}
			Button {
				text: qsTr('Del')
				enabled: installLocations.currentItem !== null
				onClicked: ZQt.getInstallLocationsModel().del(installLocations.currentItem.folder)
			}
		}
		Row {
			spacing: 5
			Label {
				anchors.verticalCenter: parent.verticalCenter
				text: qsTr('Overlay hotkey')
			}
			AutoResizingComboBox {
				id: overlayHotkeyCombo
				model: ListModel {
					ListElement { text: 'LShift + Tab'; code: 0xA0000009 }
					ListElement { text: 'LShift + ~'; code: 0xA00000C0 }
					ListElement { text: 'LShift + F1'; code: 0xA0000070 }
					ListElement { text: 'LShift + F2'; code: 0xA0000071 }
					ListElement { text: 'LShift + F3'; code: 0xA0000072 }
					ListElement { text: 'LShift + F4'; code: 0xA0000073 }
					ListElement { text: 'LCtrl + Tab'; code: 0xA2000009 }
					ListElement { text: 'LCtrl + ~'; code: 0xA20000C0 }
					ListElement { text: 'LCtrl + F1'; code: 0xA2000070 }
					ListElement { text: 'LCtrl + F2'; code: 0xA2000071 }
					ListElement { text: 'LCtrl + F3'; code: 0xA2000072 }
					ListElement { text: 'LCtrl + F4'; code: 0xA2000073 }
				}
				textRole: 'text'
				valueRole: 'code'
				onActivated: ZQt.setOverlayHotkey(parseInt(currentValue))
			}
		}
	}
	Platform.FolderDialog {
		id: folderDialog
		onAccepted: ZQt.getInstallLocationsModel().add(folder)
	}
}
