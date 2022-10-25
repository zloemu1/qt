import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import ZGui 1.0

Page {
	anchors.topMargin: 10
	Connections {
		target: ZSteamDumper
		function onSignalLogOn()
		{
			statusLabel.text = 'Auth success'
		}
		function onSignalLogOnFailed(error)
		{
			switch(error)
			{
				case 1:
					statusLabel.text = 'Need steam guard code'
					guardLabel.text = 'Steam guard code'
					guardText.text = ''
					codeRow.visible = true
					break;
				case 2:
					statusLabel.text = 'Need code from mail'
					guardLabel.text = 'Code from mail'
					guardText.text = ''
					codeRow.visible = true
					break;
				case 3:
					statusLabel.text = 'Wrong code'
					guardText.text = ''
					break;
				case 4:
					statusLabel.text = 'Wrong password'
					pass.text = ''
					break;
				case 5: //TryAnotherCM
					statusLabel.text = 'Steam internal error, try again'
					break;
				case 6:
					statusLabel.text = 'Rate limit exceeded'
					break;
				default:
					statusLabel.text = 'Unknown error code: ' + error
					break;
			}
		}
		function onSignalPackagesTotal(total)
		{
			packagesRow.visible = true
			packagesGot.text = '0'
			packagesUnk.text = '0'
			packagesTotal.text = total
		}
		function onSignalPackagesInfo(packages, unknown)
		{
			packagesGot.text = packages
			packagesUnk.text = unknown
		}
		function onSignalAccessTokens(tokens)
		{
			accessTokens.visible = true
			accessTokens.text = 'App tokens ' + tokens
		}
		function onSignalAppsTotal(total)
		{
			appsRow.visible = true
			appsGot.text = '0'
			appsUnk.text = '0'
			appsTotal.text = total
		}
		function onSignalAppsInfo(apps, unknown)
		{
			appsGot.text = apps
			appsUnk.text = unknown
		}
		function onSignalDepotsUser(total)
		{
			depotsRow.visible = true
			depotsTotal.text = total
			depotsNeeded.text = '0'
			depotsGot.text = '0'
			depotsError.text = '0'
		}
		function onSignalDepotsClean(total)
		{
			depotsNeeded.text = total
		}
		function onSignalDepotDecryptionKey(ok, total)
		{
			if (ok)
				depotsGot.text = total
			else
				depotsError.text = total
		}
		function onSignalManifestsUser(total)
		{
			manifestsRow.visible = true
			manifestsTotal.text = total
			manifestsNeeded.text = '0'
			manifestsGotCode.text = '0'
			manifestsErrorCode.text = '0'
			manifestsGot.text = '0'
			manifestsError.text = '0'
		}
		function onSignalManifestsClean(total)
		{
			manifestsNeeded.text = total
		}
		function onSignalManifestCode(ok, total)
		{
			if (ok)
				manifestsGotCode.text = total
			else
				manifestsErrorCode.text = total
		}
		function onSignalManifestData(ok, total)
		{
			if (ok)
				manifestsGot.text = total
			else
				manifestsError.text = total
		}
		function onSignalDone()
		{
			if (codeRow.visible)
				return
			startButton.enabled = true
			stopButton.enabled = false
			loginpass.visible = true
			statusLabel.text = 'DONE'
		}
	}
	Column {
		spacing: 5
		Column {
			id: loginpass
			spacing: 5
			Row {
				spacing: 5
				Label {
					text: 'Login'
					font.pointSize: 13
				}
				Rectangle {
					width: 200
					height: childrenRect.height
					color: "#3B3B3B"
					TextInput {
						id: login
						anchors.left: parent.left
						anchors.right: parent.right
						font.pointSize: 13
						color: Material.color(Material.Grey)
						selectByMouse: true
					}
				}
			}
			Row {
				spacing: 5
				Label {
					text: 'Password'
					font.pointSize: 13
				}
				Rectangle {
					width: 200
					height: childrenRect.height
					color: "#3B3B3B"
					TextInput {
						id: pass
						anchors.left: parent.left
						anchors.right: parent.right
						font.pointSize: 13
						color: Material.color(Material.Grey)
						echoMode: TextInput.PasswordEchoOnEdit
						selectByMouse: true
					}
				}
			}
		}
		Row {
			id: codeRow
			spacing: 5
			visible: false
			Label {
				id: guardLabel
				font.pointSize: 13
			}
			Rectangle {
				width: 200
				height: childrenRect.height
				color: "#3B3B3B"
				TextInput {
					id: guardText
					anchors.left: parent.left
					anchors.right: parent.right
					font.pointSize: 13
					color: Material.color(Material.Grey)
					selectByMouse: true
				}
			}
			Button {
				id: guardButton
				text: 'Continue'
				onClicked: {
					codeRow.visible = false
					if (ZSteamDumper.code(guardText.text))
						return
					loginpass.visible = true
					statusLabel.text = 'Can\'t connect to steam'
				}
			}
		}
		Row {
			spacing: 5
			Button {
				id: startButton
				text: 'Start'
				onClicked: {
					if (!ZSteamDumper.start(login.text, pass.text))
					{
						statusLabel.text = 'Can\'t connect to steam'
						return
					}
					enabled = false
					stopButton.enabled = true
					loginpass.visible = false
					packagesRow.visible = false
					accessTokens.visible = false
					appsRow.visible = false
					depotsRow.visible = false
					manifestsRow.visible = false
				}
			}
			Button {
				id: stopButton
				enabled: false
				text: 'Stop'
				onClicked: {
					enabled = false
					if (codeRow.visible)
					{
						startButton.enabled = true
						loginpass.visible = true
					}
					else
						ZSteamDumper.stop()
				}
			}
		}
		Label {
			id: statusLabel
			font.pointSize: 13
		}
		Row {
			id: packagesRow
			visible: false
			Label {
				text: 'Package info (got/unk/total) '
				font.pointSize: 13
			}
			Label {
				id: packagesGot
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: packagesUnk
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: packagesTotal
				font.pointSize: 13
			}
		}
		Label {
			id: accessTokens
			font.pointSize: 13
			visible: false
		}
		Row {
			id: appsRow
			visible: false
			Label {
				text: 'App info (got/unk/total) '
				font.pointSize: 13
			}
			Label {
				id: appsGot
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: appsUnk
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: appsTotal
				font.pointSize: 13
			}
		}
		Row {
			id: depotsRow
			visible: false
			Label {
				text: 'Depots (total/needed/got/error) '
				font.pointSize: 13
			}
			Label {
				id: depotsTotal
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: depotsNeeded
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: depotsGot
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: depotsError
				font.pointSize: 13
			}
		}
		Row {
			id: manifestsRow
			visible: false
			Label {
				text: 'Manifests (total/needed/got code/code error/got/error) '
				font.pointSize: 13
			}
			Label {
				id: manifestsTotal
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: manifestsNeeded
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: manifestsGotCode
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: manifestsErrorCode
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: manifestsGot
				font.pointSize: 13
			}
			Label {
				text: ' / '
				font.pointSize: 13
			}
			Label {
				id: manifestsError
				font.pointSize: 13
			}
		}
	}
}
