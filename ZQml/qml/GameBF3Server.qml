import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

/*
	QString name;
	quint32 id, GSET, TCAP;
	quint8 GSTA, PMAX, QCAP, PCAP;
	QString bannerurl, country, description, level, levelname, levellocation, maps, mapsinfo, message, mod, mode, preset, pb, region, secret;
	bool osls, v3ca, v3sp, vaba, vffi, vhud, vkca, vmin, vmsp, vnta, vrhe, vvsa;
	quint16 gmwp, vnit, vrtm, vtkc, vtkk; //number
	quint16 vbdm, vgmc, vpmd, vprt, vshe, vvsd; //percent
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
				onClicked: if (zsrv.secret.length > 0) popupBF3Pass.show(zsrv.id); else runBF3(zsrv.id, 0)
//				onClicked: console.log(col.height + ' ' + col.width + ' | ' + scrollView.height + ' ' + scrollView.width + ' | ' + stack.height + ' ' + stack.width)
				enabled: ZGames.runnedGame === 0
				ToolTip {
					visible: parent.hovered
					delay: 1000
					text: qsTr('Join')
				}
			}
		}
		RowLayout {
			Layout.fillWidth: true
			Image {
				source: '/bf3/maps/' + zsrv.level + '.jpg'
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
	}
}
