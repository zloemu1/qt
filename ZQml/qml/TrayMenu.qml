import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

Window {
	id: rootTray
	visible: false
	width: trayMenu.width
	height: trayMenu.height
//	x: Screen.width - width
	y: Screen.height - height
	flags: Qt.Popup
	Material.theme: Material.Dark
	onActiveFocusItemChanged: if (!activeFocusItem) visible = false
	Menu {
		id: trayMenu
		MenuItem {
			text: qsTr('My Games')
			onTriggered: {
				rootTray.visible = false
				setPage('games')
				if (!rootWindow.visible)
				{
					rootWindow.show()
					rootWindow.requestActivate()
				}
			}
		}
		MenuItem {
			text: qsTr('Downloads')
			onTriggered: {
				rootTray.visible = false
				setPage('downloads')
				if (!rootWindow.visible)
				{
					rootWindow.show()
					rootWindow.requestActivate()
				}
			}
		}
		MenuItem {
			text: qsTr('Library')
			onTriggered: {
				rootTray.visible = false
				setPage('library')
				if (!rootWindow.visible)
				{
					rootWindow.show()
					rootWindow.requestActivate()
				}
			}
		}
		MenuSeparator {}
		MenuItem {
			text: qsTr('Friends')
			onTriggered: {
				rootTray.visible = false
				if (!friendsWindow.visible)
				{
					friendsWindow.show()
					friendsWindow.requestActivate()
				}
			}
		}
		MenuSeparator {}
		MenuItem {
			text: qsTr('Quit')
			onTriggered: Qt.quit()
		}
		onClosed: rootTray.visible = false
	}
	function zshow(xpos)
	{
		trayMenu.popup()
		if (xpos > rootTray.width)
			rootTray.x = Math.min(xpos - rootTray.width / 2, Screen.width - rootTray.width)
		else
			rootTray.x = Screen.width - rootTray.width
		rootTray.show()
		rootTray.requestActivate()
		trayMenu.x = 0
		trayMenu.y = 0
	}
}
