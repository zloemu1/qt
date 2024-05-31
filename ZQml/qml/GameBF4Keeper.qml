import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Column {
	property KeeperTeam team: null
	Label {
		text: 'team ' + team.team + ' faction ' + team.faction
	}
	Row {
		spacing: 3
		Label {
			id: labelName
			width: 250
			text: 'Name'
		}
		Label {
			id: labelKills
			width: 75
			text: 'Kills'
			horizontalAlignment: Text.AlignHCenter
		}
		Label {
			id: labelDeaths
			width: 75
			text: 'Deaths'
			horizontalAlignment: Text.AlignHCenter
		}
		Label {
			id: labelScore
			width: 75
			text: 'Score'
			horizontalAlignment: Text.AlignHCenter
		}
	}
	ListView {
		implicitHeight: contentItem.childrenRect.height
		implicitWidth: contentItem.childrenRect.width
		model: team
		delegate: Column {
			Rectangle {
				width: parent.width
				color: Material.accent
				height: 3
				radius: 1
			}
			Row {
				spacing: 3
				Label {
					width: labelName.width
					text: '(' + display.rank + ') ' + display.name
				}
				Label {
					width: labelKills.width
					text: display.kills
					horizontalAlignment: Text.AlignHCenter
				}
				Label {
					width: labelDeaths.width
					text: display.deaths
					horizontalAlignment: Text.AlignHCenter
				}
				Label {
					width: labelScore.width
					text: display.score
					horizontalAlignment: Text.AlignHCenter
				}
			}
		}
		onHeightChanged: zWidthChanged(4) //crutch for update scrolls
	}
}
