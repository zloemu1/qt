import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import ZGui 1.0

Column {
	Label {
		text: "Sims 4 Gallery config"
	}
	Row {
		spacing: 5
		Label {
			text: 'EA Mail'
		}
		Rectangle {
			width: 300
			height: childrenRect.height
			color: "#3B3B3B"
			TextInput {
				id: login
				anchors.left: parent.left
				anchors.right: parent.right
				font.pointSize: 13
				color: Material.color(Material.Grey)
				selectByMouse: true
				text: ZSims4.getLogin()
			}
		}
	}
	Row {
		spacing: 5
		Label {
			text: 'EA Password'
		}
		Rectangle {
			width: 300
			height: childrenRect.height
			color: "#3B3B3B"
			TextInput {
				id: pass
				anchors.left: parent.left
				anchors.right: parent.right
				font.pointSize: 13
				clip: true
				color: Material.color(Material.Grey)
				echoMode: TextInput.PasswordEchoOnEdit
				selectByMouse: true
			}
		}
	}
	Button {
		text: 'Save'
		onClicked: {
			errTxt.visible = false
			var res = ZSims4.save(login.text, pass.text)
			errCode.visible = true
			switch (res)
			{
				case 0:
					errCode.text = 'Result: OK'
					break;
				case 150:
					errCode.text = 'Cleared'
					break;
				case 253:
				case 254:
					errCode.visible = false
					break;
				default:
					errCode.text = 'Result: ' + res
					break;
			}
		}
	}
	Label {
		id: errCode
		visible: false
	}
	Label {
		id: errTxt
		visible: false
		Connections {
			target: ZSims4
			function onSignalErr(err) { errTxt.visible = true; errTxt.text = err }
		}
	}
}
