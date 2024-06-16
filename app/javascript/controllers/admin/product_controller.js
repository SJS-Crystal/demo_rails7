import { setInputDestroyStatus } from "controllers/common_functions"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "value", "destroy"]

  setInputDestroyStatus() {
    setInputDestroyStatus(this)
  }
}
