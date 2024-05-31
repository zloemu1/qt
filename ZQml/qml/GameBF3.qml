import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

StackLayout {
	id: stack
	currentIndex: 0
	clip: true
	function pageChange(vis)
	{
		if (vis)
			ZGameServers.subscribe('BF3')
		else
		{
			serverDetails(null)
			ZGameServers.unsubscribe('BF3')
		}
	}
	property GameServerBF3 zsrv: null
	property var sv: null
	function serverDetails(srv)
	{
		stack.currentIndex = 0
		if (sv !== null)
		{
			sv.destroy()
			sv = null
		}
		if (srv)
		{
			zsrv = srv
			sv = serverView.createObject(stack)
			if (sv.status === Component.Error)
				console.log('Create bf3 server view error ' + sv.errorString())
			else
				stack.currentIndex = 1
		}
	}
	function runBF3(srv, mode = 0, pass = '')
	{
		
		switch (ZGameServers.startBF3(zgame.id, srv, mode, pass))
		{
			case 255:
				popupBF3Error.show('Wrong mode')
				break;
			case 254:
				popupBF3Error.show('Server not found')
				break;
			case 253:
				popupBF3Error.show('Wrong password')
				break;
		}
	}
	Connections {
		target: ZGameServers
		function onSignalBF3Delete(id) { if (sv !== null && zsrv.id == id) serverDetails(null) }
	}
	ListView {
		id: list
		Layout.leftMargin: 10
		Layout.topMargin: 10
		model: ZGameServers
		spacing: 3
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		delegate: Column {
			anchors.rightMargin: list.contentHeight > list.height ? 15 : 10
			anchors.left: parent ? parent.left : undefined
			anchors.right: parent ? parent.right : undefined
			RowLayout {
				anchors.left: parent.left
				anchors.right: parent.right
				MouseArea {
					onClicked: serverDetails(display)
					Layout.fillWidth: true
					height: childrenRect.height
					RowLayout {
						anchors.left: parent.left
						anchors.right: parent.right
						Image {
							Layout.preferredHeight: 50
							Layout.preferredWidth: paintedWidth
							source: '/bf3/maps/' + display.level + '.jpg'
							fillMode: Image.PreserveAspectFit
						}
						Column {
							Layout.fillWidth: true
							Row {
								Label {
									text: '\ue897'
									visible: display.secret.length > 0
								}
								Label {
									text: display.name
									wrapMode: Text.Wrap
								}
							}
							Label {
								text: display.levelname + ' | ' + modeNameBF(display.mode)
							}
						}
						Rectangle {
							implicitHeight: 50
							implicitWidth: 50
							Text {
								text: display.players.length + ' / ' + display.PMAX
								anchors.centerIn: parent
							}
						}
					}
				}
				Button {
					implicitHeight: 50
					implicitWidth: 50
					text: "\ue037"
					font.family: "Material Icons"
					font.pointSize: 15
					onClicked: if (decoration.secret.length > 0) popupBF3Pass.show(decoration.id); else runBF3(decoration.id)
					enabled: ZGames.runnedGame === 0
					ToolTip {
						visible: parent.hovered
						delay: 1000
						text: qsTr('Join')
					}
				}
			}
		}
	}
	Component {
		id: serverView
		GameBF3Server {}
	}
	Popup {
		id: popupBF3Pass
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		property int joinId;
		function show(_joinId)
		{
			joinId = _joinId
			popupBF3PassInput.text = ''
			popupBF3Pass.open()
		}
		ColumnLayout {
			anchors.centerIn: parent
			Label {
				Layout.alignment: Qt.AlignHCenter
				text: 'Enter password'
			}
			Rectangle {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: 500
				height: childrenRect.height
				color: "#3B3B3B"
				TextInput {
					id: popupBF3PassInput
					anchors.left: parent.left
					anchors.right: parent.right
					font.pointSize: 13
					color: Material.foreground
					selectByMouse: true
				}
			}
			Row {
				Layout.alignment: Qt.AlignHCenter
				spacing: 10
				Button {
					text: qsTr('Cancel')
					onClicked: popupBF3Pass.close()
				}
				Button {
					text: qsTr('Continue')
					onClicked: {
						popupBF3Pass.close()
						runBF3(popupBF3Pass.joinId, 0, popupBF3PassInput.text)
					}
				}
			}
		}
	}
	Popup {
		id: popupBF3Error
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		function show(str)
		{
			popupBF3ErrorLabel.text = str
			popupBF3Error.open()
		}
		ColumnLayout {
			anchors.centerIn: parent
			Label {
				id: popupBF3ErrorLabel
				font.bold: true
				Layout.alignment: Qt.AlignHCenter
			}
			Button {
				text: qsTr('Close')
				Layout.alignment: Qt.AlignHCenter
				onClicked: popupBF3Error.close()
			}
		}
	}
}
