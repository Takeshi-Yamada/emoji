document.addEventListener("turbo:load", () => {
  // --- 要素をまとめて取得 ---
  const overlay = document.getElementById("overlay");

  // --- ログインモーダルの処理 ---
  const openLoginBtn = document.getElementById("open-login-modal-btn");
  const closeLoginBtn = document.getElementById("modal-close-btn");
  const loginModal = document.getElementById("login-modal");

  // ▼▼▼ ここからが修正箇所 ▼▼▼
  if (openLoginBtn) { // 変数名を openLoginBtn に修正
    openLoginBtn.addEventListener("click", (event) => {
      event.preventDefault();
      loginModal.classList.add("is-active"); // 変数名を loginModal に修正
      overlay.classList.add("is-active");
    });
  }
  // ▲▲▲ ここまでが修正箇所 ▲▲▲

  if (closeLoginBtn) {
    closeLoginBtn.addEventListener("click", () => {
      loginModal.classList.remove("is-active");
      overlay.classList.remove("is-active");
    });
  }

  // --- ハンバーガーメニューの処理 ---
  const hamburgerBtn = document.getElementById("hamburger-btn");
  const hamburgerNav = document.getElementById("hamburger-nav");

  if (hamburgerBtn) {
    hamburgerBtn.addEventListener("click", () => {
      hamburgerBtn.classList.toggle("is-active");
      hamburgerNav.classList.toggle("is-active");
      overlay.classList.toggle("is-active");
    });
  }

  // --- オーバーレイのクリック処理（1つにまとめる） ---
  if (overlay) {
    overlay.addEventListener("click", () => {
      // もしログインモーダルが開いていたら、それを閉じる
      if (loginModal && loginModal.classList.contains("is-active")) {
        loginModal.classList.remove("is-active");
      }

      // もしハンバーガーメニューが開いていたら、それを閉じる
      if (hamburgerBtn && hamburgerBtn.classList.contains("is-active")) {
        hamburgerBtn.classList.remove("is-active");
        hamburgerNav.classList.remove("is-active");
      }

      // 最後にオーバーレイ自体を閉じる
      overlay.classList.remove("is-active");
    });
  }
});

document.addEventListener("turbo:before-cache", () => {
  // ページがキャッシュされる直前に、開いているモーダルやメニューをすべて閉じる
  document.querySelector("#login-modal.is-active")?.classList.remove("is-active");
  document.querySelector("#hamburger-nav.is-active")?.classList.remove("is-active");
  document.querySelector("#hamburger-btn.is-active")?.classList.remove("is-active");
  document.querySelector("#overlay.is-active")?.classList.remove("is-active");
});
