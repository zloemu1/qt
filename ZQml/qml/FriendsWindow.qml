import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import ZGui 1.0

ApplicationWindow {
	property alias statusOwnText: statusText.text
	id: rootFriends
	width: 300
	height: 500
	minimumWidth: 300
	minimumHeight: 500
	visible: false
	title: qsTr('Friends')
	onClosing: visible = false
	Shortcut {
		sequence: "Esc"
		onActivated: visible = false
	}
	Connections {
		target: ZFriendSearch
		function onSignalShowResult() {
			stackLayout.currentIndex = 3
		}
	}
	Menu {
		property Friend user
		id: friendMenu
		function show(id)
		{
			user = ZFriends.get(id)
			menu1.visible = user.game > 0 || ZGames.runnedGame > 0
			menu2.visible = user.game > 0
			menu3.visible = ZGames.runnedGame > 0
			popup()
		}
		MenuItem {
			text: qsTr('Send message')
			onClicked: ZChats.open(friendMenu.user.id, true)
		}
		MenuItem {
			text: qsTr('View profile')
enabled: false
		}
		MenuSeparator
		{
			id: menu1
			height: visible ? implicitHeight : 0
		}
		MenuItem {
			id: menu2
			height: visible ? implicitHeight : 0
			text: qsTr('Join game')
enabled: false
		}
		MenuItem {
			id: menu3
			height: visible ? implicitHeight : 0
			text: qsTr('Invite to game')
enabled: false
		}
		MenuSeparator {}
		MenuItem {
			text: qsTr('Remove')
			onClicked: ZFriends.del(friendMenu.user.id)
		}
	}
	Menu {
		property int user
		id: friendSearchMenu
		MenuItem {
			text: qsTr('View profile')
		}
		MenuItem {
			text: qsTr('Add to friends')
		}
	}
	Menu {
		id: statusMenu
		width: 100
		property int tstatus
		MenuItem {
			text: qsTr('Online')
			onClicked: ZUser.status = 1;
			enabled: statusMenu.tstatus !== 1
		}
		MenuItem {
			text: qsTr('Away')
			onClicked: ZUser.status = 2;
			enabled: statusMenu.tstatus !== 2
		}
		MenuItem {
			text: qsTr('DND')
			onClicked: ZUser.status = 3;
			enabled: statusMenu.tstatus !== 3
		}
		MenuItem {
			text: qsTr('Invisible')
			onClicked: ZUser.status = 0;
			enabled: statusMenu.tstatus !== 0
		}
	}
	Rectangle {
		id: ownStatus
		anchors.left: parent.left
		anchors.right: parent.right
		height: 42
		color: "#333331"
		Image {
			id: avatar
			anchors.left: parent.left
			anchors.top: parent.top
			anchors.topMargin: 5
			anchors.leftMargin: 5
			source: "image://ZAvatar/" + ZUser.id
			width: 32
			height: 32
		}
		Column {
			anchors.left: avatar.right
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.topMargin: 5
			anchors.leftMargin: 5
			Text {
				text: ZUser.name
				color: '#ACACAC'
				font.bold: true
				font.pixelSize: 14
			}
			Row {
				Text {
					id: statusText
					text: rootWindow.onlineStatusStr(ZUser.status, true)
					color: '#ACACAC'
				}
				Text {
					color: '#ACACAC'
					font.family: "Material Icons"
					text: '\ue313'
					MouseArea {
						anchors.fill: parent
						onClicked: {
							statusMenu.tstatus = ZUser.status
							statusMenu.popup()
						}
					}
				}
			}
		}
	}
	StackLayout {
		id: stackLayout
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: ownStatus.bottom
		anchors.bottom: parent.bottom
		currentIndex: 0
		Item {
			Rectangle {
				id: actionBar
				anchors.left: parent.left
				anchors.right: parent.right
				height: 20
				color: "#1B1B1B"
				Text {
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					anchors.leftMargin: 10
					color: '#ACACAC'
					font.bold: true
					text: 'FRIENDS'
				}
				Text {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					anchors.rightMargin: 10
					color: '#ACACAC'
					font.family: "Material Icons"
					font.pixelSize: 16
					text: '\ue7fe'
					MouseArea {
						anchors.fill: parent
						onClicked: {
							friendsSearch.clear()
							stackLayout.currentIndex = 1
						}
					}
				}
			}
			ScrollView {
				id: scrollView
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.top: actionBar.bottom
				anchors.bottom: parent.bottom
				clip: true
				ScrollBar.vertical.policy: scrollView.contentHeight > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
				ScrollBar.vertical.implicitWidth: 10
				ScrollBar.vertical.contentItem: Rectangle {
					color: Material.accent
					radius: 5
				}
				Column {
					width: rootFriends.width - ((scrollView.contentHeight > scrollView.height) ? 5 : 0)
					spacing: 5
					Text {
						anchors.leftMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						visible: friendsGame.count > 0
						text: qsTr('In game') + ' (' + friendsGame.count + ')'
						color: '#ACACAC'
						font.pixelSize: 15
						MouseArea {
							anchors.fill: parent
							onClicked: friendsGame.visible = !friendsGame.visible
						}
					}
					ListView {
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						anchors.left: parent.left
						anchors.right: parent.right
						interactive: false
						spacing: 5
						height: childrenRect.height
						id: friendsGame
						model: ZFriends.inGame
						delegate: FriendItem {}
					}
//
					ToolSeparator {
						anchors.leftMargin: 5
						anchors.rightMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						orientation:  Qt.Horizontal
						visible: friendsOnline.count > 0 && friendsGame.count > 0
					}
					Text {
						anchors.leftMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						visible: friendsOnline.count > 0
						text: qsTr('Online') + ' (' + friendsOnline.count + ')'
						color: '#ACACAC'
						font.pixelSize: 15
						MouseArea {
							anchors.fill: parent
							onClicked: friendsOnline.visible = !friendsOnline.visible
						}
					}
					ListView {
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						anchors.left: parent.left
						anchors.right: parent.right
						interactive: false
						spacing: 5
						height: childrenRect.height
						id: friendsOnline
						model: ZFriends.online
						delegate: FriendItem {}
					}
//
					ToolSeparator {
						anchors.leftMargin: 5
						anchors.rightMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						orientation:  Qt.Horizontal
						visible: friendsOffline.count > 0 && (friendsOnline.count > 0 || friendsGame.count > 0)
					}
					Text {
						anchors.leftMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						visible: friendsOffline.count > 0
						text: qsTr('Offline') + ' (' + friendsOffline.count + ')'
						color: '#ACACAC'
						font.pixelSize: 15
						MouseArea {
							anchors.fill: parent
							onClicked: friendsOffline.visible = !friendsOffline.visible
						}
					}
					ListView {
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						anchors.left: parent.left
						anchors.right: parent.right
						interactive: false
						spacing: 5
						height: childrenRect.height
						id: friendsOffline
						model: ZFriends.offline
						delegate: FriendItem {}
					}
//
					ToolSeparator {
						anchors.leftMargin: 5
						anchors.rightMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						orientation:  Qt.Horizontal
						visible: friendsIncoming.count > 0 && (friendsOffline.count > 0 || friendsOnline.count > 0 || friendsGame.count > 0)
					}
					Text {
						anchors.leftMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						visible: friendsIncoming.count > 0
						text: qsTr('Incoming requests') + ' (' + friendsIncoming.count + ')'
						color: '#ACACAC'
						font.pixelSize: 15
						MouseArea {
							anchors.fill: parent
							onClicked: friendsIncoming.visible = !friendsIncoming.visible
						}
					}
					ListView {
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						anchors.left: parent.left
						anchors.right: parent.right
						interactive: false
						spacing: 5
						height: childrenRect.height
						id: friendsIncoming
						model: ZFriends.incoming
						delegate: FriendItem {}
					}
//
					ToolSeparator {
						anchors.leftMargin: 5
						anchors.rightMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						orientation:  Qt.Horizontal
						visible: friendsOutgoing.count > 0 && (friendsIncoming.count > 0 || friendsOffline.count > 0 || friendsOnline.count > 0 || friendsGame.count > 0)
					}
					Text {
						anchors.leftMargin: 5
						anchors.left: parent.left
						anchors.right: parent.right
						visible: friendsOutgoing.count > 0
						text: qsTr('Outgoing requests') + ' (' + friendsOutgoing.count + ')'
						color: '#ACACAC'
						font.pixelSize: 15
						MouseArea {
							anchors.fill: parent
							onClicked: friendsOutgoing.visible = !friendsOutgoing.visible
						}
					}
					ListView {
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						anchors.left: parent.left
						anchors.right: parent.right
						interactive: false
						spacing: 5
						height: childrenRect.height
						id: friendsOutgoing
						model: ZFriends.outgoing
						delegate: FriendItem {}
					}
					Item {
						width: 1
						height: 5
					}
				}
			}
		}
		Item {
			ColumnLayout {
				anchors.fill: parent
				Item {
					Layout.fillHeight: true
				}
				Text {
					Layout.alignment: Qt.AlignCenter
					color: '#ACACAC'
					text: qsTr('Player name to search')
				}
				Rectangle {
					Layout.alignment: Qt.AlignCenter
					Layout.preferredWidth: 200
					height: childrenRect.height
					color: "#3B3B3B"
					TextInput {
						id: friendsSearch
						anchors.left: parent.left
						anchors.right: parent.right
						font.pointSize: 13
						color: "Gray"
						selectByMouse: true
						focus: true
					}
				}
				Row {
					spacing: 5
					Layout.alignment: Qt.AlignHCenter
					Button {
						text: qsTr('Cancel')
						onClicked: stackLayout.currentIndex = 0
					}
					Button {
						text: qsTr('Search')
						onClicked: if (ZFriendSearch.search(friendsSearch.text)) stackLayout.currentIndex = 2
					}
				}
				Item {
					Layout.fillHeight: true
				}
			}
		}
		BusyIndicator {
			palette.dark: "Gray"
		}
		ColumnLayout {
			ListView {
				Layout.fillHeight: true
				Layout.fillWidth: true
				Layout.leftMargin: 10
				Layout.rightMargin: contentHeight > height ? 0 : 10
				spacing: 5
				id: friendsResult
				model: ZFriendSearch
				clip: true
				boundsBehavior: Flickable.StopAtBounds
				ScrollBar.vertical: ScrollBar {
					policy: friendsResult.contentHeight > friendsResult.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
					implicitWidth: 10
					contentItem: Rectangle {
						color: Material.accent
						radius: 5
					}
				}
				delegate: MouseArea {
					anchors.left: parent ? parent.left : undefined
					anchors.right: parent ? parent.right : undefined
					height: childrenRect.height
					acceptedButtons: Qt.LeftButton | Qt.RightButton
					onClicked: if (mouse.button === Qt.RightButton)
							   {
								   friendSearchMenu.user = display.id
								   friendSearchMenu.popup()
							   }
					onDoubleClicked: if (mouse.button === Qt.LeftButton) console.log('search dblclk ' + display.id)
					Row {
						spacing: 5
						anchors.left: parent.left
						anchors.right: parent.right
						Image {
							source: 'http://avatars.zloemu.net/' + display.id + '.png'
							width: 32
							height: 32
						}
						Column {
							Text {
								text: display.name
								color: '#ACACAC'
								font.bold: true
							}
							MouseArea {
								visible: !display.isFriend
								id: areaAdd
								width:  childrenRect.width
								height: childrenRect.height
								onClicked: {
									ZFriends.add(display.id)
									areaAdd.visible = false
								}
								Row {
									Text {
										color: '#ACACAC'
										font.family: "Material Icons"
										font.pixelSize: 14
										text: '\ue5c9'
									}
									Text {
										color: '#ACACAC'
										text: qsTr('Add to friends')
									}
								}
							}
						}
					}
				}
			}
			Button {
				Layout.alignment: Qt.AlignHCenter
				text: qsTr('Back')
				onClicked: stackLayout.currentIndex = 0
			}
		}
	}
}
