import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

StackLayout {
	id: stack
	function pageChange(vis)
	{
		if (vis)
			ZGameServers.subscribeBF3()
		else
			ZGameServers.unsubscribeBF3()
	}
	property var sv: null
	function serverDetails(idx)
	{
		if (sv !== null)
		{
			sv.destroy()
			sv = null
		}
		if (idx >= 0)
		{
			sv = serverView.createObject(stack, { zsrv: list.model.data(list.model.index(idx, 0), 0) })
			if (sv.status === Component.Error)
				console.log('Create bf3 server view error ' + sv.errorString())
			else
				stack.currentIndex = 1
		}
		else
			stack.currentIndex = 0
	}
	Connections {
		target: ZGameServers
		function onSignalBF3Delete(id) { if (sv !== null && sv.zsrv.id == id) serverDetails(-1) }
	}
	currentIndex: 0
	clip: true
	ListView {
		id: list
		Layout.leftMargin: 10
		Layout.topMargin: 10
		model: ZGameServers
		spacing: 3
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: list.contentHeight > list.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		delegate: Column {
			anchors.rightMargin: list.contentHeight > list.height ? 15 : 10
			anchors.left: parent ? parent.left : undefined
			anchors.right: parent ? parent.right : undefined
			RowLayout {
				anchors.left: parent.left
				anchors.right: parent.right
				MouseArea {
					onClicked: serverDetails(index)
					Layout.fillWidth: true
					height: childrenRect.height
					RowLayout {
						anchors.left: parent.left
						anchors.right: parent.right
						Image {
							Layout.preferredHeight: 50
							Layout.preferredWidth: paintedWidth
							source: '/bf3/maps/' + display.level + '.jpg'
							fillMode: Image.PreserveAspectFit
						}
						Column {
							Layout.fillWidth: true
							Text {
								color: Material.color(Material.Grey)
								font.pixelSize: 15
								text: display.name
								wrapMode: Text.Wrap
							}
							Text {
								color: Material.color(Material.Grey)
								font.pixelSize: 15
								text: display.levelname + ' | ' + display.mode
							}
						}
						Rectangle {
							implicitHeight: 50
							implicitWidth: 50
							Text {
								text: display.players.length + ' / ' + display.PMAX
								anchors.centerIn: parent
							}
						}
					}
				}
				Button {
					implicitHeight: 50
					implicitWidth: 50
					text: "\ue037"
					font.family: "Material Icons"
					font.pointSize: 15
					onClicked: ZGameServers.startBF3(zgame.id, decoration.id)
					enabled: ZGames.runnedGame === 0
				}
			}
		}
	}
	Component {
		id: serverView
		GameBF3Server {
		}
	}
}
