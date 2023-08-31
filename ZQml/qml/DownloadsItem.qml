import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Rectangle {
	anchors.left: parent ? parent.left : undefined
	anchors.right: parent ? parent.right : undefined
	height: childrenRect.height
	color: "#3D3D3D"
	clip: true
	RowLayout {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 8
		anchors.rightMargin: 8
		spacing: 10
		Label {
			text: display.name
		}
		Button {
			Layout.alignment: Qt.AlignRight
			text: qsTr('Cancel')
			onClicked: ZGames.cancel(decoration.id) //decoration is just another role, because display used in button
		}
	}
}
