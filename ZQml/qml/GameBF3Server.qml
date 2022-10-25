import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Column { //layout will break text with wrap
	property var zsrv: null
	spacing: 5
	Button {
		text: 'Back'
		onClicked: serverDetails(-1)
	}
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		Image {
			source: '/bf3/maps/' + zsrv.level + '.jpg'
			fillMode: Image.PreserveAspectFit
		}
		Text {
			Layout.fillWidth: true
			color: Material.color(Material.Grey)
			font.pixelSize: 15
			text: zsrv.name
			wrapMode: Text.Wrap
		}
	}
	Text {
		anchors.left: parent.left
		anchors.right: parent.right
		color: Material.color(Material.Grey)
		font.pixelSize: 15
		text: zsrv.message
		visible: zsrv.message.length > 0
		wrapMode: Text.Wrap
	}
	Text {
		anchors.left: parent.left
		anchors.right: parent.right
		color: Material.color(Material.Grey)
		font.pixelSize: 15
		text: zsrv.description
		visible: zsrv.description.length > 0
		wrapMode: Text.Wrap
	}
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 3
		Column {
			id: block1
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('osls') + ' ' + zsrv.osls
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('v3ca') + ' ' + zsrv.v3ca
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('v3sp') + ' ' + zsrv.v3sp
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vaba') + ' ' + zsrv.vaba
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vffi') + ' ' + zsrv.vffi
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vhud') + ' ' + zsrv.vhud
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vkca') + ' ' + zsrv.vkca
			}
		}
		Rectangle {
			implicitHeight: block1.height
			width: 3
			color: Material.accent
			radius: 1
		}
		Column {
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vmin') + ' ' + zsrv.vmin
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vmsp') + ' ' + zsrv.vmsp
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vnta') + ' ' + zsrv.vnta
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vrhe') + ' ' + zsrv.vrhe
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vvsa') + ' ' + zsrv.vvsa
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vnit') + ' ' + zsrv.vnit
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vtkc') + ' ' + zsrv.vtkc
			}
		}
		Rectangle {
			implicitHeight: block1.height
			width: 3
			color: Material.accent
			radius: 1
		}
		Column {
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vtkk') + ' ' + zsrv.vtkk
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vbdm') + ' ' + zsrv.vbdm
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vgmc') + ' ' + zsrv.vgmc
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vpmd') + ' ' + zsrv.vpmd
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vprt') + ' ' + zsrv.vprt
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vshe') + ' ' + zsrv.vshe
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: qsTr('vvsd') + ' ' + zsrv.vvsd
			}
		}
		Rectangle {
			implicitHeight: block1.height
			width: 3
			color: Material.accent
			radius: 1
		}
		Column {
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: 'country ' + zsrv.country
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: 'region ' + zsrv.region
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: 'preset ' + zsrv.preset
			}
			Text {
				color: Material.color(Material.Grey)
				font.pixelSize: 15
				text: 'pb ' + zsrv.pb
				visible: zsrv.pb.length > 0
			}
		}
	}
	ListView {
		id: players
		height: contentHeight > 250 ? 250 : contentHeight
		implicitWidth: contentItem.childrenRect.width + (contentHeight > height ? 10 : 0)
		model: zsrv.players
		clip: true
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {
			policy: players.contentHeight > players.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
			implicitWidth: 10
			contentItem: Rectangle {
				color: Material.accent
				radius: 5
			}
		}
		delegate: Text {
			color: Material.color(Material.Grey)
			font.pixelSize: 15
			text: modelData
		}
	}
}
