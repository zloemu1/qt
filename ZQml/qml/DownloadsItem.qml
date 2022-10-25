import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Rectangle {
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	height: childrenRect.height
	color: "#3D3D3D"
	clip: true
	Connections {
		target: display
		function onSignalUpdateDl(stateChanged: bool, filesChanged: bool, localChanged: bool, remoteChanged: bool)
		{
			if (stateChanged)
			{
				statusText.text = gameStateStr(display.state)
				progressFiles.visible = filesChanged
				progressLocal.visible = localChanged
				progressRemote.visible = remoteChanged
				if (filesChanged)
				{
					progressFiles.from = display.files
					progressFiles.to = display.filesTotal
					progressFiles.value = display.files
					filesText.text = display.files
				}
				if (localChanged)
				{
					progressLocal.from = display.sizeLocal
					progressLocal.to = display.sizeLocalTotal
					progressLocal.value = display.sizeLocal
					sizeLocalText.text = ZQt.formattedDataSize(display.sizeLocal)
				}
				if (remoteChanged)
				{
					progressRemote.from = display.sizeRemote
					progressRemote.to = display.sizeRemoteTotal
					progressRemote.value = display.sizeRemote
					sizeRemoteText.text = ZQt.formattedDataSize(display.sizeRemote)
				}
				filesTotalText.text = "/" + display.filesTotal
				sizeLocalTotalText.text = "/" + ZQt.formattedDataSize(display.sizeLocalTotal)
				sizeRemoteTotalText.text = "/" + ZQt.formattedDataSize(display.sizeRemoteTotal)
			}
			if (filesChanged)
			{
				progressFiles.value = display.files
				filesText.text = display.files
			}
			if (localChanged)
			{
				progressLocal.value = display.sizeLocal
				sizeLocalText.text = ZQt.formattedDataSize(display.sizeLocal)
			}
			if (remoteChanged)
			{
				progressRemote.value = display.sizeRemote
				sizeRemoteText.text = ZQt.formattedDataSize(display.sizeRemote)
			}
		}
		function onSignalInstallStep(name)
		{
			statusText.text = "Installing: " + name
		}
	}
	Column {
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 1
		ProgressBar {
			id: progressFiles
			from: 0
			to: 100
			value: 0
			anchors.left: parent.left
			anchors.right: parent.right
		}
		ProgressBar {
			id: progressLocal
			from: 0
			to: 100
			value: 0
			anchors.left: parent.left
			anchors.right: parent.right
		}
		ProgressBar {
			id: progressRemote
			from: 0
			to: 100
			value: 0
			anchors.left: parent.left
			anchors.right: parent.right
		}
		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: 8
			anchors.rightMargin: 8
			spacing: 10
			Label {
				text: display.name
				font.pointSize: 13
			}
			Column {
				Layout.alignment: Qt.AlignHCenter
				Label {
					id: statusText
					text: gameStateStr(display.state)
					font.pointSize: 13
				}
				Row {
					Label {
						text: "Files: "
						font.pointSize: 13
					}
					Label {
						id: filesText
						text: display.files
						font.pointSize: 13
					}
					Label {
						id: filesTotalText
						text: "/" + display.filesTotal
						font.pointSize: 13
					}
				}
			}
			Column {
				Layout.alignment: Qt.AlignRight
				Row {
					Label {
						text: "Downloaded: "
						font.pointSize: 13
					}
					Label {
						id: sizeRemoteText
						text: ZQt.formattedDataSize(display.sizeRemote)
						font.pointSize: 13
					}
					Label {
						id: sizeRemoteTotalText
						text: "/" + ZQt.formattedDataSize(display.sizeRemoteTotal)
						font.pointSize: 13
					}
				}
				Row {
					Label {
						text: "Size local: "
						font.pointSize: 13
					}
					Label {
						id: sizeLocalText
						text: ZQt.formattedDataSize(display.sizeLocal)
						font.pointSize: 13
					}
					Label {
						id: sizeLocalTotalText
						text: "/" + ZQt.formattedDataSize(display.sizeLocalTotal)
						font.pointSize: 13
					}
				}
			}
			Button {
				text: "Cancel"
				onClicked: ZGames.cancel(decoration.id) //decoration is just another role, because display used in button
			}
		}
	}
}
