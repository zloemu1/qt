import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	Component.onCompleted: {
		if (ZGames.isPaused)
			buttonPause.text = qsTr('Paused')
		else
			buttonPause.text = qsTr('Pause')
	}
	Connections {
		target: ZGames
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
		Button {
			Layout.alignment: Qt.AlignHCenter
			id: buttonPause
			onClicked: ZGames.pause()
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
			}
			highlightMoveVelocity: -1
			spacing: 3
			delegate: DownloadsItem {
			}
		}
	}
}
