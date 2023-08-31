import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	ColumnLayout {
		anchors.fill: parent
		Row {
			Layout.alignment: Qt.AlignHCenter
			spacing: 3
			Button {
				property bool param: true
				text: param ? qsTr('Sort by date') : qsTr('Sort by name')
				onClicked: {
					param = !param
					ZAchievements.resort(param)
				}
				visible: ZAchievements.achieved > 0
			}
			Button {
				property int param: 0
				text: qsTr('All')
				onClicked: {
					if (++param > 2)
						param = 0
					switch(param)
					{
						case 0:
							text = qsTr('All')
							break;
						case 1:
							text = qsTr('Achieved')
							break;
						case 2:
							text = qsTr('Closed')
							break;
					}
					ZAchievements.filter(param)
				}
				visible: ZAchievements.achieved > 0 && ZAchievements.achieved != ZAchievements.total
			}
		}
		Row {
			Layout.alignment: Qt.AlignHCenter
			Label {
				text: qsTr('Hidden') + ' ' + ZAchievements.hidden + ' / '
				visible: ZAchievements.hidden > 0
				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.MiddleButton
					onDoubleClicked: ZAchievements.showHidden()
				}
			}
			Label {
				text: qsTr('Achieved') + ' ' + ZAchievements.achieved + ' / '
			}
			Label {
				text: qsTr('Total') + ' ' + ZAchievements.total
			}
		}
		ListView {
			id: list
			clip: true
			Layout.fillHeight: true
			Layout.fillWidth: true
			model: ZAchievements
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {
				policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
				implicitWidth: 10
				contentItem: Rectangle {
					color: Material.accent
					radius: 5
				}
			}
			delegate: GameAchievement {
				anchors.rightMargin: list.contentHeight > list.height ? 15 : 10
			}
		}
	}
}
