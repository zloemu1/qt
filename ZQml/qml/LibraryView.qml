import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

StackLayout {
	function pageChange(vis)
	{
		if (vis)
			ZLibrary.load()
		else
		{
			if (libraryView.currentIndex > 0)
			{
				ZGames.addCancel()
				libraryView.currentIndex = 0
			}
			ZLibrary.unload()
		}
	}
	id: libraryView
	currentIndex: 0
	clip: true
	LibraryViewMain {}
	LibraryViewAdd {}
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
			var res = ZGames.loadInfo(zid, 0)
			if (res === 0)
				popupBusy.show()
			else
				popupError.show('Load info failed: ' + res)
		}
		else
			popupLang.open()
	}
//
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
