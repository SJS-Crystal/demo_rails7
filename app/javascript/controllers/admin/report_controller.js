import { Controller } from "@hotwired/stimulus"
import 'daterangepicker'

export default class extends Controller {
  connect() {
    $('#date_range').daterangepicker();
  }
}
