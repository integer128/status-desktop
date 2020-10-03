import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import "../imports"
import "../shared/status"
import "./"

ModalPopup {
    id: confirmationDialog

    property Popup parentPopup


    height: 186
    width: 400
    //% "Confirm your action"
    title: qsTrId("confirm-your-action")

    //% "Confirm"
    property string confirmButtonLabel: qsTrId("close-app-button")
    //% "Are you sure you want to this?"
    property string confirmationText: qsTrId("are-you-sure-you-want-to-this-")

    property var value

    signal confirmButtonClicked()

    Text {
        text: confirmationDialog.confirmationText
        color: Style.current.textColor
        font.pixelSize: 15
        anchors.left: parent.left
        anchors.right: parent.right
        wrapMode: Text.WordWrap
    }

    footer: Item {
        id: footerContainer
        width: parent.width
        height: children[0].height

        StatusButton {
            anchors.right: parent.right
            anchors.rightMargin: Style.current.smallPadding
            color: Style.current.red
            text: confirmationDialog.confirmButtonLabel
            anchors.bottom: parent.bottom
            onClicked: confirmationDialog.confirmButtonClicked()
        }
    }
}



