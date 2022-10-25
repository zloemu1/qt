import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	id: pageGameInfo
	Column {
		id: xcol
		anchors.left: parent.left
		anchors.right: parent.right
		Row {
			Image {
				source: zgame.cover
				width: 250
				height: 350
				visible: zgame.cover.length > 0
			}
			Item {
				width: 5
				height: 1
			}
			Column {
				Text {
					text: zgame.name
					color: Material.color(Material.Grey)
					font.pixelSize: 15
				}
				Text {
					visible: zgame.releaseDate > 0
					text: qsTr('Release date') + ': ' + Qt.formatDateTime(new Date(zgame.releaseDate * 1000), 'dd.MM.yyyy')
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					visible: zgame.developer.length > 0
					text: qsTr('Developer') + ': ' + zgame.developer
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					visible: zgame.publisher.length > 0
					text: qsTr('Publisher') + ': ' + zgame.publisher
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					text: qsTr('Last run') + ': ' + (zgame.lastStart > 0 ? Qt.formatDateTime(new Date(zgame.lastStart * 1000), 'dd.MM.yyyy hh:mm:ss') : 'never')
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					visible: zgame.totalGametime > 0
					text: 'Total played: ' + ZQt.formatGametime(zgame.totalGametime)
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					text: 'Sys: ' + gameSysStr(zgame.sys)
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					id: stateText
					text: 'State: ' + gameStateStr(zgame.state)
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					text: 'Installed in: ' + zgame.path
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					text: 'Remote version: ' + zgame.remoteVersion
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				Text {
					id: installedVersion
					text: 'Local version: ' + zgame.localVersion
					color: Material.color(Material.Grey)
					font.pixelSize: 13
				}
				CheckBox {
					checked: zgame.autoUpdate
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
					text: 'Auto update'
					onClicked: zgame.toggleAutoUpdate()
				}
				CheckBox {
					checked: zgame.autoDlc
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
					text: 'Auto install new DLC'
					onClicked: zgame.toggleAutoDlc()
				}
			}
		}
		Row {
			Connections {
				target: ZGames
				function onSignalRunnedGame(game: int) {
					if (game)
						runButton.text = qsTr('Kill')
					else
						runButton.text = qsTr('Run')
				}
			}
			Button {
				id: runButton
				enabled: launcherCombo.currentIndex > -1
				Component.onCompleted: {
					if (ZGames.runnedGame)
						runButton.text = qsTr('Kill')
					else
						runButton.text = qsTr('Run')
				}
				onClicked: {
					if (ZGames.runnedGame)
						ZGames.stop()
					else
						ZGames.start(zgame.id, launcherCombo.currentValue, zgame.data(zgame.index(launcherCombo.currentIndex, 0), Qt.EditRole))
				}
			}
			AutoResizingComboBox {
				id: launcherCombo
				model: zgame
				textRole: 'display'
				valueRole: 'toolTip'
				visible: count > 1
				Component.onCompleted: currentIndex = zgame.lastLauncher
			}
			Item {
				width: 5
				height: 1
			}
			Button {
				text: 'Set cmd'
				onClicked: popupGameCmd.show()
				enabled: launcherCombo.currentIndex > -1
			}
			Item {
				width: 5
				height: 1
			}
			Button {
				text: qsTr('Repair')
				onClicked: zgame.repair()
			}
			Button {
				text: qsTr('Update')
				visible: ZGames.canUpdate
				onClicked: zgame.update()
			}
			Item {
				width: 5
				height: 1
			}
			Button {
				text: qsTr('Remove')
				enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
				onClicked: {
					installedGamesList.currentIndex = -1
					dialogRemoveGame.open()
				}
			}
		}
/*
		Item { height: 10; width: 1 }
		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			Text {
				Layout.alignment: Qt.AlignLeft
				Layout.fillWidth: true
				text: 'Downloading'
				color: Material.color(Material.Grey)
				font.pixelSize: 13
			}
//cross = \ue5cd
//pause = \ue034
//play = \ue037
			Text {
				text: '\ue034'
				font.family: 'Material Icons'
				font.pixelSize: 15
				color: Material.color(Material.Grey)
			}
			Text {
				text: '\ue5cd'
				font.family: 'Material Icons'
				font.pixelSize: 15
				color: Material.color(Material.Grey)
			}
		}
		ProgressBar {
			anchors.left: parent.left
			anchors.right: parent.right
			value: zgame.size > 0 ? (zgame.downloaded / zgame.size) : 0
		}
		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			text: zgame.size > 0 ? (Math.round(zgame.downloaded / zgame.size * 100) + '%') : 0
			color: Material.color(Material.Grey)
			font.pixelSize: 13
		}
*/
	}
	ScrollView {
		id: scrollView
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: xcol.bottom
		anchors.bottom: parent.bottom
		clip: true
		ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
		ScrollBar.vertical.policy: scrollView.contentHeight > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
		ScrollBar.vertical.implicitWidth: 10
		ScrollBar.vertical.contentItem: Rectangle {
			color: Material.accent
			radius: 5
		}
		Text {
			text: zgame.descr
			color: Material.color(Material.Grey)
			font.pixelSize: 13
			wrapMode: Text.WordWrap
			width: pageGameInfo.width - 10
		}
	}
	Popup {
		id: popupGameCmd
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		function show()
		{
			popupGameCmdInput.text = zgame.data(zgame.index(launcherCombo.currentIndex, 0), Qt.EditRole)
			popupGameCmd.open()
		}
		ColumnLayout {
			anchors.centerIn: parent
			Rectangle {
				Layout.alignment: Qt.AlignHCenter
				Layout.preferredWidth: 500
				height: childrenRect.height
				color: "#3B3B3B"
				TextInput {
					id: popupGameCmdInput
					anchors.left: parent.left
					anchors.right: parent.right
					font.pointSize: 13
					color: "Gray"
					selectByMouse: true
				}
			}
			Row {
				Layout.alignment: Qt.AlignHCenter
				spacing: 10
				Button {
					text: qsTr('Close')
					onClicked: popupGameCmd.close()
				}
				Button {
					text: qsTr('Save')
					onClicked: {
						zgame.setCmd(launcherCombo.currentIndex, popupGameCmdInput.text)
						popupGameCmd.close()
					}
				}
			}
		}
	}
}
