document.addEventListener("turbo:load", () => {
  const input = document.querySelector("#tag-input");
  if (!input) return;

  // 二重初期化防止
  if (input.tagify) input.tagify.destroy();

  // Tagifyの初期化
  const tagify = new Tagify(input, {
    originalInputValueFormat: values =>
      values.map(item => item.value).join(","),
    dropdown: {
      enabled: 0,
      closeOnSelect: false,
      maxItems: 10
    }
  });

  // 必要なら候補（whitelist）をAjaxで取得
  fetch("/tags/autocomplete")
    .then(res => res.json())
    .then(data => {
      tagify.settings.whitelist = data;
    });
});
