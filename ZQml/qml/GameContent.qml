import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

StackLayout {
	function pageChange(vis)
	{
		if (vis)
			return
		if (gameContentView.currentIndex > 0)
		{
			ZGames.addCancel()
			gameContentView.currentIndex = 0
		}
	}
	id: gameContentView
	currentIndex: 0
	clip: true
	ColumnLayout {
		Button {
			Layout.alignment: Qt.AlignHCenter
			text: "Mass install"
			visible: ZGames.getDLCModel().canInstallDlc
			onClicked: {
				var res = ZGames.loadInfoDlc(zgame.id)
				if (res === 0)
					popupBusy.show()
				else
					popupError.show('Load info failed: ' + res)
			}
		}
		ListView {
			id: list
			clip: true
			Layout.fillWidth: true
			Layout.fillHeight: true
			model: ZGames.getDLCModel()
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {
				policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
				implicitWidth: 10
				contentItem: Rectangle {
					color: Material.accent
					radius: 5
				}
			}
			delegate: Rectangle {
				anchors.rightMargin: list.contentHeight > list.height ? 15 : 10
				anchors.left: parent ? parent.left : undefined
				anchors.right: parent ? parent.right : undefined
				height: childrenRect.height
				color: '#3B3B3B'
				visible: display.visible
				function updatePublic()
				{
					paidLabel.visible = display.paid > 0 && !display.owned
					paidLabel.text = 'Paid: ' + display.paid
					buyButton.visible = display.paid && !display.owned
				}
				function updateDownloader()
				{
					sysLabel.visible = display.sys > 0
					sysLabel.text = 'Sys: ' + gameSysStr(display.sys)
					stateText.visible = display.sys > 0
				}
				function updateState()
				{
					stateText.text = 'State: ' + gameStateStr(display.state)
					if (display.state === 0 || display.state === 2 || display.state === 10)
					{
						dlcButton.visible = display.sys > 0 && display.owned
						if (display.state === 0)
							dlcButton.text = qsTr('Install')
						else if (display.state === 2)
							dlcButton.text = qsTr('Update')
						else
							dlcButton.text = qsTr('Repair')
					}
					else
						dlcButton.visible = false
				}
				Connections {
					target: display
					function onSignalUpdatePublic() { updatePublic() }
					function onSignalUpdateDownloader() { updateDownloader() }
					function onSignalUpdateState() { updateState() }
				}
				Component.onCompleted:
				{
					updatePublic()
					updateDownloader()
					updateState()
				}
				RowLayout {
					anchors.left: parent.left
					anchors.right: parent.right
					Image {
						Layout.leftMargin: 5
						Layout.preferredHeight: 200
						Layout.maximumHeight: 200
//fix me
						Layout.preferredWidth: 144
						Layout.maximumWidth: 200
						asynchronous: true
						source: display.cover
						fillMode: Image.PreserveAspectFit
					}
					Rectangle {
						Layout.margins: 5
						Layout.fillHeight: true
						Layout.fillWidth: true
						color: Material.primary
						Column {
							anchors.leftMargin: 5
							anchors.left: parent.left
							anchors.verticalCenter: parent.verticalCenter
							Label {
								text: display.name
							}
							Label {
								id: sysLabel
							}
							Label {
								id: stateText
							}
							Label {
								id: paidLabel
							}
						}
					}
					Button {
						id: dlcButton
						Layout.rightMargin: 5
						Layout.alignment: Qt.AlignVCenter
						onClicked: {
							if (decoration.state > 1)
							{
								if (decoration.state === 2)
									decoration.update()
								else
									decoration.repair()
								setPage('downloads')
								return
							}
							var res = ZGames.loadInfoDlc(decoration.id)
							if (res === 0)
								popupBusy.show()
							else
								popupError.show('Load info failed: ' + res)
						}
					}
					Button {
						id: buyButton
						Layout.rightMargin: 5
						Layout.alignment: Qt.AlignVCenter
						text: qsTr('Buy')
						onClicked: {
							text = 'DERP'
						}
					}
				}
			}
		}
	}
	GameContentAdd {}
}
