import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ZGui 1.0

ApplicationWindow {
	id: rootInvite
	width: 400
	height: 250
	minimumWidth: 400
	minimumHeight: 250
	visible: false
	title: 'Invite to game'
	property int timeout: 20000
	property var inviteFrom: 0
	property string inviteKey
	function zclose()
	{
		timer.stop()
		if (inviteFrom > 0)
		{
			ZFriends.inviteReject(inviteFrom, inviteKey)
			inviteFrom = 0
		}
		visible = false
	}
	onClosing: zclose()
	Component.onCompleted: {
		x = (Screen.width - width) / 2
		y = (Screen.height - height) / 2
	}
	Shortcut {
		sequence: "Esc"
		onActivated: zclose()
	}
	Connections {
		target: ZFriends
		function onSignalInviteAccept(id, key)
		{
			inviteFrom = 0
			zclose()
		}
		function onSignalInviteReject(id, key)
		{
			inviteFrom = 0
			zclose()
		}
		function onSignalInvited(id, name, game, key, text)
		{
			inviteFrom = id
			inviteKey = key
			nameLabel.text = name
			gameLabel.text = game
			progress.value = timeout
			timer.start()
			visible = true
			requestActivate()
		}
	}
	Timer {
		id: timer
		interval: 100
		repeat: true
		onTriggered: {
			progress.value -= interval
			if (progress.value <= 0)
				zclose()
		}
	}
	ColumnLayout {
		anchors.centerIn: parent
		Label {
			id: nameLabel
			Layout.alignment: Qt.AlignHCenter
		}
		Label {
			Layout.alignment: Qt.AlignHCenter
			text: 'has invited you to play'
		}
		Label {
			id: gameLabel
			Layout.alignment: Qt.AlignHCenter
		}
		ProgressBar {
			id: progress
			from: 0
			to: timeout
			Layout.fillWidth: true
		}
		Row {
			Layout.alignment: Qt.AlignHCenter
			spacing: 10
			Button {
				text: qsTr('Reject')
				onClicked: zclose()
			}
			Button {
				text: qsTr('Accept')
				onClicked: {
					ZFriends.inviteAccept(inviteFrom, inviteKey)
					zgame.setCmd(launcherCombo.currentIndex, popupGameCmdInput.text)
					popupGameCmd.close()
				}
			}
		}
	}
}
