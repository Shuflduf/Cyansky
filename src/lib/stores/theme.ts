import { writable } from "svelte/store";

let storedDarkMode = false;
if (typeof localStorage !== "undefined") {
  storedDarkMode = localStorage.getItem("darkMode") === "true";
}
export const darkMode = writable(storedDarkMode);

function updateTheme(value: boolean) {
  if (typeof localStorage !== "undefined") {
    localStorage.setItem("darkMode", value.toString());
  }
  if (value) {
    document.documentElement.classList.add("dark-mode");
  } else {
    document.documentElement.classList.remove("dark-mode");
  }
}

if (typeof document !== "undefined") {
  darkMode.subscribe(updateTheme);
}

export function toggleTheme() {
  darkMode.update((value) => !value);
}

export { updateTheme };
