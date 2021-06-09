import QtQuick 2.14
import QtQuick.Controls 2.14

import StatusQ.Core 0.1
import StatusQ.Core.Theme 0.1
import StatusQ.Controls 0.1
import StatusQ.Components 0.1
import StatusQ.Layout 0.1
import StatusQ.Popups 0.1

Rectangle {
    id: demoApp
    height: 602
    width: 902
    border.width: 1
    border.color: Theme.palette.baseColor2

    Row {
        anchors.top: demoApp.top
        anchors.left: demoApp.left
        anchors.topMargin: 14
        anchors.leftMargin: 14

        spacing: 6
        z: statusAppLayout.z + 1

        Rectangle {
            color: "#E24640"
            height: 12
            width: 12
            radius: 6
        }
        Rectangle {
            color: "#FFC12F"
            height: 12
            width: 12
            radius: 6
        }
        Rectangle {
            color: "#2ACB42"
            height: 12
            width: 12
            radius: 6
        }
    }


    StatusAppLayout {
        id: statusAppLayout
        anchors.top: demoApp.top
        anchors.left: demoApp.left
        anchors.topMargin: demoApp.border.width
        anchors.leftMargin: demoApp.border.width

        height: demoApp.height - demoApp.border.width * 2
        width: demoApp.width - demoApp.border.width * 2

        appNavBar: StatusAppNavBar {

            navBarChatButton: StatusNavBarTabButton {
                icon.name: "chat"
                tooltip.text: "Chat"
                checked: appView.sourceComponent == statusAppChatView
                onClicked: {
                    appView.sourceComponent = statusAppChatView
                }
            }

            navBarCommunityTabButtons.model: ListModel {
                ListElement {
                    name: "Status Community"
                    tooltipText: "Status Community"
                }
            }

            navBarCommunityTabButtons.delegate: StatusNavBarTabButton {
                anchors.horizontalCenter: parent.horizontalCenter
                name: model.name
                tooltip.text: model.tooltipText
                icon.color: Theme.palette.miscColor6
                icon.source: "https://pbs.twimg.com/profile_images/1369221718338895873/T_5fny6o_400x400.jpg"
                checked: appView.sourceComponent == statusAppCommunityView
                onClicked: {
                    appView.sourceComponent = statusAppCommunityView
                }
            }

            navBarTabButtons: [
                StatusNavBarTabButton {
                    icon.name: "wallet"
                    tooltip.text: "Wallet"
                },
                StatusNavBarTabButton {
                    icon.name: "browser"
                    tooltip.text: "Browser"
                },
                StatusNavBarTabButton {
                    icon.name: "status-update"
                    tooltip.text: "Timeline"
                },
                StatusNavBarTabButton {
                    id: profileNavButton
                    icon.name: "profile"
                    badge.visible: true
                    badge.anchors.rightMargin: 4
                    badge.anchors.topMargin: 5
                    badge.border.color: hovered ? Theme.palette.statusBadge.hoverBorderColor : Theme.palette.statusAppNavBar.backgroundColor
                    badge.border.width: 2

                    tooltip.text: "Profile"
                }
            ]
        }

        appView: Loader {
            id: appView
            anchors.fill: parent
            sourceComponent: statusAppChatView
        }
    }

    Component {
        id: statusAppChatView

        StatusAppTwoPanelLayout {

            leftPanel: Item {
                anchors.fill: parent

                StatusChatList {
                    anchors.top: parent.top
                    anchors.topMargin: 64
                    anchors.horizontalCenter: parent.horizontalCenter

                    selectedChatId: "0"
                    chatListItems.model: demoChatListItems
                    onChatItemSelected: selectedChatId = id
                    onChatItemUnmuted: {
                        for (var i = 0; i < demoChatListItems.count; i++) {
                            let item = demoChatListItems.get(i);
                            if (item.chatId === id) {
                                demoChatListItems.setProperty(i, "muted", false)
                            }
                        }
                    }
                }
            }

            rightPanel: Item {
                anchors.fill: parent

                StatusChatToolBar {
                    anchors.top: parent.top
                    width: parent.width

                    chatInfoButton.title: "Amazing Funny Squirrel"        
                    chatInfoButton.subTitle: "Contact"
                    chatInfoButton.icon.color: Theme.palette.miscColor7
                    chatInfoButton.type: StatusChatInfoButton.Type.OneToOneChat
                    chatInfoButton.pinnedMessagesCount: 1

                    notificationCount: 1

                    onNotificationButtonClicked: notificationCount = 0

                    popupMenu: StatusPopupMenu {
                        id: contextMenu

                        StatusMenuItem {
                            text: "Mute Chat"
                            icon.name: "notification"
                        }
                        StatusMenuItem {
                            text: "Mark as Read"
                            icon.name: "checkmark-circle"
                        }
                        StatusMenuItem {
                            text: "Clear History"
                            icon.name: "close-circle"
                        }

                        StatusMenuSeparator {}

                        StatusMenuItem {
                            text: "Leave Chat"
                            icon.name: "arrow-right"
                            icon.width: 14
                            iconRotation: 180
                            type: StatusMenuItem.Type.Danger
                        }
                    }
                }

            }
        }
    }

    Component {
        id: statusAppCommunityView

        StatusAppTwoPanelLayout {

            leftPanel: Item {
                anchors.fill: parent

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 64
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 4

                    StatusChatList {
                        id: statusChatList
                        anchors.horizontalCenter: parent.horizontalCenter
                        chatListItems.model: demoCommunityChatListItems
                    }

                    StatusChatListCategory {
                        name: "Public"

                        chatList.chatListItems.model: demoCommunityChatListItems
                        chatList.selectedChatId: "0"
                        chatList.onChatItemSelected: chatList.selectedChatId = id
                        popupMenu: categoryPopupCmp
                    }

                    StatusChatListCategory {
                        name: "Development"

                        chatList.chatListItems.model: demoCommunityChatListItems
                        chatList.onChatItemSelected: chatList.selectedChatId = id
                        popupMenu: categoryPopupCmp
                    }
                }

                Component {
                    id: categoryPopupCmp

                    StatusPopupMenu {
                        StatusMenuItem {
                            text: "Mute Category"
                            icon.name: "notification"
                        }

                        StatusMenuItem { 
                            text: "Mark as Read"
                            icon.name: "checkmark-circle"
                        }

                        StatusMenuItem { 
                            text: "Edit Category"
                            icon.name: "edit"
                        }

                        StatusMenuSeparator {}

                        StatusMenuItem {
                            text: "Delete Category"
                            icon.name: "delete"
                            type: StatusMenuItem.Type.Danger
                        }
                    }
                }
            }
            rightPanel: Item {
                anchors.fill: parent

                StatusChatToolBar {
                    anchors.top: parent.top
                    width: parent.width

                    chatInfoButton.title: "general"        
                    chatInfoButton.subTitle: "Community Chat"
                    chatInfoButton.icon.color: Theme.palette.miscColor6
                    chatInfoButton.type: StatusChatInfoButton.Type.CommunityChat
                }
            }
        }
    }

    ListModel {
        id: demoChatListItems
        ListElement {
            chatId: "0"
            name: "#status"
            chatType: StatusChatListItem.Type.PublicChat
            muted: false
            hasUnreadMessages: false
            hasMention: false
            unreadMessagesCount: 0
            iconColor: "blue"
        }
        ListElement {
            chatId: "1"
            name: "#status-desktop"
            chatType: StatusChatListItem.Type.PublicChat
            muted: false
            hasUnreadMessages: true
            iconColor: "red"
            unreadMessagesCount: 1
        }
        ListElement {
            chatId: "2"
            name: "Amazing Funny Squirrel"
            chatType: StatusChatListItem.Type.OneToOneChat
            muted: false
            hasUnreadMessages: false
            iconColor: "green"
            identicon: "https://pbs.twimg.com/profile_images/1369221718338895873/T_5fny6o_400x400.jpg"
            unreadMessagesCount: 0
        }
        ListElement {
            chatId: "3"
            name: "Black Ops"
            chatType: StatusChatListItem.Type.GroupChat
            muted: false
            hasUnreadMessages: false
            iconColor: "purple"
            unreadMessagesCount: 0
        }
        ListElement {
            chatId: "4"
            name: "Spectacular Growing Otter"
            chatType: StatusChatListItem.Type.OneToOneChat
            muted: true
            hasUnreadMessages: false
            iconColor: "Orange"
            unreadMessagesCount: 0
        }
    }

    ListModel {
        id: demoCommunityChatListItems
        ListElement {
            chatId: "0"
            name: "general"
            chatType: StatusChatListItem.Type.CommunityChat
            muted: false
            hasUnreadMessages: false
            hasMention: false
            unreadMessagesCount: 0
            iconColor: "orange"
        }
        ListElement {
            chatId: "1"
            name: "random"
            chatType: StatusChatListItem.Type.CommunityChat
            muted: false
            hasUnreadMessages: false
            hasMention: false
            unreadMessagesCount: 0
            iconColor: "orange"
        }
        ListElement {
            chatId: "2"
            name: "watercooler"
            chatType: StatusChatListItem.Type.CommunityChat
            muted: false
            hasUnreadMessages: false
            hasMention: false
            unreadMessagesCount: 0
            iconColor: "orange"
        }
    }
}