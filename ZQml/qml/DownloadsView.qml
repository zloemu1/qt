import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	property int dlGame: 0
	Component.onCompleted: {
		if (ZGames.isPaused)
			buttonPause.text = qsTr('Paused')
		else
			buttonPause.text = qsTr('Pause')
	}
	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 5
		spacing: 1
		Button {
			Layout.alignment: Qt.AlignHCenter
			id: buttonPause
			onClicked: ZGames.pause()
		}
		Item {
			Layout.fillWidth: true
			implicitHeight: childrenRect.height
			id: rowSpeeds
			visible: false
			Row {
				Label {
					text: qsTr('Download speed') + ': '
				}
				Label {
					id: speedDlText
				}
			}
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				Label {
					text: qsTr('Write speed') + ': '
				}
				Label {
					id: speedWriteText
				}
			}
			Row {
				anchors.right: parent.right
				Label {
					text: qsTr('ETA') + ': '
				}
				Label {
					id: etaText
				}
			}
		}
		Label {
			id: statusText
		}
		Item {
			Layout.fillWidth: true
			implicitHeight: childrenRect.height
			Row {
				id: rowFiles
				spacing: 1
				visible: false
				Label {
					text: qsTr('Files') + ': '
				}
				Label {
					id: filesText
				}
				Label {
					text: '/'
				}
				Label {
					id: filesTotalText
				}
			}
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				id: rowRemote
				spacing: 1
				visible: false
				Label {
					font.family: 'Material Icons'
					font.pointSize: 15
					text: '\ue2c4'
					ToolTip {
						visible: maRemote.containsMouse
						delay: 1000
						text: qsTr('Downloaded')
					}
					MouseArea {
						id: maRemote
						anchors.fill: parent
						hoverEnabled: true
					}
				}
				Label {
					id: sizeRemoteText
				}
				Label {
					text: '/'
				}
				Label {
					id: sizeRemoteTotalText
				}
			}
			Row {
				anchors.right: parent.right
				id: rowLocal
				spacing: 1
				visible: false
				Label {
					font.family: 'Material Icons'
					font.pointSize: 15
					text: '\ue1db'
					ToolTip {
						visible: maLocal.containsMouse
						delay: 1000
						text: qsTr('Size local')
					}
					MouseArea {
						id: maLocal
						anchors.fill: parent
						hoverEnabled: true
					}
				}
				Label {
					id: sizeLocalText
				}
				Label {
					text: '/'
				}
				Label {
					id: sizeLocalTotalText
				}
			}
		}
		ProgressBar {
			Layout.fillWidth: true
			id: progressFiles
			from: 0
			to: 100
			value: 0
			visible: false
		}
		ProgressBar {
			Layout.fillWidth: true
			id: progressRemote
			from: 0
			to: 100
			value: 0
			visible: false
		}
		ProgressBar {
			Layout.fillWidth: true
			id: progressLocal
			from: 0
			to: 100
			value: 0
			visible: false
		}
		ListView {
			id: dllist
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
	Connections {
		target: ZGames
		function onSignalGCWorkStarted(game)
		{
			dlGame = game
		}
		function onSignalGCFilesProgress(pos)
		{
			progressFiles.value = pos
		}
		function onSignalGCFilesCurrent(files)
		{
			filesText.text = files
		}
		function onSignalGCLocalProgress(pos)
		{
			progressLocal.value = pos
			taskbarButton.progress.value = pos
		}
		function onSignalGCLocalCurrent(size)
		{
			sizeLocalText.text = size
		}
		function onSignalGCRemoteProgress(pos)
		{
			progressRemote.value = pos
		}
		function onSignalGCRemoteCurrent(size)
		{
			sizeRemoteText.text = size
		}
		function onSignalGCCheckStarted(totalSize, files)
		{
			statusText.text = gameStateStr(ZGames.STATE_CHECKING)
			filesText.text = '0'
			filesTotalText.text = files
			rowFiles.visible = true
			sizeLocalText.text = '0'
			sizeLocalTotalText.text = totalSize
			rowLocal.visible = true
			progressFiles.value = 0
			progressFiles.visible = true
			progressLocal.value = 0
			progressLocal.visible = true
			taskbarButton.progress.value = 0
			taskbarButton.progress.visible = true
		}
		function onSignalGCCheckStartedFast(files)
		{
			statusText.text = gameStateStr(ZGames.STATE_CHECKING_FAST)
			filesText.text = '0'
			filesTotalText.text = files
			rowFiles.visible = true
			progressFiles.value = 0
			progressFiles.visible = true
		}
		function onSignalGCCheckDone()
		{
			statusText.text = ''
			rowFiles.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
		}
		function onSignalGCAllocateStarted(totalSize, files)
		{
			statusText.text = gameStateStr(ZGames.STATE_ALLOCATING)
			filesText.text = '0'
			filesTotalText.text = files
			rowFiles.visible = true
			sizeLocalText.text = '0'
			sizeLocalTotalText.text = totalSize
			rowLocal.visible = true
			progressFiles.value = 0
			progressFiles.visible = true
			progressLocal.value = 0
			progressLocal.visible = true
			taskbarButton.progress.value = 0
			taskbarButton.progress.visible = true
		}
		function onSignalGCAllocateError(state, file)
		{
			statusText.text = gameStateStr(ZGames.STATE_ALLOCATE_ERROR) + ' state ' + state + ' in ' + file
			rowFiles.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
		}
		function onSignalGCAllocateDone()
		{
			statusText.text = ''
			rowFiles.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
		}
		function onSignalGCDownloadStarted(totalSizeDl, totalSizeWr, files)
		{
			statusText.text = gameStateStr(ZGames.STATE_DOWNLOADING)
			filesText.text = '0'
			filesTotalText.text = files
			rowFiles.visible = true
			sizeRemoteText.text = '0'
			sizeRemoteTotalText.text = totalSizeDl
			rowRemote.visible = true
			sizeLocalText.text = '0'
			sizeLocalTotalText.text = totalSizeWr
			rowLocal.visible = true
			progressFiles.value = 0
			progressFiles.visible = true
			progressRemote.value = 0
			progressRemote.visible = true
			progressLocal.value = 0
			progressLocal.visible = true
			taskbarButton.progress.value = 0
			taskbarButton.progress.visible = true
			speedDlText.text = '0'
			speedWriteText.text = '0'
			etaText.text = '0'
			rowSpeeds.visible = true
		}
		function onSignalGCDownloadSpeeds(speedDl, speedWrite, eta)
		{
			speedDlText.text = speedDl
			speedWriteText.text = speedWrite
			etaText.text = eta
		}
		function onSignalGCDownloadError(stage)
		{
			statusText.text = gameStateStr(ZGames.STATE_DOWNLOAD_ERROR) + ' stage ' + stage
			rowFiles.visible = false
			rowRemote.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressRemote.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
			rowSpeeds.visible = false
		}
		function onSignalGCDownloadDone()
		{
			statusText.text = ''
			rowFiles.visible = false
			rowRemote.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressRemote.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
			rowSpeeds.visible = false
		}
		function onSignalGCInstalling()
		{
			statusText.text = gameStateStr(ZGames.STATE_INSTALLING)
		}
		function onSignalGCInstallStep(name)
		{
			statusText.text = gameStateStr(ZGames.STATE_INSTALLING) + ' ' + name
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
		function onSignalGCCancelled(game)
		{
			if (dlGame != game)
				return
			dlGame = 0;
			statusText.text = ''
			rowFiles.visible = false
			rowRemote.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressRemote.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
			rowSpeeds.visible = false
		}
		function onSignalGCRemoved(game)
		{
			if (dlGame != game)
				return
			dlGame = 0;
			statusText.text = ''
			rowFiles.visible = false
			rowRemote.visible = false
			rowLocal.visible = false
			progressFiles.visible = false
			progressRemote.visible = false
			progressLocal.visible = false
			taskbarButton.progress.visible = false
			rowSpeeds.visible = false
		}
		function onSignalGCDone(game)
		{
			if (dlGame != game)
				return
			dlGame = 0;
			statusText.text = ''
		}
	}
}
