import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "value", "destroy"]

  setDestroy() {
    let name = this.nameTarget.value.trim()
    let value = this.valueTarget.value.trim()

    if(!name && !value) {
      this.destroyTarget.value = true
    } else {
      this.destroyTarget.value = false
    }
  }
}
