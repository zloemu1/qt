import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import QtQml.Models 2.15
import ZGui 1.0

/*
	QString name;
	quint32 id, GSET, GMRG;
	quint8 GSTA, PMAX, QCAP, PCAP0, PCAP1, PCAP2, PCAP3;
	QString bannerurl, country, description, experience, level, levelname, levellocation, maps, mapsinfo, message, mode, preset, pb, region, tickRate, tickRateMax;
	bool aaro, aasl, osls, v3ca, v3sp, vaba, vcmd, vffi, vfrm, vhit, vhud, vicc, vinb, vkca, vmin, vmsp, vnta, vrhe, vsbb, vvsa;
	quint16 gmwp, vmpl, vmst, vnip, vnit, vprb, vprc, vprp, vrlc, vrsp, vrtl, vtbr, vtkc, vtkk; //number
	quint16 vbdm, vgmc, vprt, vshe, vvsd; //percent
	QStringList players;
*/

Column { //layout will break text with wrap
	anchors.left: parent.left
	anchors.right: parent.right
//	anchors.fill: parent
	anchors.rightMargin: scrollView.contentHeight > scrollView.height ? 10 : 0
	spacing: 5
//	id: derproot
	Component.onCompleted: scrollView.contentHeight = height
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		Button {
			text: 'Back'
			onClicked: serverDetails(null)
		}
/*
		Button {
			text: 'debug'
			onClicked: {
				console.log(scrollView.height + ' ' + scrollView.availableHeight + ' ' + scrollView.contentHeight + '] [' + derproot.height)
			}
		}
*/
		Row {
			spacing: 3
			Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
			Button {
				implicitHeight: 50
				implicitWidth: 50
				text: "\ue037"
				font.family: "Material Icons"
				font.pointSize: 15
				onClicked: ZGameServers.startBF4(zgame.id, zsrv.id, 0)
				enabled: ZGames.runnedGame === 0
				ToolTip {
					visible: parent.hovered
					delay: 1000
					text: qsTr('Join')
				}
			}
			Button {
				implicitHeight: 50
				implicitWidth: 50
				text: "\ue8f4"
				font.family: "Material Icons"
				font.pointSize: 15
				onClicked: ZGameServers.startBF4(zgame.id, zsrv.id, 1)
				enabled: ZGames.runnedGame === 0
				ToolTip {
					visible: parent.hovered
					delay: 1000
					text: qsTr('Spectator')
				}
			}
		}
	}
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		Image {
			source: '/bf4/maps/' + zsrv.level + '.jpg'
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
				text: qsTr('aaro') + ' ' + zsrv.aaro
			}
			Label {
				text: qsTr('aasl') + ' ' + zsrv.aasl
			}
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
				text: qsTr('vcmd') + ' ' + zsrv.vcmd
			}
			Label {
				text: qsTr('vffi') + ' ' + zsrv.vffi
			}
			Label {
				text: qsTr('vfrm') + ' ' + zsrv.vfrm
			}
			Label {
				text: qsTr('vhit') + ' ' + zsrv.vhit
			}
			Label {
				text: qsTr('vhud') + ' ' + zsrv.vhud
			}
			Label {
				text: qsTr('vicc') + ' ' + zsrv.vicc
			}
			Label {
				text: qsTr('vinb') + ' ' + zsrv.vinb
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
				text: qsTr('vkca') + ' ' + zsrv.vkca
			}
			Label {
				text: qsTr('vmin') + ' ' + zsrv.vmin
			}
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
				text: qsTr('vsbb') + ' ' + zsrv.vsbb
			}
			Label {
				text: qsTr('vvsa') + ' ' + zsrv.vvsa
			}
			Label {
				text: qsTr('gmwp') + ' ' + zsrv.gmwp
			}
			Label {
				text: qsTr('vmpl') + ' ' + zsrv.vmpl
			}
			Label {
				text: qsTr('vmst') + ' ' + zsrv.vmst
			}
			Label {
				text: qsTr('vnip') + ' ' + zsrv.vnip
			}
			Label {
				text: qsTr('vnit') + ' ' + zsrv.vnit
			}
			Label {
				text: qsTr('vprb') + ' ' + zsrv.vprb
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
				text: qsTr('vprc') + ' ' + zsrv.vprc
			}
			Label {
				text: qsTr('vprp') + ' ' + zsrv.vprp
			}
			Label {
				text: qsTr('vrlc') + ' ' + zsrv.vrlc
			}
			Label {
				text: qsTr('vrsp') + ' ' + zsrv.vrsp
			}
			Label {
				text: qsTr('vrtl') + ' ' + zsrv.vrtl
			}
			Label {
				text: qsTr('vtbr') + ' ' + zsrv.vtbr
			}
			Label {
				text: qsTr('vtkc') + ' ' + zsrv.vtkc
			}
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
			Label {
				text: 'tickRate ' + zsrv.tickRate
			}
			Label {
				text: 'tickRateMax ' + zsrv.tickRateMax
			}
		}
	}
	ListView {
//		visible: !zsrv.hasKeeper()
		id: players
		implicitHeight: contentHeight
//		height: contentHeight > 250 ? 250 : contentHeight
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
/*
	ListView {
		anchors.left: parent.left
		anchors.right: parent.right
		visible: zsrv.hasKeeper()
		model: zsrv.getKeeper()
		implicitWidth: contentItem.childrenRect.width
		orientation: ListView.Horizontal
		delegate: Column {
			anchors.fill: parent
			HorizontalHeaderView {
				anchors.left: parent.left
				anchors.right: parent.right
				syncView: tableView
				clip: true
				model: display
				delegate: Label {
					text: display
				}
			}
			TableView {
				anchors.left: parent.left
				anchors.right: parent.right
				id: tableView
				columnSpacing: 1
				rowSpacing: 1
				model: display
				delegate: Label {
					text: display
				}
			}
		}
	}
*/
}
