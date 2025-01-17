<script lang="ts">
  import { darkMode } from "$lib/stores/theme";
  let isDarkMode = $derived($darkMode);
</script>

<button
  class="py-2 px-4 {isDarkMode
    ? 'bg-slate-800 text-white'
    : 'bg-slate-300'} shadow-md font-bold w-full hover:shadow-lg transition"
  onclick={() => (window.location.href = "/")}
>
  <img
    src="/images/home.png"
    alt="Home"
    class="h-6 w-6 inline-block {isDarkMode ? 'image-white' : 'brightness-0'}"
  />
  Home
</button>

<style lang="postcss">
  .image-white {
    filter: invert(100%) sepia(0%) saturate(0%) hue-rotate(0deg);
  }
</style>
