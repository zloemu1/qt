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
			if (from != 1)
				return
			popupBusy.text(info + '/' + infoTotal)
		}
		function onSignalGCInfoError(from, game, stage) {
			if (from != 1)
				return
			popupBusy.close()
			popupError.show('Info error stage ' + stage + ' game ' + ZGames.getName(game))
		}
		function onSignalGCInfoDone(from, infoTotal, totalFiles, totalDownloadSize, totalHddSize) {
			if (from != 1)
				return
			gameContentView.currentIndex = 1
			popupBusy.close()
			textTotalFiles.visible = infoTotal > 1
			textTotalDownloadSize.visible = infoTotal > 1
			textTotalHddSize.visible = infoTotal > 1
			textTotalFiles.text = 'Total files: ' + totalFiles
			textTotalDownloadSize.text = 'Total download size: ' + ZQt.formattedDataSize(totalDownloadSize)
			textTotalHddSize.text = 'Total hdd size: ' + ZQt.formattedDataSize(totalHddSize)
		}
		function onSignalGCInfoRecalc(totalFiles, totalDownloadSize, totalHddSize)
		{
			textTotalFiles.text = 'Total files: ' + totalFiles
			textTotalDownloadSize.text = 'Total download size: ' + ZQt.formattedDataSize(totalDownloadSize)
			textTotalHddSize.text = 'Total hdd size: ' + ZQt.formattedDataSize(totalHddSize)
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
						font.pointSize: 13
						width: parent.width
						wrapMode: Text.WordWrap
					}
					Row {
						spacing: 20
						Label {
							text: 'Files: ' + display.files
							font.pointSize: 13
						}
						Label {
							text: 'Download size: ' + ZQt.formattedDataSize(display.downloadSize)
							font.pointSize: 13
						}
						Label {
							text: 'Hdd size: ' + ZQt.formattedDataSize(display.hddSize)
							font.pointSize: 13
						}
					}
				}
				CheckBox {
					Layout.alignment: Qt.AlignRight
					checked: true
					text: 'Download'
					onCheckedChanged: {
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
		font.pointSize: 13
	}
	Label {
		id: textTotalDownloadSize
		font.pointSize: 13
	}
	Label {
		id: textTotalHddSize
		font.pointSize: 13
	}
	RowLayout {
		spacing: 5
		Layout.alignment: Qt.AlignHCenter
		Button {
			text: qsTr('Cancel')
			onClicked: {
				ZGames.addCancel()
				gameContentView.currentIndex = 0
			}
		}
		Button {
			text: qsTr('Next')
			focus: true
			onClicked: {
				gameContentView.currentIndex = 0
				var res = ZGames.addDlcs()
				if (res !== 0)
					popupError.show('Add failed ' + res)
				else
					setPage('downloads')
			}
		}
	}
}
