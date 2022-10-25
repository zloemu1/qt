import QtQuick 2.0
import QtQuick.Controls 2.15
import ZGui 1.0

Page {
	id: rootGameView
	function pageChange(vis) {
		if (!vis)
			return
		ZGames.getDLCModel().load(zgame.id)
		ZNews.filter(zgame.id)
		ZAchievements.load(zgame.id)
	}
	property variant comps: []
	Component.onCompleted: {
		var tcomp = rootGamesView.compInfo.createObject(viewGame)
		if (tcomp.status === Component.Error)
			console.log('Create info view error ' + tcomp.errorString())
		else
		{
			comps.push(gameViewMenuButton.createObject(topbarGame, {text: qsTr('Info')}))
			comps.push(tcomp)
		}
//
		ZGames.select(zgame.id)
		if (ZGames.getDLCModel().load(zgame.id))
		{
			if (rootGamesView.compDLC.status === Component.Error)
				console.log('Additional content view error ' + rootGamesView.compDLC.errorString())
			else
			{
				tcomp = rootGamesView.compDLC.createObject(viewGame)
				if (tcomp.status === Component.Error)
					console.log('Create additional content view error ' + tcomp.errorString())
				else
				{
					comps.push(gameViewMenuButton.createObject(topbarGame, {text: qsTr('Additional content')}))
					comps.push(tcomp)
				}
			}
		}
//
		if (ZNews.filter(zgame.id))
		{
			tcomp = rootGamesView.compNews.createObject(viewGame)
			if (tcomp.status === Component.Error)
				console.log('Create news view error ' + tcomp.errorString())
			else
			{
				comps.push(gameViewMenuButton.createObject(topbarGame, {text: qsTr('News')}))
				comps.push(tcomp)
			}
		}
//
		if (ZAchievements.load(zgame.id))
		{
			tcomp = rootGamesView.compAchievements.createObject(viewGame)
			if (tcomp.status === Component.Error)
				console.log('Create achievements view error ' + tcomp.errorString())
			else
			{
				comps.push(gameViewMenuButton.createObject(topbarGame, {text: qsTr('Achievements')}))
				comps.push(tcomp)
			}
		}
//
		for(var i = 0; i < zgame.views.length; ++i)
		{
			if (!(zgame.views[i] in rootGamesView.zviews))
			{
				console.log('Unknown view ' + zgame.views[i])
				continue
			}
			tcomp = rootGamesView.zviews[zgame.views[i]].comp.createObject(viewGame)
			if (tcomp.status === Component.Error)
				console.log('Create ' + zgame.views[i] + ' view error ' + tcomp.errorString())
			else
			{
				comps.push(gameViewMenuButton.createObject(topbarGame, {text: rootGamesView.zviews[zgame.views[i]]['tab']}))
				comps.push(tcomp)
			}
		}
		topbarGame.visible = comps.length > 2
	}
	function kill()
	{
		topbarGame.setCurrentIndex(-1)
		for(var i = 0; i < comps.length; ++i)
			comps[i].destroy()
		ZGames.getDLCModel().unload()
		ZAchievements.unload()
		viewGame.changePage(-1)
	}
	Component {
		id: gameViewMenuButton
		TabButton {
			width: implicitWidth
		}
	}
	header: TabBar {
		id: topbarGame
		currentIndex: viewGame.currentIndex
		font.pointSize: 13
		font.family: rootWindow.font.name
	}
	SwipeView {
		id: viewGame
		currentIndex: topbarGame.currentIndex
		anchors.fill: parent
		anchors.topMargin: 5
		clip: true
		interactive: false
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
	}
}
