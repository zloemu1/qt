import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	ColumnLayout {
		anchors.fill: parent
		Text {
			text: ZAchievements.achieved + ' / ' + ZAchievements.total
			color: Material.color(Material.Grey)
			font.pixelSize: 15
			Layout.alignment: Qt.AlignHCenter
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
