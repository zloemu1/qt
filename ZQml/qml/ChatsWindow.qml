import QtQuick 2.15
import QtQuick.Controls 1.4 as C1
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ZGui 1.0

ApplicationWindow {
	id: rootChats
	width: 250
	height: 400
	minimumWidth: 250
	minimumHeight: 400
	visible: false
	title: 'Chats'
	onClosing: visible = false
	Component.onCompleted: {
		x = (Screen.width - width - 500) / 2
		y = (Screen.height - height) / 2
//		if (ZChats.rowCount())
//			visible = true
	}
	Shortcut {
		sequence: "Esc"
		onActivated: visible = false
	}
	Connections {
		target: ZChats
		function onSignalOpened(select)
		{
			if (!visible)
				visible = true
			if (select)
			{
				chats.currentIndex = chats.count - 1
				requestActivate()
			}
		}
		function onSignalClosed(selected, opened)
		{
			if (selected)
			{
				chatBox.visible = false
				width = minimumWidth
				chatModel.model = null
				chats.currentIndex = -1
			}
			if (!opened)
				visible = false
		}
		function onSignalSelect(chat, idx)
		{
			chats.currentIndex = idx
			chatModel.model = chat
			chatModel.positionViewAtEnd()
			if (!chatBox.visible)
			{
				width = minimumWidth + 500
				chatBox.visible = true
			}
			if (!visible)
				visible = true
			if (!active)
				requestActivate()
		}
	}
	C1.SplitView {
		anchors.fill: parent
		handleDelegate: Rectangle {
			Layout.fillHeight: true
			width: 1
			color: Material.accent
		}
		ListView {
			id: chats
			Layout.fillHeight: true
			Layout.minimumWidth: 150
			clip: true
			spacing: 5
			width: 250
			model: ZChats
			ScrollBar.vertical: ScrollBar {
				policy: chats.contentHeight > chats.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
				implicitWidth: 10
				contentItem: Rectangle {
					color: Material.accent
					radius: 5
				}
			}
			highlightMoveVelocity: -1
			highlight: Rectangle {
				anchors.left: parent ? parent.left : undefined
				anchors.right: parent ? parent.right : undefined
				color: "#3B3B3B"
			}
			delegate: MouseArea {
				Connections {
					target: display
					function onSignalGame()
					{
						if (display.gameName.length)
							statusText.text = display.gameName
						else
							statusText.text = rootWindow.onlineStatusStr(display.status, false)
					}
					function onSignalStatus()
					{
						statusText.text = rootWindow.onlineStatusStr(display.status, false)
					}
				}
				anchors.left: parent ? parent.left : undefined
				anchors.right: parent ? parent.right : undefined
				anchors.rightMargin: chats.contentHeight > chats.height ? 10 : 0
				height: childrenRect.height
				acceptedButtons: Qt.LeftButton
				onClicked: ZChats.select(display.id)
				onDoubleClicked: ZChats.close(display.id)
				RowLayout {
					spacing: 5
					anchors.left: parent.left
					anchors.right: parent.right
					Component.onCompleted: {
						if (display.gameName.length)
							statusText.text = display.gameName
						else
							statusText.text = rootWindow.onlineStatusStr(display.status, false)
					}
					Image {
						source: "image://ZAvatar/" + display.id
						Layout.preferredWidth: 32
						Layout.preferredHeight: 32
					}
					Column {
						Layout.alignment: Qt.AlignVCenter
						Layout.fillWidth: true
						Text {
							text: display.name
							color: '#ACACAC'
							font.bold: true
						}
						Text {
							id: statusText
							color: '#ACACAC'
						}
					}
					Rectangle {
						Layout.alignment: Qt.AlignVCenter
						visible: edit.unreaded > 0
						color: Material.accent
						radius: width*0.5
						width: 15
						height: 15
						Text {
							anchors.centerIn: parent
							text: edit.unreaded
							font.bold: true
							font.pixelSize: parent.width * 0.7
							color: Material.foreground
						}
					}
					Text {
						Layout.alignment: Qt.AlignVCenter
						color: '#ACACAC'
						font.family: "Material Icons"
						font.pixelSize: 14
						text: '\ue5c9'
						MouseArea {
							anchors.fill: parent
							acceptedButtons: Qt.LeftButton
							onClicked: ZChats.close(display.id)
						}
					}
				}
			}
		}
		ColumnLayout {
			id: chatBox
			visible: false
			clip: true
			Layout.fillHeight: true
			Layout.fillWidth: true
			Layout.minimumWidth: 200
			ListView {
				id: chatModel
				Layout.fillHeight: true
				Layout.fillWidth: true
				clip: true
				spacing: 5
				width: 250
				ScrollBar.vertical: ScrollBar {
					policy: chatModel.contentHeight > chatModel.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
					implicitWidth: 10
					contentItem: Rectangle {
						color: Material.accent
						radius: 5
					}
				}
				delegate: Rectangle {
					ListView.onAdd: chatModel.currentIndex = index
					anchors.left: (display.isOur || !parent) ? undefined : parent.left
					anchors.right: (display.isOur && parent) ? parent.right : undefined
					anchors.leftMargin: display.isOur ? 0 : 10
					anchors.rightMargin: display.isOur ? (chatModel.contentHeight > chatModel.height ? 20 : 10) : (chatModel.contentHeight > chatModel.height ? 10 : 0)
					color: '#3B3B3B'
					height: childrenRect.height
					width: childrenRect.width
					radius: 5
					ColumnLayout {
						spacing: 0
						Text {
							padding: 5
							text: Qt.formatDateTime(new Date(display.date), "hh:mm:ss")
							color: "gray"
							font.bold: true
						}
						Text {
							padding: 5
							Layout.maximumWidth: chatModel.width - 30
							text: display.text
							color: "gray"
							font.bold: true
							wrapMode: Text.Wrap
						}
					}
				}
				section.property: 'display.dateInt'
				section.delegate: Rectangle {
					anchors.horizontalCenter: parent.horizontalCenter
					color: Material.accent
					height: childrenRect.height
					width: childrenRect.width
					radius: 5
					Text {
						padding: 3
						text: Qt.formatDateTime(new Date(parseInt(section)), "dd.MM.yyyy")
						color: '#ACACAC'
						font.bold: true
					}
				}
			}
			Rectangle {
				Layout.preferredWidth: 200
				Layout.fillWidth: true
				height: childrenRect.height
				color: "#3B3B3B"
				TextInput {
					id: gameSearch
					anchors.left: parent.left
					anchors.right: parent.right
					font.pointSize: 13
					color: "Gray"
					selectByMouse: true
					onAccepted: {
						ZChats.message(text)
						clear()
					}
				}
			}
		}
	}
}
