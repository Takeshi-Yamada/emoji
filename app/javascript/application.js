// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./tagify_setup"

import emojiRegex from 'emoji-regex';

document.addEventListener("turbo:load", () => {
  const input = document.querySelector('input[name="question[content]"]');

  if (!input) return;

  const errorMessageId = "emoji-error-message";

  const showError = (message) => {
    let existing = document.getElementById(errorMessageId);
    if (!existing) {
      existing = document.createElement("div");
      existing.id = errorMessageId;
      existing.style.color = "red";
      existing.style.marginTop = "4px";
      input.parentNode.appendChild(existing);
    }
    existing.textContent = message;
  };

  const removeError = () => {
    const existing = document.getElementById(errorMessageId);
    if (existing) existing.remove();
  };

  input.addEventListener("input", () => {
    const regex = emojiRegex();
    const value = input.value;

    const matched = value.match(regex);
    const onlyEmojis = matched && matched.join("") === value;

    if (!onlyEmojis) {
      showError("絵文字のみで入力してください。");
    } else {
      removeError();
    }
  });
});
