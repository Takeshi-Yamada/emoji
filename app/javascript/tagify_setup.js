document.addEventListener("DOMContentLoaded", () => {
  const input = document.querySelector("#tag-input");
  if (!input) return;

  // Tagifyを適用
  const tagify = new Tagify(input, {
    whitelist: [],  // 補完候補（あとでAjaxで追加）
    dropdown: {
      enabled: 0,        // <= 入力0文字でも候補を表示
      closeOnSelect: false,
      maxItems: 10,
      classname: "tagify-dropdown",
    },
  });

  // Ajaxで補完候補を取得
  fetch("/tags/autocomplete")
    .then(res => res.json())
    .then(data => {
      tagify.settings.whitelist = data;
    });
});
