import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 5
		Row {
			spacing: 5
			Button {
				text: qsTr('Back')
				onClicked: showDetails(null)
			}
			Button {
				text: qsTr('Install')
				onClicked: {
					if (ZQt.getInstallLocationsModel().rowCount() > 0)
						libraryView.show(zgame.id, false, zgame.sys)
					else
						setPage('settings')
				}
			}
			Button {
				text: qsTr('From HDD')
				onClicked: folderDialog.show(zgame.id, zgame.sys)
			}
		}
		ScrollView {
			Layout.fillHeight: true
			Layout.fillWidth: true
			id: scrollView
			clip: true
			ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
			ScrollBar.vertical.policy: (scrollView.contentHeight > scrollView.height) ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			ScrollBar.vertical.implicitWidth: 10
			ScrollBar.vertical.contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
			ColumnLayout {
				spacing: 5
				Row {
					spacing: 5
					Image {
						source: zgame.cover
						width: 250
						height: 350
						visible: zgame.cover.length > 0
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
							visible: zgame.lastStart > 0
							text: qsTr('Last run') + ': ' + Qt.formatDateTime(new Date(zgame.lastStart * 1000), 'dd.MM.yyyy hh:mm:ss')
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
							text: qsTr('Remote version') + ': ' + zgame.version
						}
					}
				}
				Label {
					text: zgame.longDescr
					wrapMode: Text.WordWrap
					Layout.maximumWidth: scrollView.width - 15
				}
			}
		}
	}
}
