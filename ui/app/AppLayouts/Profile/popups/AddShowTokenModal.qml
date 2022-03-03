import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.3

import utils 1.0

import StatusQ.Controls 0.1
import StatusQ.Popups 0.1

import shared.controls 1.0
import "../stores"

StatusModal {
    id: popup

    property bool editable: true
    property int marginBetweenInputs: 35
    property string validationError: ""
    property WalletStore walletStore

    header.title: editable ?
        //% "Add custom token"
        qsTrId("add-custom-token")
        : nameInput.text

    x: Math.round(((parent ? parent.width : 0) - width) / 2)
    y: Math.round(((parent ? parent.height : 0) - height) / 2)

    height: editable ? 450 : 380

    onOpened: {
        addressInput.forceActiveFocus(Qt.MouseFocusReason)
    }

    function openEditable(){
        addressInput.text = "";
        nameInput.text = "";
        symbolInput.text = "";
        decimalsInput.text = "";
        editable = true;
        open();
    }

    function openWithData(address, name, symbol, decimals){
        addressInput.text = address;
        nameInput.text = name;
        symbolInput.text = symbol;
        decimalsInput.text = decimals;
        editable = false;
        open();
    }


    function validate() {
        if (addressInput.text !== "" && !Utils.isAddress(addressInput.text)) {
            //% "This needs to be a valid address"
            validationError = qsTrId("this-needs-to-be-a-valid-address");
        }
        return validationError === ""
    }

    property var getTokenDetails: Backpressure.debounce(popup, 500, function (tokenAddress){
        popup.walletStore.walletTokensModule.getTokenDetails(tokenAddress)
    });

    function onKeyReleased(){
        validationError = "";
        if (!validate() || addressInput.text === "") {
            return;
        }
        Qt.callLater(getTokenDetails, addressInput.text)
    }

    Connections {
        target: popup.walletStore.walletTokensModule
        onTokenDetailsWereResolved: {
            const jsonObj = JSON.parse(tokenDetails)
            if (jsonObj.error) {
                validationError = jsonObj.error
                return
            }
            if (jsonObj.name === "" && jsonObj.symbol === "" && jsonObj.decimals === "") {
                //% "Invalid ERC20 address"
                validationError = qsTrId("invalid-erc20-address")
                return;
            }

            if (addressInput.text.toLowerCase() === jsonObj.address.toLowerCase()) {
                symbolInput.text = jsonObj.symbol;
                decimalsInput.text = jsonObj.decimals;
                nameInput.text = jsonObj.name;
            }
        }
    }

    contentItem: Item {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Style.current.padding
        anchors.rightMargin: Style.current.padding
        Input {
            id: addressInput
            readOnly: !editable
            textField.maximumLength: 42
            //% "Enter contract address..."
            placeholderText: qsTrId("enter-contract-address...")
            //% "Contract address"
            label: qsTrId("contract-address")
            validationError: popup.validationError
            Keys.onReleased: onKeyReleased()
        }

        Input {
            id: nameInput
            readOnly: !editable
            anchors.top: addressInput.bottom
            anchors.topMargin: marginBetweenInputs
            //% "The name of your token..."
            placeholderText: qsTrId("the-name-of-your-token...")
            //% "Name"
            label: qsTrId("name")
        }

        Input {
            id: symbolInput
            readOnly: !editable
            //% "ABC"
            placeholderText: qsTrId("abc")
            //% "Symbol"
            label: qsTrId("symbol")
            anchors.top: nameInput.bottom
            anchors.topMargin: marginBetweenInputs
            anchors.left: parent.left
            anchors.right: undefined
            width: parent.width / 2 - 20
        }

        Input {
            id: decimalsInput
            readOnly: !editable
            placeholderText: "18"
            //% "Decimals"
            label: qsTrId("decimals")
            text: "18"
            anchors.top: nameInput.bottom
            anchors.topMargin: marginBetweenInputs
            anchors.right: parent.right
            anchors.left: undefined
            width: parent.width / 2 - 20
        }
    }

    MessageDialog {
        id: changeError
        title: qsTr("Changing settings failed")
        icon: StandardIcon.Critical
        standardButtons: StandardButton.Ok
    }

    rightButtons: [
        StatusButton {
            //% "Add"
            text: qsTrId("add")
            enabled: validationError === "" && addressInput.text !== "" && nameInput.text !== "" && symbolInput.text !== "" && decimalsInput.text !== ""
            visible: editable
            onClicked: {
                const error = popup.walletStore.addCustomToken(0, addressInput.text, nameInput.text, symbolInput.text, decimalsInput.text);

                if (error) {
                    Global.playErrorSound();
                    changeError.text = error;
                    changeError.open();
                    return;
                }
                popup.close();
            }
        }
    ]
}