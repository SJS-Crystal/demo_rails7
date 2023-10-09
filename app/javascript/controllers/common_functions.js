export function setInputDestroyStatus(that) {
  let name = that.nameTarget.value.trim()
  let value = that.valueTarget.value.trim()

  if (!name && !value) {
    that.destroyTarget.value = true
  } else {
    that.destroyTarget.value = false
  }
}