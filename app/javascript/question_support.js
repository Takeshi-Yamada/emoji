export function setupGenerateHint() {
  const generateBtn = document.getElementById("generate-btn");
  if (!generateBtn) return;

  const answerInput = document.getElementById("answer-input");
  const emojiHintInput = document.getElementById("emoji-hint-input");
  const hint1Input = document.getElementById("hint_1_input");
  const hint2Input = document.getElementById("hint_2_input");
  const hint3Input = document.getElementById("hint_3_input");

  generateBtn.addEventListener("click", () => {
    const answer = answerInput.value.trim();
    if (!answer) {
      alert("まず答えを入力してください！");
      return;
    }

    generateBtn.disabled = true;
    generateBtn.textContent = "生成中...";

    fetch(`/questions/generate_hint?answer=${encodeURIComponent(answer)}`)
      .then(res => res.json())
      .then(data => {
        emojiHintInput.value = data.emoji;
        hint1Input.value = data.hint_1;
        hint2Input.value = data.hint_2;
        hint3Input.value = data.hint_3;
      })
      .catch(() => {
        alert("AIの生成に失敗しました。もう一度お試しください。");
      })
      .finally(() => {
        generateBtn.disabled = false;
        generateBtn.textContent = "AI作問";
      });
  });
}