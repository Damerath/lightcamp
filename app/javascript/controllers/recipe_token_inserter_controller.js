import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "editor"]

  connect() {
    this.renderEditor()
  }

  insert(event) {
    const button = event.currentTarget
    const chip = this.buildChip(button.dataset.token, button.dataset.preview)
    const selection = window.getSelection()

    if (selection.rangeCount && this.editorTarget.contains(selection.anchorNode)) {
      const range = selection.getRangeAt(0)
      range.deleteContents()
      range.insertNode(chip)
      range.setStartAfter(chip)
      range.collapse(true)
      selection.removeAllRanges()
      selection.addRange(range)
    } else {
      this.editorTarget.append(chip, document.createTextNode(" "))
    }

    this.editorTarget.focus()
    this.sync()
  }

  sync() {
    this.inputTarget.value = this.serialize(this.editorTarget)
  }

  buildChip(token, label) {
    const chip = document.createElement("span")
    chip.contentEditable = "false"
    chip.dataset.token = token
    chip.className = "mx-0.5 inline-flex rounded bg-amber-100 px-1.5 py-0.5 text-amber-900 dark:bg-amber-900/60 dark:text-amber-100"
    chip.textContent = label
    return chip
  }

  renderEditor() {
    const buttons = new Map(
      Array.from(this.element.querySelectorAll("[data-token]")).map((button) => [button.dataset.token, button.dataset.preview])
    )
    const fragments = this.inputTarget.value.split(/(\[\[ingredient:\d+:(?:full|amount)\]\])/)

    this.editorTarget.replaceChildren(...fragments.map((fragment) => {
      if (buttons.has(fragment)) return this.buildChip(fragment, buttons.get(fragment))
      return document.createTextNode(fragment)
    }))
  }

  serialize(node) {
    if (node.nodeType === Node.TEXT_NODE) return node.textContent
    if (node.dataset?.token) return node.dataset.token
    if (node.tagName === "BR") return "\n"

    const content = Array.from(node.childNodes).map((child) => this.serialize(child)).join("")
    return ["DIV", "P"].includes(node.tagName) ? `${content}\n` : content
  }
}
