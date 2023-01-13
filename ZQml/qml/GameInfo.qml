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
				Label {
					text: zgame.name
				}
				Label {
					visible: zgame.releaseDate > 0
					text: qsTr('Release date') + ': ' + Qt.formatDateTime(new Date(zgame.releaseDate * 1000), 'dd.MM.yyyy')
				}
				Label {
					visible: zgame.developer.length > 0
					text: qsTr('Developer') + ': ' + zgame.developer
				}
				Label {
					visible: zgame.publisher.length > 0
					text: qsTr('Publisher') + ': ' + zgame.publisher
				}
				Label {
					text: qsTr('Last run') + ': ' + (zgame.lastStart > 0 ? Qt.formatDateTime(new Date(zgame.lastStart * 1000), 'dd.MM.yyyy hh:mm:ss') : qsTr('never'))
				}
				Label {
					visible: zgame.lastSession > 0
					text: qsTr('Last session') + ': ' + ZQt.formatGametime(zgame.lastSession)
				}
				Label {
					visible: zgame.totalGametime > 0
					text: qsTr('Total played') + ': ' + ZQt.formatGametime(zgame.totalGametime)
				}
				Label {
					id: stateText
					text: qsTr('State') + ': ' + gameStateStr(zgame.state)
				}
				Label {
					text: qsTr('Installed in') + ': ' + zgame.path
				}
				Label {
					text: qsTr('Locale') + ': ' + zgame.localeStr
				}
				Label {
					visible: zgame.remoteVersion != zgame.localVersion
					text: qsTr('Remote version') + ': ' + zgame.remoteVersion
				}
				Label {
					text: qsTr('Local version') + ': ' + zgame.localVersion
				}
				Row {
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
		}
		Column {
			Row {
				spacing: 5
				Button {
					id: runButton
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
					Component.onCompleted: {
						if (ZGames.runnedGame)
							runButton.text = qsTr('Kill')
						else
							runButton.text = qsTr('Run')
					}
					Connections {
						target: ZGames
						function onSignalRunnedGame(game: int) {
							if (game)
								runButton.text = qsTr('Kill')
							else
								runButton.text = qsTr('Run')
						}
					}
					onClicked: {
						if (ZGames.runnedGame)
							ZGames.stop()
						else if (launcherCombo.count > 0)
						{
							if (launcherCombo.currentIndex === -1)
								launcherCombo.currentIndex = 0
							var res = ZGames.start(zgame.id, launcherCombo.currentValue, zgame.data(zgame.index(launcherCombo.currentIndex, 0), Qt.EditRole))
							if (res !== 0)
								popupError.show('Run failed: ' + res)
						}
					}
				}
				AutoResizingComboBox {
					id: launcherCombo
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
					model: zgame
					textRole: 'display'
					valueRole: 'toolTip'
					visible: count > 1
					Component.onCompleted: currentIndex = zgame.lastLauncher
				}
				Button {
					text: 'Set cmd'
					onClicked: {
						if (launcherCombo.count === 0)
							return
						if (launcherCombo.currentIndex === -1)
							launcherCombo.currentIndex = 0
						popupGameCmd.show()
					}
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
				}
			}
			Item {
				width: 1
				height: 10
			}
			Row {
				spacing: 5
				Button {
					text: qsTr('Repair')
					enabled: zgame.state === 1 || zgame.state === 2 || zgame.state === 10
					onClicked: {
						var res = zgame.repair()
						if (res !== 0)
							popupError.show('Repair failed: ' + res)
					}
				}
				Button {
					text: qsTr('Update')
					visible: ZGames.canUpdate
					onClicked: {
						var res = zgame.update()
						if (res !== 0)
							popupError.show('Update failed: ' + res)
					}
				}
				Button {
					text: qsTr('Change lang')
					visible: zgame.locales.length > 1
					enabled: zgame.state === 1
					onClicked: popupLangChange.show()
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
		}
/*
		Item { height: 10; width: 1 }
		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			Label {
				Layout.alignment: Qt.AlignLeft
				Layout.fillWidth: true
				text: 'Downloading'
			}
//cross = \ue5cd
//pause = \ue034
//play = \ue037
			Label {
				text: '\ue034'
				font.family: 'Material Icons'
			}
			Label {
				text: '\ue5cd'
				font.family: 'Material Icons'
			}
		}
		ProgressBar {
			anchors.left: parent.left
			anchors.right: parent.right
			value: zgame.size > 0 ? (zgame.downloaded / zgame.size) : 0
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			text: zgame.size > 0 ? (Math.round(zgame.downloaded / zgame.size * 100) + '%') : 0
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
		Label {
			text: zgame.descr
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
					color: Material.foreground
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
	Popup {
		id: popupLangChange
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		function show()
		{
			ZQt.getLangSelectModel().fill(zgame.id)
			langCombo.currentIndex = langCombo.indexOfValue(zgame.locale)
			popupLangChange.open()
		}
		ColumnLayout {
			anchors.centerIn: parent
			AutoResizingComboBox {
				id: langCombo
				model: ZQt.getLangSelectModel()
				Layout.alignment: Qt.AlignHCenter
				textRole: 'display'
				valueRole: 'edit'
				visible: count > 1
			}
			Row {
				Layout.alignment: Qt.AlignHCenter
				spacing: 10
				Button {
					text: qsTr('Cancel')
					onClicked: popupLangChange.close()
				}
				Button {
					text: qsTr('Change')
					onClicked: {
						var res = zgame.changeLang(langCombo.currentValue);
						popupLangChange.close()
						if (res !== 0)
							popupError.show('Change lang failed: ' + res)
					}
				}
			}
		}
	}
}
