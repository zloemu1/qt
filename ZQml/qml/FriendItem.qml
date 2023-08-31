import QtQuick 2.0
import ZGui 1.0

MouseArea {
	function setFStatus(fstatus, status, game)
	{
		statusText.visible = false
		rowCancel.visible = false
		rowIncoming.visible = false
		if (fstatus === 0)
			rowCancel.visible = true
		else if (fstatus === 1)
			rowIncoming.visible = true
		else if (status > 1 || game) //1 - just online
			statusText.visible = true
	}
	Connections {
		target: display
		function onSignalGame() {
			if (display.gameName.length)
				statusText.text = display.gameName
			else
				statusText.text = rootWindow.onlineStatusStr(display.status, false)
		}
		function onSignalStatus() {
			statusText.text = rootWindow.onlineStatusStr(display.status, false)
		}
		function onSignalFStatus() {
			setFStatus(display.fstatus, display.status, display.game)
		}
	}
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	height: childrenRect.height
	acceptedButtons: Qt.LeftButton | Qt.RightButton
	onClicked: if (display.fstatus === 2 && mouse.button === Qt.RightButton) friendMenu.show(display.id)
	onDoubleClicked: if (display.fstatus === 2 && mouse.button === Qt.LeftButton) ZChats.open(display.id, true)
	Row {
		spacing: 5
		anchors.left: parent.left
		anchors.right: parent.right
		Component.onCompleted: {
			setFStatus(display.fstatus, display.status, display.game);
			if (display.fstatus === 2)
			{
				if (display.gameName.length)
					statusText.text = display.gameName
				else
					statusText.text = rootWindow.onlineStatusStr(display.status, false)
			}
		}
		Image {
			id: avatar
			cache: false
			source: 'file:///' + ZFriends.getAvatar(display.id)
			width: 32
			height: 32
			Connections {
				target: display
				function onSignalAvatar(path)
				{
					avatar.source = ''
					avatar.source = 'file:///' + path
				}
			}
		}
		Column {
			anchors.verticalCenter: parent.verticalCenter
			Text {
				text: display.name
				color: '#ACACAC'
				font.bold: true
			}
			Text {
				id: statusText
				color: '#ACACAC'
			}
			MouseArea {
				id: rowCancel
				width:  childrenRect.width
				height: childrenRect.height
				onClicked: ZFriends.del(display.id)
				Row {
					Text {
						color: '#ACACAC'
						font.family: "Material Icons"
						font.pixelSize: 14
						text: '\ue5c9'
					}
					Text {
						color: '#ACACAC'
						text: qsTr('Cancel')
					}
				}
			}
			Row {
				id: rowIncoming
				MouseArea {
					width:  childrenRect.width
					height: childrenRect.height
					onClicked: ZFriends.add(display.id)
					Row {
						Text {
							color: '#ACACAC'
							font.family: "Material Icons"
							font.pixelSize: 14
							text: '\ue86c'
						}
						Text {
							color: '#ACACAC'
							text: qsTr('Accept')
						}
					}
				}
				Item {
					width: 10
					height: 1
				}
				MouseArea {
					width:  childrenRect.width
					height: childrenRect.height
					onClicked: ZFriends.del(display.id)
					Row {
						Text {
							color: '#ACACAC'
							font.family: "Material Icons"
							font.pixelSize: 14
							text: '\ue5c9'
						}
						Text {
							color: '#ACACAC'
							text: qsTr('Reject')
						}
					}
				}
			}
		}
	}
}
