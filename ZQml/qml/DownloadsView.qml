import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	property int dlgame: 0
	Component.onCompleted: {
		if (ZGames.isPaused)
			buttonPause.text = qsTr('Paused')
		else
			buttonPause.text = qsTr('Pause')
	}
	Connections {
		target: ZGames
		function onSignalGCDownloadStarted(game, totalSizeDl, totalSizeWr, files)
		{
			dlgame = game
			speedDownload.text = '0'
			speedWrite.text = '0'
			speeds.visible = true
		}
		function onSignalGCDownloadError(game, stage)
		{
			dlgame = 0;
			speeds.visible = false
		}
		function onSignalGCDownloadDone(game)
		{
			dlgame = 0;
			speeds.visible = false
		}
		function onSignalGCDownloadSpeeds(speedDl, speedWr)
		{
			speedDownload.text = speedDl
			speedWrite.text = speedWr
		}
		function onSignalGCCancelled(game)
		{
			if (dlgame != game)
				return
			dlgame = 0;
			speeds.visible = false
		}
		function onSignalGCRemoved(game)
		{
			if (dlgame != game)
				return
			dlgame = 0;
			speeds.visible = false
		}
		function onSignalGCPaused(paused)
		{
			switch(paused)
			{
				case 0:
					buttonPause.text = qsTr('Pause')
					buttonPause.enabled = true
					break;
				case 1:
					buttonPause.text = qsTr('Paused')
					buttonPause.enabled = true
					break;
				case 2:
					buttonPause.text = qsTr('Waiting for pause')
					buttonPause.enabled = false
					break;
			}
		}
	}
	ColumnLayout {
		anchors.fill: parent
		Item {
			Layout.fillWidth: true
			implicitHeight: childrenRect.height
			Button {
				anchors.horizontalCenter: parent.horizontalCenter
				id: buttonPause
				onClicked: ZGames.pause()
			}
			Column {
				anchors.right: parent.right
				id: speeds
				visible: false
				Row {
					Label {
						text: qsTr('Download speed') + ': '
					}
					Label {
						id: speedDownload
						text: '0'
					}
				}
				Row {
					Label {
						text: qsTr('Write speed') + ': '
					}
					Label {
						id: speedWrite
						text: '0'
					}
				}
			}
		}
		ListView {
			id: dllist
			Layout.leftMargin: 5
			Layout.rightMargin: 5
			Layout.fillHeight: true
			Layout.fillWidth: true
			model: ZGames.getDownloadModel()
			clip: true
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {
				policy: dllist.contentHeight > dllist.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
				implicitWidth: 10
				contentItem: Rectangle {
					color: Material.accent
					radius: 5
				}
			}
			highlightMoveVelocity: -1
			spacing: 3
			delegate: DownloadsItem {
				anchors.rightMargin: dllist.contentHeight > dllist.height ? 10 : 0
			}
		}
	}
}
