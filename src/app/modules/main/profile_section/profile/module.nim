import NimQml, chronicles, sequtils, sugar

import ./io_interface, ./view, ./controller
import ../io_interface as delegate_interface
import ../../../../global/global_singleton

import ../../../../../app_service/service/profile/service as profile_service
import ../../../../../app_service/service/settings/service as settings_service
import ../../../../../app_service/common/social_links

import ../../../shared_models/social_links_model
import ../../../shared_models/social_link_item

export io_interface

logScope:
  topics = "profile-section-profile-module"

type
  Module* = ref object of io_interface.AccessInterface
    delegate: delegate_interface.AccessInterface
    controller: Controller
    view: View
    viewVariant: QVariant
    moduleLoaded: bool

proc newModule*(delegate: delegate_interface.AccessInterface,
  profileService: profile_service.Service, settingsService: settings_service.Service): Module =
  result = Module()
  result.delegate = delegate
  result.view = view.newView(result)
  result.viewVariant = newQVariant(result.view)
  result.controller = controller.newController(result, profileService, settingsService)
  result.moduleLoaded = false

method delete*(self: Module) =
  self.view.delete
  self.viewVariant.delete
  self.controller.delete

method load*(self: Module) =
  self.controller.init()
  self.view.load()

method isLoaded*(self: Module): bool =
  return self.moduleLoaded

method getModuleAsVariant*(self: Module): QVariant =
  return self.viewVariant

func hasCustomLink(socialLinks: seq[SocialLinkItem]): bool =
  for socialLinkItem in socialLinks:
    if socialLinkItem.linkType() == LinkType.Custom:
      return true

method viewDidLoad*(self: Module) =
  var socialLinkItems = toSocialLinkItems(self.controller.getSocialLinks())

  # Add custom link placeholder
  if not socialLinkItems.hasCustomLink:
    socialLinkItems.add(initSocialLinkItem("", "", LinkType.Custom))

  self.view.socialLinksModel().setItems(socialLinkItems)
  self.view.temporarySocialLinksModel().setItems(socialLinkItems)

  self.moduleLoaded = true
  self.delegate.profileModuleDidLoad()

method storeIdentityImage*(self: Module, imageUrl: string, aX: int, aY: int, bX: int, bY: int) =
  let address = singletonInstance.userProfile.getAddress()
  let image = singletonInstance.utils.formatImagePath(imageUrl)
  self.controller.storeIdentityImage(address, image, aX, aY, bX, bY)

method deleteIdentityImage*(self: Module) =
  let address = singletonInstance.userProfile.getAddress()
  self.controller.deleteIdentityImage(address)

method setDisplayName*(self: Module, displayName: string) =
  self.controller.setDisplayName(displayName)

method getBio(self: Module): string =
  self.controller.getBio()

method setBio(self: Module, bio: string): bool =
  self.controller.setBio(bio)

method saveSocialLinks*(self: Module): bool =
  let socialLinks = map(self.view.temporarySocialLinksModel.items(), x => SocialLink(text: x.text, url: x.url))
  return self.controller.setSocialLinks(socialLinks)
