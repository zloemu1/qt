import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1 as Platform
import ZGui 1.0

StackLayout {
	property QtLibrary zgame
	function pageChange(vis)
	{
		if (vis)
			ZLibrary.load()
		else
		{
			if (libraryView.currentIndex === 1)
				ZGames.addCancel()
			else if (libraryView.currentIndex === 2)
			{
				libraryViewDetails.active = false
				zgame = null
			}
			libraryView.currentIndex = 0
			ZLibrary.unload()
		}
	}
	id: libraryView
	currentIndex: 0
	clip: true
	LibraryViewMain {}
	LibraryViewAdd {}
	Loader {
		id: libraryViewDetails
		active: false
		source: 'LibraryViewDetails.qml'
	}
//
	property int zid
	property bool fromHdd
	property string folder
	function show(_id, hdd, sys)
	{
		zid = _id
		fromHdd = hdd
		ZQt.getBNet2Model().fill(zid)
		if (bnetCombo.count > 0)
		{
			bnetCombo.currentIndex = bnetCombo.indexOfValue('eu')
			if (bnetCombo.currentIndex < 0)
				bnetCombo.currentIndex = 0
		}
		else
			bnetCombo.currentIndex = -1
		langCombo.currentIndex = ZQt.getModelLangGame().fillGame(zid)
		langCombo.recalculateWidth()
		if (bnetCombo.count < 2 && langCombo.count < 2)
		{
			showDetails(null)
			var res = ZGames.loadInfo(zid, 0)
			if (res === 0)
				popupBusy.show()
			else
				popupError.show('Load info failed: ' + res)
		}
		else
			popupLang.open()
	}
	function showDetails(game)
	{
		if (game !== null)
		{
			zgame = game
			libraryViewDetails.active = true
			libraryView.currentIndex = 2
		}
		else
		{
			libraryViewDetails.active = false
			libraryView.currentIndex = 0
			zgame = game
		}
	}
//
	Platform.FolderDialog {
		id: folderDialog
		property int gid
		property int sys
		function show(_gid, _sys)
		{
			gid = _gid
			sys = _sys
			open()
		}
		onAccepted: {
			libraryView.folder = folder
			if (libraryView.folder.indexOf('file:///') === -1)
				return;
			libraryView.folder = libraryView.folder.replace('file:///', '')
			if (ZQt.isValidPath(libraryView.folder))
				libraryView.show(gid, true, sys)
		}
	}
	Popup {
		id: popupLang
		anchors.centerIn: Overlay.overlay
		dim: true
		modal: true
		ColumnLayout {
			anchors.centerIn: parent
			Label {
				text: 'BNet Gateway'
				font.bold: true
				Layout.alignment: Qt.AlignHCenter
				visible: bnetCombo.count > 0
			}
			ComboBox {
				id: bnetCombo
				model: ZQt.getBNet2Model()
				Layout.alignment: Qt.AlignHCenter
				textRole: 'display'
				valueRole: 'display'
				visible: count > 0
			}
			Label {
				text: qsTr('Language')
				font.bold: true
				Layout.alignment: Qt.AlignHCenter
				visible: langCombo.count > 1
			}
			AutoResizingComboBox {
				id: langCombo
				model: ZQt.getModelLangGame()
				Layout.alignment: Qt.AlignHCenter
				textRole: 'display'
				valueRole: 'edit'
				visible: count > 1
			}
			RowLayout {
				spacing: 5
				Layout.alignment: Qt.AlignHCenter
				Button {
					text: qsTr('Cancel')
					onClicked: popupLang.close()
				}
				Button {
					text: qsTr('Next')
					focus: true
					onClicked: {
						popupLang.close()
						showDetails(null)
						var res = ZGames.loadInfo(libraryView.zid, langCombo.currentValue, (bnetCombo.count > 0) ? bnetCombo.currentValue : '');
						if (res === 0)
							popupBusy.show()
						else
							popupError.show('Load info failed: ' + res)
					}
				}
			}
		}
	}
}
