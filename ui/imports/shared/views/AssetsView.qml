import QtQuick 2.13
import QtQuick.Controls 2.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1
import StatusQ.Components 0.1

import SortFilterProxyModel 0.2

import utils 1.0

import "../stores"
import shared.controls 1.0

Item {
    id: root

    property var account
    property bool assetDetailsLaunched: false

    signal assetClicked(var token)

    QtObject {
        id: d
        property int selectedAssetIndex: -1
    }

    height: assetListView.height

    StatusListView {
        id: assetListView
        objectName: "assetViewStatusListView"
        anchors.fill: parent
        model: SortFilterProxyModel {
            sourceModel: account.assets
            filters: [
                ExpressionFilter {
                    expression: visibleForNetworkWithPositiveBalance
                }
            ]
        }

        delegate: TokenDelegate {
            objectName: "AssetView_TokenListItem_" + symbol
            readonly property string balance: enabledNetworkBalance // Needed for the tests
            currentCurrencySymbol: RootStore.currencyStore.currentCurrencySymbol
            width: ListView.view.width
            onClicked: {
                RootStore.getHistoricalDataForToken(symbol, RootStore.currencyStore.currentCurrency)
                d.selectedAssetIndex = index
                assetClicked(model)
            }
            Component.onCompleted: {
                // on Model reset if the detail view is shown, update the data in background.
                if(root.assetDetailsLaunched && index === d.selectedAssetIndex)
                    assetClicked(model)
            }
        }

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
    }
}
