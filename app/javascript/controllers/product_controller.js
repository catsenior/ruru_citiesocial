import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "quantity", "sku", "addToCartButton" ]

  quantity_minus(event){
    event.preventDefault();
    console.log('-')
    let q = Number(this.quantityTarget.value);
    if (q > 1) {
      this.quantityTarget.value = q - 1;
    }
    
  }

  quantity_plus(event){
    event.preventDefault();
    let q = Number(this.quantityTarget.value);
    this.quantityTarget.value = q + 1;
  }

  add_to_cart(event){
    event.preventDefault();

    let sku_id = this.data.get("id");
    let quantity = this.quantityTarget.value;
    let sku = this.skuTarget.value;

    if (quantity > 0 ) {
      this.addToCartButtonTarget.classList.add('is-loading')
      let data = new FormData();
      data.append("id", sku_id);
      data.append("quantity", quantity);
      data.append("sku", sku);

      Rails.ajax({
        url: '/api/v1/cart',
        type: 'POST',
        data: data,
        success: (response) => {
          if (response.status === 'ok') {
            let item_count = response.items || 0;
            //廣播事件
            let event = new CustomEvent('addToCart', { 'detail': { item_count } });
            document.dispatchEvent(event);
          }
        },
        error: (err) => {
          console.log(err);
        },
        complete: () => {
          this.addToCartButtonTarget.classList.remove('is-loading')
        }
      });
    }
  }
}
