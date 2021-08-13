import { Controller } from "stimulus"
import client from 'braintree-web-drop-in'

export default class extends Controller {
  static values = { token: String }

  initialize() {
    this.dropInInstance = undefined
  }

  connect() {
    const form = this.element.parentElement
    client.create({
      container: this.element,
      authorization: this.tokenValue
    }).then(instance => {
      this.dropInInstance = instance

      form.addEventListener('submit', (e) => {
        e.preventDefault()

        instance.requestPaymentMethod()
        .then(payload => {
          const el = document.createElement("input")
          el.setAttribute("type", "hidden")
          el.setAttribute("name", "nonce")
          el.value = payload.nonce
          form.appendChild(el)

          form.submit()
        })
        .catch(err => console.log(err))
      })
    }).catch(err => {
      console.log(err);
    })
  }

  disconnect() {
    this.dropInInstance.teardown()
    // console.log("bye", this.dropInInstance);
  }
}
