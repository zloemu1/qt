import QtQuick 2.15
import QtQuick.Controls 1.4 as C1
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1 as Platform
import ZGui 1.0

Page {
	id: rootGamesView
	property var compInfo: Qt.createComponent("GameInfo.qml")
	property var compDescr: Qt.createComponent("GameDescr.qml")
	property var compDLC: Qt.createComponent("GameContent.qml")
	property var compNews: Qt.createComponent("GameNews.qml")
	property var compAchievements: Qt.createComponent("GameAchievements.qml")
	property variant zviews: ({
		'bf3':{'comp':Qt.createComponent("GameBF3.qml"),'tab':'Servers'},
		'bf4':{'comp':Qt.createComponent("GameBF4.qml"),'tab':'Servers'},
		'bfhl':{'comp':Qt.createComponent("GameBFHL.qml"),'tab':'Servers'},
		'sims4':{'comp':Qt.createComponent("GameSims4.qml"),'tab':'Gallery'},
	})
	Component.onCompleted: {
		if (compInfo.status === Component.Error) console.log('Create compInfo error ' + compInfo.errorString())
		if (compDescr.status === Component.Error) console.log('Create compDescr error ' + compDescr.errorString())
		if (compDLC.status === Component.Error) console.log('Create compDLC error ' + compDLC.errorString())
		if (compNews.status === Component.Error) console.log('Create compNews error ' + compNews.errorString())
		if (compAchievements.status === Component.Error) console.log('Create compAchievements error ' + compAchievements.errorString())
		for (var view in zviews)
			if (zviews[view].comp.status === Component.Error)
				console.log('Create ' + view +' error ' + zviews[view].comp.errorString())
	}
	property var gv: null
	property QtGame zgame
	function pageChange(vis) {
		if (gv !== null && gv.pageChange !== null)
			gv.pageChange(vis)
	}
	RowLayout {
		id: rlayout
		anchors.fill: parent
		anchors.margins: 10
		ColumnLayout {
			Rectangle {
				Layout.preferredWidth: 200
				height: childrenRect.height
				color: "#3B3B3B"
				TextInput {
					id: gameSearch
					anchors.left: parent.left
					anchors.right: parent.right
					font.pointSize: 13
					clip: true
					color: Material.foreground
					onTextEdited: ZGames.filterName(text)
					selectByMouse: true
				}
			}
			Rectangle {
				Layout.preferredWidth: 200
				Layout.fillHeight: true
				color: "#3B3B3B"
				ListView {
					id: installedGamesList
					anchors.fill: parent
					model: ZGames
					clip: true
					boundsBehavior: Flickable.StopAtBounds
					ScrollBar.vertical: ScrollBar {
						policy: installedGamesList.contentHeight > installedGamesList.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
						implicitWidth: 10
						contentItem: Rectangle {
							color: Material.accent
							radius: 5
						}
					}
					currentIndex: -1
					highlightMoveVelocity: -1
					delegate: Label {
						anchors.left: parent ? parent.left : undefined
						anchors.right: parent ? parent.right : undefined
						anchors.rightMargin: installedGamesList.contentHeight > installedGamesList.height ? 10 : 0
						clip: true
						text: display.name
//						ToolTip.text: display.name
//						ToolTip.visible: ma.containsMouse && contentWidth > width
						MouseArea {
//							id: ma
							anchors.fill: parent
							onClicked: installedGamesList.currentIndex = index
//							hoverEnabled: true
						}
					}
					highlight: Rectangle {
						anchors.left: parent ? parent.left : undefined
						anchors.right: parent ? parent.right : undefined
						color: "#232323"
					}
					onCurrentItemChanged: {
						if (!installedGamesList.currentItem)
							installedGamesList.currentIndex = -1
					}
					onCurrentIndexChanged: {
						if (gv !== null)
						{
							gv.kill()
							gv.destroy()
							gv = null
						}
						if (installedGamesList.currentIndex >= 0)
						{
							zgame = model.data(model.index(currentIndex, 0), 0)
							gv = gameView.createObject(rlayout)
							if (gv.status === Component.Error)
								console.log('Create games view error ' + gv.errorString())
						}
					}
				}
			}
		}
		Component {
			id: gameView
			GameView {
				Layout.fillHeight: true
				Layout.fillWidth: true
			}
		}
	}
	Popup {
		id: dialogRemoveGame
		anchors.centerIn: Overlay.overlay
		closePolicy: Popup.NoAutoClose
		dim: true
		modal: true
		ColumnLayout {
			Label {
				font.bold: true
				Layout.fillWidth: true
				text: "Remove game with files or from ZClient only?"
			}
			RowLayout {
				spacing: 5
				Layout.alignment: Qt.AlignHCenter
				Button {
					text: "Cancel"
					onClicked: dialogRemoveGame.close()
				}
				Button {
					text: "ZClient only"
					onClicked: {
						dialogRemoveGame.close()
						installedGamesList.currentIndex = -1
						zgame.remove(false)
					}
				}
				Button {
					text: "Full remove"
					onClicked: {
						dialogRemoveGame.close()
						installedGamesList.currentIndex = -1
						zgame.remove(true)
					}
					focus: true
				}
			}
		}
	}
	function modeNameBF(mode)
	{
		switch (mode)
		{
			case 'AirSuperiority':
				return qsTr('Air Superiority')
			case 'B2KConquestLarge':
				return qsTr('B2K Conquest Large')
			case 'B2KConquestSmall':
				return qsTr('B2K Conquest Small')
			case 'CaptureTheFlag':
				return qsTr('Capture The Flag')
			case 'CarrierAssaultLarge':
				return qsTr('Carrier Assault Large')
			case 'CarrierAssaultSmall':
				return qsTr('Carrier Assault Small')
			case 'Chainlink':
				return qsTr('Chain Link')
			case 'ConquestAssaultLarge':
				return qsTr('Conquest Assault Large')
			case 'ConquestAssaultSmall':
				return qsTr('Conquest Assault Small')
			case 'ConquestLarge':
				return qsTr('Conquest Large')
			case 'ConquestSmall':
				return qsTr('Conquest Small')
			case 'Domination':
				return qsTr('Domination')
			case 'Elimination':
				return qsTr('Defuse')
			case 'GunMaster':
				return qsTr('Gun Master')
			case 'Obliteration':
				return qsTr('Obliteration')
			case 'RushLarge':
				return qsTr('Rush')
			case 'Scavenger':
				return qsTr('Scavenger')
			case 'SquadDeathMatch':
				return qsTr('Squad Deathmatch')
			case 'SquadRush':
				return qsTr('Squad Rush')
			case 'SquadObliteration':
				return qsTr('Squad Obliteration')
			case 'TeamDeathMatch':
				return qsTr('Team Deathmatch')
			case 'TeamDeathMatchC':
				return qsTr('TDM Close Quarters')
			case 'TankSuperiority':
				return qsTr('Tank Superiority')
			default:
				return mode
		}
	}
}
