<script lang="ts">
  import { onMount } from "svelte";
  import { getCookie } from "./cookieUtil";
  import { darkMode } from "$lib/stores/theme";

  let render = $state(false);
  let isDarkMode = $derived($darkMode);

  onMount(async () => {
    const id = getCookie("user_id");
    if (id) {
      render = true;
    }
  });
</script>

{#if render}
  <button
    class="py-2 px-4 {isDarkMode
      ? 'bg-slate-800 text-white'
      : 'bg-slate-300'} right-0 shadow-md font-bold w-full hover:shadow-lg transition"
    onclick={() => {
      window.location.href = "/login";
    }}
  >
    <img
      src="/images/logout.png"
      alt="Logout"
      class="h-6 w-6 inline-block {isDarkMode ? 'image-white' : 'brightness-0'}"
    />
    Logout
  </button>
{/if}

<style lang="postcss">
  .image-white {
    filter: invert(100%) sepia(0%) saturate(0%) hue-rotate(0deg);
  }
</style>
