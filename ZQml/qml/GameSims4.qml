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
				id: mail
				anchors.left: parent.left
				anchors.right: parent.right
				font.pointSize: 13
				color: Material.color(Material.Grey)
				selectByMouse: true
				text: ZSims4.mail
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
				text: ZSims4.pass
			}
		}
	}
	Button {
		text: 'Save'
		onClicked: {
			ZSims4.mail = mail.text
			ZSims4.pass = pass.text
			ZSims4.save()
			var res = ZSims4.testAcc();
			testResult.visible = true
			switch (res)
			{
				case 0:
					testResult.text = 'Result: OK'
					break;
				case 1:
					testResult.text = 'Result: 1'
					break;
				case 2:
					testResult.text = 'Result: 2'
					break;
				case 3:
					testResult.text = 'Result: 3'
					break;
				case 255:
					testResult.visible = false
					break;
				default:
					testResult.text = 'Result: ' + res
					break;
			}
		}
	}
	Label {
		id: testResult
		visible: false
	}
}
