import NimQml
import state

QtObject:
  type StateWrapper* = ref object of QObject
    stateObj: State

  proc delete*(self: StateWrapper) =
    self.QObject.delete

  proc newStateWrapper*(): StateWrapper =
    new(result, delete)
    result.QObject.setup()

  proc stateWrapperChanged*(self:StateWrapper) {.signal.}

  proc setStateObj*(self: StateWrapper, stateObj: State) =
    self.stateObj = stateObj
    self.stateWrapperChanged()

  proc getStateObj*(self: StateWrapper): State =
    return self.stateObj

  proc getFlowType(self: StateWrapper): string {.slot.} =
    if(self.stateObj.isNil):
      return $FlowType.General
    return $self.stateObj.flowType()
  QtProperty[string] flowType:
    read = getFlowType
    notify = stateWrapperChanged

  proc getStateType(self: StateWrapper): string {.slot.} =
    if(self.stateObj.isNil):
      return $StateType.NoState
    return $self.stateObj.stateType()
  QtProperty[string] stateType:
    read = getStateType
    notify = stateWrapperChanged

  proc getDisplayBackButton(self: StateWrapper): bool {.slot.} =
    if(self.stateObj.isNil):
      return false
    return self.stateObj.displayBackButton()
  QtProperty[bool] displayBackButton:
    read = getDisplayBackButton
    notify = stateWrapperChanged

  proc backActionClicked*(self: StateWrapper) {.signal.}
  proc backAction*(self: StateWrapper) {.slot.} =
    self.backActionClicked()

  proc primaryActionClicked*(self: StateWrapper) {.signal.}
  proc doPrimaryAction*(self: StateWrapper) {.slot.} =
    self.primaryActionClicked()

  proc secondaryActionClicked*(self: StateWrapper) {.signal.}
  proc doSecondaryAction*(self: StateWrapper) {.slot.} =
    self.secondaryActionClicked()

  proc tertiaryActionClicked*(self: StateWrapper) {.signal.}
  proc doTertiaryAction*(self: StateWrapper) {.slot.} =
    self.tertiaryActionClicked()