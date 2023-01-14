import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

/*
	QString name;
	quint32 id, GSET, TCAP;
	quint8 GSTA, PMAX, QCAP, PCAP;
	QString bannerurl, country, description, level, levelname, levellocation, maps, mapsinfo, message, mod, mode, preset, pb, region;
	bool osls, v3ca, v3sp, vaba, vffi, vhud, vkca, vmin, vmsp, vnta, vrhe, vvsa;
	quint16 gmwp, vnit, vrtm, vtkc, vtkk; //number
	quint16 vbdm, vgmc, vpmd, vprt, vshe, vvsd; //percent
	QStringList players;
*/

Column { //layout will break text with wrap
	anchors.left: parent.left
	anchors.right: parent.right
//	anchors.fill: parent
	anchors.rightMargin: scrollView.contentHeight > scrollView.height ? 10 : 0
	spacing: 5
	Component.onCompleted: scrollView.contentHeight = height
	RowLayout {
		spacing: 3
		anchors.left: parent.left
		anchors.right: parent.right
		Button {
			text: 'Back'
			onClicked: serverDetails(null)
		}
		Button {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
			implicitHeight: 50
			implicitWidth: 50
			text: "\ue037"
			font.family: "Material Icons"
			font.pointSize: 15
			onClicked: ZGameServers.startBF3(zgame.id, zsrv.id)
			enabled: ZGames.runnedGame === 0
			ToolTip {
				visible: parent.hovered
				delay: 1000
				text: qsTr('Join')
			}
		}
	}
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		Image {
			source: '/bf3/maps/' + zsrv.level + '.jpg'
			fillMode: Image.PreserveAspectFit
		}
		Column {
			Layout.fillWidth: true
			Label {
				text: zsrv.name
				wrapMode: Text.Wrap
			}
			Label {
				text: modeNameBF(zsrv.mode)
			}
			Label {
				text: zsrv.levelname
			}
		}
	}
	Label {
		anchors.left: parent.left
		anchors.right: parent.right
		text: zsrv.message
		visible: zsrv.message.length > 0
		wrapMode: Text.Wrap
	}
	Label {
		anchors.left: parent.left
		anchors.right: parent.right
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
			Label {
				text: qsTr('osls') + ' ' + zsrv.osls
			}
			Label {
				text: qsTr('v3ca') + ' ' + zsrv.v3ca
			}
			Label {
				text: qsTr('v3sp') + ' ' + zsrv.v3sp
			}
			Label {
				text: qsTr('vaba') + ' ' + zsrv.vaba
			}
			Label {
				text: qsTr('vffi') + ' ' + zsrv.vffi
			}
			Label {
				text: qsTr('vhud') + ' ' + zsrv.vhud
			}
			Label {
				text: qsTr('vkca') + ' ' + zsrv.vkca
			}
			Label {
				text: qsTr('vmin') + ' ' + zsrv.vmin
			}
		}
		Rectangle {
			implicitHeight: block1.height
			width: 3
			color: Material.accent
			radius: 1
		}
		Column {
			Label {
				text: qsTr('vmsp') + ' ' + zsrv.vmsp
			}
			Label {
				text: qsTr('vnta') + ' ' + zsrv.vnta
			}
			Label {
				text: qsTr('vrhe') + ' ' + zsrv.vrhe
			}
			Label {
				text: qsTr('vvsa') + ' ' + zsrv.vvsa
			}
			Label {
				text: qsTr('gmwp') + ' ' + zsrv.gmwp
			}
			Label {
				text: qsTr('vnit') + ' ' + zsrv.vnit
			}
			Label {
				text: qsTr('vrtm') + ' ' + zsrv.vrtm
			}
			Label {
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
			Label {
				text: qsTr('vtkk') + ' ' + zsrv.vtkk
			}
			Label {
				text: qsTr('vbdm') + ' ' + zsrv.vbdm
			}
			Label {
				text: qsTr('vgmc') + ' ' + zsrv.vgmc
			}
			Label {
				text: qsTr('vpmd') + ' ' + zsrv.vpmd
			}
			Label {
				text: qsTr('vprt') + ' ' + zsrv.vprt
			}
			Label {
				text: qsTr('vshe') + ' ' + zsrv.vshe
			}
			Label {
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
			Label {
				text: 'country ' + zsrv.country
			}
			Label {
				text: 'region ' + zsrv.region
			}
			Label {
				text: 'preset ' + zsrv.preset
			}
			Label {
				text: 'pb ' + zsrv.pb
				visible: zsrv.pb.length > 0
			}
		}
	}
	ListView {
		id: players
		implicitHeight: contentHeight
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
		delegate: TextEdit {
			color: Material.foreground
			font.pointSize: 12
			readOnly: true
			selectByMouse: true
			text: modelData
		}
	}
}
