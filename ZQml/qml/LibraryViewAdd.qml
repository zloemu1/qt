import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

ColumnLayout {
	spacing: 0
	Connections {
		target: ZDownloadInfo
		function onSignalGCInfoGot(from, game, files, downloadSize, hddSize, info, infoTotal) {
			if (from != 0)
				return
			popupBusy.text(info + '/' + infoTotal)
		}
		function onSignalGCInfoError(from, game, stage) {
			if (from != 0)
				return
			popupBusy.close()
			popupError.show('Info error stage ' + stage + ' game ' + ZGames.getName(game))
		}
		function onSignalGCInfoDone(from, infoTotal, totalFiles, totalDownloadSize, totalHddSize) {
			if (from != 0)
				return
			libraryView.currentIndex = 1
			popupBusy.close()
			textTotalFiles.visible = infoTotal > 1
			textTotalDownloadSize.visible = infoTotal > 1
			textTotalHddSize.visible = infoTotal > 1
			textTotalFiles.text = qsTr('Total files') + ': ' + totalFiles
			textTotalDownloadSize.text = qsTr('Total download size') + ': ' + totalDownloadSize
			textTotalHddSize.text = qsTr('Total hdd size') + ': ' + totalHddSize
			if (libraryView.fromHdd)
				textFreeHdd.text = qsTr('Free hdd space') + ': ' + ZQt.getFreeSpaceStr(libraryView.folder)
			else
			{
				installFolderCombo.currentIndex = installFolderCombo.indexOfValue(ZQt.getInstallLocationsModel().getLast())
				installFolderCombo.recalculateWidth()
				textFreeHdd.text = qsTr('Free hdd space') + ': ' + ZQt.getFreeSpaceStr(installFolderCombo.currentText)
			}
		}
		function onSignalGCInfoRecalc(totalFiles, totalDownloadSize, totalHddSize)
		{
			textTotalFiles.text = qsTr('Total files') + ': ' + totalFiles
			textTotalDownloadSize.text = qsTr('Total download size') + ': ' + totalDownloadSize
			textTotalHddSize.text = qsTr('Total hdd size') + ': ' + totalHddSize
		}
	}
	RowLayout {
		Layout.alignment: Qt.AlignHCenter
		Label {
			text: qsTr('Install location')
		}
		AutoResizingComboBox {
			id: installFolderCombo
			model: ZQt.getInstallLocationsModel()
			textRole: 'display'
			valueRole: 'display'
			visible: !libraryView.fromHdd
			onActivated: textFreeHdd.text = qsTr('Free hdd space') + ': ' + ZQt.getFreeSpaceStr(installFolderCombo.currentText)
		}
		Label {
			id: installFolderHDD
			text: libraryView.folder
			visible: libraryView.fromHdd
		}
	}
	Label {
		id: textFreeHdd
		Layout.alignment: Qt.AlignHCenter
	}
	Row {
		Layout.alignment: Qt.AlignHCenter
		CheckBox {
			id: autoUpdate
			checked: true
			text: 'Auto update'
		}
		CheckBox {
			id: autoDlc
			checked: true
			text: 'Auto install new DLC'
		}
	}
	ListView {
		id: infolist
		clip: true
		Layout.fillWidth: true
		Layout.fillHeight: true
		model: ZDownloadInfo
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: infolist.contentHeight > infolist.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		highlightMoveVelocity: -1
		spacing: 3
		delegate: Rectangle {
			anchors.left: parent ? parent.left : undefined
			anchors.right: parent ? parent.right : undefined
			anchors.rightMargin: infolist.contentHeight > infolist.height ? 15 : 0
			height: childrenRect.height
			color: "#3D3D3D"
			RowLayout {
				anchors.left: parent.left
				anchors.right: parent.right
				Column {
					Layout.fillWidth: true
					Label {
						text: display.name
						width: parent.width
						wrapMode: Text.WordWrap
					}
					Row {
						spacing: 20
						Label {
							text: qsTr('Files') + ': ' + display.files
						}
						Label {
							text: qsTr('Download size') + ': ' + display.downloadSize
						}
						Label {
							text: qsTr('Hdd size') + ': ' + display.hddSize
						}
					}
				}
				CheckBox {
					Layout.alignment: Qt.AlignRight
					checked: decoration.checked
					text: qsTr('Download')
					onCheckedChanged: {
						if (decoration.checked === checked)
							return
						decoration.checked = checked
						ZDownloadInfo.recalc(decoration.id, checked)
					}
					visible: infolist.count > 1
				}
			}
		}
	}
	Label {
		id: textTotalFiles
	}
	Label {
		id: textTotalDownloadSize
	}
	Label {
		id: textTotalHddSize
	}
	RowLayout {
		spacing: 5
		Layout.alignment: Qt.AlignHCenter
		Button {
			text: qsTr('Cancel')
			onClicked: {
				ZGames.addCancel()
				libraryView.currentIndex = 0
			}
		}
		Button {
			text: qsTr('Next')
			focus: true
			onClicked: {
				if (!libraryView.fromHdd)
					libraryView.folder = installFolderCombo.currentText
				libraryView.currentIndex = 0
				var res = ZGames.add(libraryView.folder, libraryView.fromHdd, autoUpdate.checked, autoDlc.checked)
				if (res !== 0)
					popupError.show('Add failed ' + res)
				else
					setPage('downloads')
			}
		}
	}
}
