import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ZGui 1.0

ApplicationWindow {
	id: rootWindow
	visible: true
	width: 1024
	height: 768
	minimumWidth: 1024
	minimumHeight: 600
	title: 'ZLOEmu'
	Material.theme: Material.Dark
	font.family: appFont.name
	function setPage(name)
	{
		switch (name)
		{
			case 'news':
				topbar.currentIndex = 0
				viewMain.currentIndex = 0
				break;
			case 'games':
				topbar.currentIndex = 1
				viewMain.currentIndex = 1
				break;
			case 'downloads':
				topbar.currentIndex = 2
				viewMain.currentIndex = 2
				break;
			case 'library':
				topbar.currentIndex = 3
				viewMain.currentIndex = 3
				break;
			case 'community':
				topbar.currentIndex = 4
				viewMain.currentIndex = 4
				break;
			case 'settings':
				topbar.currentIndex = 5
				viewMain.currentIndex = 5
				break;
			case 'log':
				topbar.currentIndex = 6
				viewMain.currentIndex = 6
				break;
			case 'steamdumper':
				topbar.currentIndex = 1
				viewMain.currentIndex = 7
				break;
			default:
				console.log('Unk name ' + name)
				break;
		}
	}
	function onlineStatusStr(status, isOwn)
	{
		switch(status)
		{
			case 0:
				return isOwn?'Invisible':'Offline';
			case 1:
				return 'Online';
			case 2:
				return 'Away';
			case 3:
				return 'DND';
		}
		return 'UNK';
	}
	function gameSysStr(sys)
	{
		switch(sys)
		{
			case 0:
				return 'None';
			case 1:
				return 'Steam';
			case 2:
				return 'Origin';
			case 3:
				return 'Battle.Net';
			case 4:
				return 'GOG';
			case 5:
				return 'Files';
			case 6:
				return 'Installer';
		}
		return 'UNK';
	}
	function gameStateStr(state)
	{
		switch(state)
		{
			case 0:
				return qsTr('Not installed');
			case 1:
				return qsTr('Installed');
			case 2:
				return qsTr('Outdated');
			case 3:
				return qsTr('Checking');
			case 4:
				return qsTr('Checking fast');
			case 5:
				return qsTr('Allocating');
			case 6:
				return qsTr('Allocate error');
			case 7:
				return qsTr('Downloading');
			case 8:
				return qsTr('Download error');
			case 9:
				return qsTr('Installing');
			case 10:
				return qsTr('Broken');
			default:
				return qsTr('Unknown');
		}
	}
//
	property FriendsWindow friendsWindow: friendsWindowComp.createObject(null)
	Component {
		id: friendsWindowComp
		FriendsWindow {}
	}
	Connections {
		target: ZUser
		function onSignalStatus(status)
		{
			friendsWindow.statusOwnText = onlineStatusStr(status, true)
			topbar.statusOwnText = onlineStatusStr(status, true)
		}
	}
//
	property ChatsWindow chatsWindow: chatsWindowComp.createObject(null)
	Component {
		id: chatsWindowComp
		ChatsWindow {}
	}
//
	property InviteWindow inviteWindow: inviteWindow.createObject(null)
	Component {
		id: inviteWindow
		InviteWindow {}
	}
//
	Component.onCompleted: setPage('games')
	onClosing: Qt.quit()
	header: TopBar {
		id: topbar
	}
	ColumnLayout {
		anchors.fill: parent
		spacing: 0
		Rectangle {
			id: connectStatus
			visible: false
			color: Material.accent
			Layout.fillWidth: true
			height: childrenRect.height
			Text {
				id: connectStatusText
				anchors.horizontalCenter: parent.horizontalCenter
				font.bold: true
				font.pixelSize: 20
				color: 'black'
			}
		}
		Views {
			id: viewMain
			Layout.fillHeight: true
			Layout.fillWidth: true
		}
	}
	Connections {
		target: ZQt
		function onSignalConnecting()
		{
			connectStatusText.text = 'Connecting...'
			connectStatus.visible = true
		}
		function onSignalConnected()
		{
			connectStatus.visible = false
		}
		function onSignalDisconnected()
		{
			connectStatusText.text = 'Disconnected, reconnecting in 10 seconds'
			connectStatus.visible = true
		}
	}
	FontLoader {
		source: '/fonts/MaterialIcons-Regular.ttf'
		name: 'Material Icons'
	}
	FontLoader {
		id: appFont
		source: '/fonts/NotoSans-Regular.ttf'
		name: 'Noto Sans'
	}
	Popup {
		id: popupBusy
		anchors.centerIn: Overlay.overlay
		width: Math.min(rootWindow.width, rootWindow.height) / 2
		height: Math.min(rootWindow.width, rootWindow.height) / 2
		closePolicy: Popup.NoAutoClose
		dim: true
		modal: true
		function show()
		{
			popupBusyLabel.text = ''
			popupBusy.open()
		}
		function text(str)
		{
			popupBusyLabel.text = str
		}
		ColumnLayout {
			anchors.fill: parent
			BusyIndicator {
				Layout.fillHeight: true
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignHCenter
			}
			Label {
				id: popupBusyLabel
				font.bold: true
				font.pointSize: 13
				Layout.alignment: Qt.AlignHCenter
			}
		}
	}
	Popup {
		id: popupError
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		function show(str)
		{
			popupErrorLabel.text = str
			popupError.open()
		}
		ColumnLayout {
			anchors.centerIn: parent
			Label {
				id: popupErrorLabel
				font.bold: true
				font.pointSize: 13
				Layout.alignment: Qt.AlignHCenter
			}
			Button {
				text: 'Close'
				Layout.alignment: Qt.AlignHCenter
				onClicked: popupError.close()
			}
		}
	}
}
