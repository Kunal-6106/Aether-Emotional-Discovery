document.addEventListener("DOMContentLoaded", () => {
    document.body.classList.add("loaded");

    const reveals = document.querySelectorAll(".reveal");

    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.classList.add("revealed");
            }
        });
    }, {
        threshold: 0.12
    });

    reveals.forEach((el) => revealObserver.observe(el));
});
// --- LIGHT/DARK MODE TOGGLE ---
const themeToggleBtn = document.getElementById("theme-toggle");
const body = document.body;

// Check local storage for saved theme
const savedTheme = localStorage.getItem("aether_theme");
if (savedTheme === "light") {
    body.classList.add("light-mode");
    if (themeToggleBtn) themeToggleBtn.textContent = "🌙";
} else if (savedTheme === "dark") {
    body.classList.remove("light-mode");
    if (themeToggleBtn) themeToggleBtn.textContent = "☀️";
} else {
    if (themeToggleBtn) themeToggleBtn.textContent = "☀️";
}

if (themeToggleBtn) {
    themeToggleBtn.addEventListener("click", () => {
        body.classList.toggle("light-mode");
        
        if (body.classList.contains("light-mode")) {
            localStorage.setItem("aether_theme", "light");
            themeToggleBtn.textContent = "🌙";
        } else {
            localStorage.setItem("aether_theme", "dark");
            themeToggleBtn.textContent = "☀️";
        }
    });
}