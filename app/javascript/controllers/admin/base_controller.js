import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.set_sidebar_status()
  }

  set_sidebar_status() {
    var currentURL = window.location.href;
    $(".nav-sidebar .nav-link").each(function () {
      var itemMenuURL = $(this).attr("href");
      if (currentURL === itemMenuURL || (currentURL.indexOf(itemMenuURL) === 0 && currentURL.indexOf('?') > 0)) {
        $(this).addClass("active");
        $(this).parents().closest('li.nav-item').addClass("menu-is-opening menu-open");
      }
    });
  }
}
