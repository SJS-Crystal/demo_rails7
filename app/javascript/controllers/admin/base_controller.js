import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.set_sidebar_status()
  }

  set_sidebar_status() {
    var currentURL = window.location.href
    var currentPart = currentURL.split('/')[4]
    if (!currentPart) { return }
    $(".nav-sidebar .nav-link").each(function () {
      var itemMenuPart = $(this).attr("href").split('/')[4]
      if (currentPart.indexOf(itemMenuPart) === 0) {
        $(this).addClass("active")
      }
    })
  }
}
