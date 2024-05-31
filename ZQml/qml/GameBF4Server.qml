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
	QString bannerurl, country, description, experience, level, levelname, levellocation, maps, mapsinfo, message, mode, preset, pb, region, secret, tickRate, tickRateMax;
	bool aaro, aasl, osls, v3ca, v3sp, vaba, vcmd, vffi, vfrm, vhit, vhud, vicc, vinb, vkca, vmin, vmsp, vnta, vrhe, vsbb, vvsa;
	quint16 gmwp, vmpl, vmst, vnip, vnit, vprb, vprc, vprp, vrlc, vrsp, vrtl, vtbr, vtkc, vtkk; //number
	quint16 vbdm, vgmc, vprt, vshe, vvsd; //percent
	QStringList players;
*/

ScrollView {
	id: scrollView
	clip: true
	ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
	ScrollBar.vertical.policy: ScrollBar.AlwaysOff
	ScrollBar.vertical.implicitWidth: 10
	ScrollBar.vertical.contentItem: Rectangle {
		color: Material.accent
		radius: 5
	}
	property int zwidth
	function zWidthChanged(tmp) {
//		console.log(scrollView.contentHeight + ' ' + scrollView.height + ' ' + scrollView.implicitHeight + ' ' + scrollView.availableHeight + ' ' + tmp)
		if (scrollView.contentHeight > scrollView.height)
		{
			zwidth = scrollView.width - 15
			ScrollBar.vertical.policy = ScrollBar.AlwaysOn
		}
		else
		{
			zwidth = scrollView.width
			ScrollBar.vertical.policy = ScrollBar.AlwaysOff
		}
	}
	onWidthChanged: zWidthChanged(1) //binding loop crutch
	ColumnLayout {
		id: col
		width: zwidth
		spacing: 5
		RowLayout {
			spacing: 3
			Button {
				text: qsTr('Back')
				onClicked: serverDetails(null)
			}
			Item {
				Layout.fillWidth: true
			}
			Button {
				Layout.alignment: Qt.AlignVCenter
				implicitHeight: 50
				implicitWidth: 50
				text: "\ue037"
				font.family: "Material Icons"
				font.pointSize: 15
				onClicked: if (zsrv.secret.length > 0) popupBF4Pass.show(zsrv.id, 0); else runBF4(zsrv.id, 0)
				enabled: ZGames.runnedGame === 0
				ToolTip {
					visible: parent.hovered
					delay: 1000
					text: qsTr('Join')
				}
			}
			Button {
				Layout.alignment: Qt.AlignVCenter
				implicitHeight: 50
				implicitWidth: 50
				text: "\ue8f4"
				font.family: "Material Icons"
				font.pointSize: 15
				onClicked: if (zsrv.secret.length > 0) popupBF4Pass.show(zsrv.id, 1); else runBF4(zsrv.id, 1)
				enabled: ZGames.runnedGame === 0
				ToolTip {
					visible: parent.hovered
					delay: 1000
					text: qsTr('Spectator')
				}
			}
		}
		RowLayout {
			Layout.fillWidth: true
			Image {
				source: '/bf4/maps/' + zsrv.level + '.jpg'
				fillMode: Image.PreserveAspectFit
			}
			Column {
				Layout.fillWidth: true
				Row {
					Label {
						text: '\ue897'
						visible: zsrv.secret.length > 0
					}
					Label {
						text: zsrv.name
						wrapMode: Text.Wrap
					}
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
			Layout.fillWidth: true
			text: zsrv.message
			visible: zsrv.message.length > 0
			wrapMode: Text.Wrap
		}
		Rectangle {
			Layout.fillWidth: true
			color: Material.accent
			height: 3
			radius: 1
			visible: zsrv.message.length > 0
		}
		Label {
			Layout.fillWidth: true
			text: zsrv.description
			visible: zsrv.description.length > 0
			wrapMode: Text.Wrap
		}
		Image {
			source: zsrv.bannerurl
			fillMode: Image.PreserveAspectFit
			visible: zsrv.bannerurl.length
		}
		Rectangle {
			Layout.fillWidth: true
			color: Material.accent
			height: 3
			radius: 1
			visible: zsrv.description.length > 0
		}
		RowLayout {
			Layout.maximumWidth: zwidth
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
				Label {
					color: 'red'
					text: 'PASSWORD'
					visible: zsrv.secret.length > 0
				}
			}
		}
		Rectangle {
			Layout.fillWidth: true
			color: Material.accent
			height: 3
			radius: 1
		}
		ListView {
//			visible: !zsrv.hasKeeper()
			id: players
			implicitHeight: contentItem.childrenRect.height
			Layout.fillWidth: true
			model: zsrv.players
			delegate: TextEdit {
				color: Material.foreground
				font.pointSize: 12
				readOnly: true
				selectByMouse: true
				text: modelData
			}
			onHeightChanged: zWidthChanged(2) //crutch for update scrolls
		}
/*
		ColumnLayout {
			Layout.fillWidth: true
			Row {
				Layout.fillWidth: true
				spacing: 5
				GameBF4Keeper {
					team: zsrv.getKeeper(1)
					visible: team.rowCount() > 0
				}
				GameBF4Keeper {
					team: zsrv.getKeeper(2)
					visible: team.rowCount() > 0
				}
			}
			Row {
				Layout.fillWidth: true
				spacing: 5
				GameBF4Keeper {
					team: zsrv.getKeeper(3)
					visible: team.rowCount() > 0
				}
				GameBF4Keeper {
					team: zsrv.getKeeper(4)
					visible: team.rowCount() > 0
				}
			}
			GameBF4Keeper {
				team: zsrv.getKeeper(0)
				visible: team.rowCount() > 0
			}
		}
*/
	}
}
