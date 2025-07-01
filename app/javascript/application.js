// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "./tagify_setup"
import { setupGenerateHint } from "./question_support";

import emojiRegex from 'emoji-regex';

//絵文字入力
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

//ツールチップ
document.addEventListener("turbo:load", () => {
  const toggleBtn = document.getElementById("toggle-emoji-tooltip");
  const tooltip = document.getElementById("emoji-tooltip");

  toggleBtn.addEventListener("click", () => {
    if (tooltip.classList.contains("hidden")) {
      tooltip.classList.remove("hidden");
      tooltip.setAttribute("aria-hidden", "false");
    } else {
      tooltip.classList.add("hidden");
      tooltip.setAttribute("aria-hidden", "true");
    }
  });

  // 画面のどこかクリックで閉じる処理（任意）
  document.addEventListener("click", (e) => {
    if (!toggleBtn.contains(e.target) && !tooltip.contains(e.target)) {
      tooltip.classList.add("hidden");
      tooltip.setAttribute("aria-hidden", "true");
    }
  });
});

//AIサポート機能
document.addEventListener("turbo:load", () => {
  setupGenerateHint();
});