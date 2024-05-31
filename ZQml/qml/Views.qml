import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

StackLayout {
	clip: true
	Component.onCompleted: changePage(currentIndex)
	onCurrentIndexChanged: changePage(currentIndex)
	property int prev: -1
	function changePage(idx)
	{
		if (prev > -1 && itemAt(prev).pageChange)
			itemAt(prev).pageChange(false)
		if (idx > -1 && itemAt(idx).pageChange)
			itemAt(idx).pageChange(true)
		prev = idx
	}
//
	NewsView {}
	GamesView {}
	DownloadsView {}
	LibraryView {}
	CommunityView {}
	SettingsView {}
	LogView {}
}
