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
		if (compDLC.status === Component.Error) console.log('Create compDLC error ' + compDLC.errorString())
		if (compNews.status === Component.Error) console.log('Create compNews error ' + compNews.errorString())
		if (compAchievements.status === Component.Error) console.log('Create compAchievements error ' + compAchievements.errorString())
		for (var view in zviews)
			if (zviews[view].comp.status === Component.Error)
				console.log('Create ' + view +' error ' + zviews[view].comp.errorString())
	}
	property var gv: null
	property GameData zgame
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
					color: "Gray"
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
					delegate: Text {
						anchors.left: parent ? parent.left : undefined
						anchors.right: parent ? parent.right : undefined
						anchors.rightMargin: installedGamesList.contentHeight > installedGamesList.height ? 10 : 0
						clip: true
						color: "gray"
						text: display.name
						font.pointSize: 13
						MouseArea {
							anchors.fill: parent
							onClicked: installedGamesList.currentIndex = index
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
				font.pointSize: 13
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
}
