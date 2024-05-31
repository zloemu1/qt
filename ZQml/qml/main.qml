import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtWinExtras 1.15
import ZGui 1.0

ApplicationWindow {
	TaskbarButton {
		id: taskbarButton
		progress.minimum: 0
		progress.maximum: 100
		progress.value: 0
		progress.paused: false
		progress.visible: false
	}
	id: rootWindow
	visible: true
	width: 1024
	height: 768
	minimumWidth: 1024
	minimumHeight: 600
	title: 'ZLOEmu'
	Material.theme: Material.Dark
	font.family: appFont.name
	font.pointSize: 12
	font.capitalization: Font.MixedCase
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
			default:
				console.log('Unk name ' + name)
				break;
		}
	}
	function onlineStatusStr(status, isOwn)
	{
		switch(status)
		{
			case ZFriends.STATE_OFFLINE:
				return isOwn?qsTr('Invisible'):qsTr('Offline');
			case ZFriends.STATE_ONLINE:
				return qsTr('Online');
			case ZFriends.STATE_AWAY:
				return qsTr('Away');
			case ZFriends.STATE_DND:
				return qsTr('DND');
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
			case ZGames.STATE_NOT_INSTALLED:
				return qsTr('Not installed');
			case ZGames.STATE_INSTALLED:
				return qsTr('Installed');
			case ZGames.STATE_OUTDATED:
				return qsTr('Outdated');
			case ZGames.STATE_CHECKING:
				return qsTr('Checking');
			case ZGames.STATE_CHECKING_FAST:
				return qsTr('Checking fast');
			case ZGames.STATE_ALLOCATING:
				return qsTr('Allocating');
			case ZGames.STATE_ALLOCATE_ERROR:
				return qsTr('Allocate error');
			case ZGames.STATE_DOWNLOADING:
				return qsTr('Downloading');
			case ZGames.STATE_DOWNLOAD_ERROR:
				return qsTr('Download error');
			case ZGames.STATE_INSTALLING:
				return qsTr('Installing');
			case ZGames.STATE_BROKEN:
				return qsTr('Broken');
			default:
				return qsTr('Unknown');
		}
	}
//
	property TrayMenu trayMenu: trayMenuComp.createObject(null)
	Component {
		id: trayMenuComp
		TrayMenu {}
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
//	onClosing: Qt.quit()
	onClosing: visible = false
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
			Label {
				id: connectStatusText
				anchors.horizontalCenter: parent.horizontalCenter
				font.bold: true
				font.pixelSize: 20
				color: 'black'
			}
		}
		Column {
			id: updateStatus
			visible: false
			Layout.fillWidth: true
			height: childrenRect.height
			Label {
				id: updateStatusText
				anchors.horizontalCenter: parent.horizontalCenter
				font.bold: true
				font.pixelSize: 20
			}
			ProgressBar {
				id: updateProgress
				from: 0
				anchors.left: parent.left
				anchors.right: parent.right
			}
		}
		Views {
			id: viewMain
			Layout.fillHeight: true
			Layout.fillWidth: true
		}
		Rectangle {
			id: baseUpdateStatus
			visible: false
			color: '#3B3B3B'
			Layout.fillWidth: true
			height: childrenRect.height
			Row {
				anchors.horizontalCenter: parent.horizontalCenter
				spacing: 10
				Label {
					id: baseUpdateStatusText
					font.bold: true
					font.pixelSize: 20
					text: 'ZClient main files was updated'
				}
				Button {
					height: baseUpdateStatusText.height + 5
					text: 'Restart'
					onClicked: ZQt.restartClient()
				}
			}
		}
	}
	Connections {
		target: ZQt
		function onSignalUpdaterStart(name, size, zdata)
		{
			if (zdata)
				updateStatusText.text = qsTr('Updating') + ' ZData ' + name
			else
				updateStatusText.text = qsTr('Updating') + ' ' + name
			updateProgress.to = size
			updateProgress.value = 0
			updateStatus.visible = true
		}
		function onSignalUpdaterPart(size)
		{
			updateProgress.value += size
		}
//		function onSignalUpdaterFailed(name, zdata, t)
		function onSignalUpdaterFinished()
		{
			updateStatus.visible = false
		}
		function onSignalConnecting()
		{
			connectStatusText.text = qsTr('Connecting...')
			connectStatus.visible = true
		}
		function onSignalConnected()
		{
			connectStatus.visible = false
		}
		function onSignalDisconnected()
		{
			connectStatusText.text = qsTr('Disconnected, reconnecting in 10 seconds')
			connectStatus.visible = true
		}
		function onSignalHaveBaseUpdate()
		{
			baseUpdateStatus.visible = true
		}
		function onSignalIcon(rmb, xpos)
		{
			if (rmb)
				trayMenu.zshow(xpos)
			else if (visible)
				hide()
			else
			{
				show()
				requestActivate()
			}
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
				Layout.alignment: Qt.AlignHCenter
			}
			Button {
				text: qsTr('Close')
				Layout.alignment: Qt.AlignHCenter
				onClicked: popupError.close()
			}
		}
	}
}
