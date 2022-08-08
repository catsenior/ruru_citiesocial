import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "count" ]

  updateCart(event){
    let data = event.detail;
    this.countTarget.innerText = `(${data.item_count})`;
  }
}
