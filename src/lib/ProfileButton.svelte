<script lang="ts">
  import { onMount } from "svelte";
  import { getUserData } from "./getUserData";
  import { getCookie } from "./cookieUtil";
  import { darkMode } from "$lib/stores/theme";

  let username: string | undefined = $state(undefined);
  let displayName: string | undefined = $state(undefined);
  let isDarkMode = $derived($darkMode);

  onMount(async () => {
    const id = getCookie("user_id");
    if (id) {
      let userData = await getUserData(id, true);
      username = userData["username"];
      displayName = userData["display-name"];
    }
  });
</script>

{#if displayName}
  <button
    class="py-2 px-4 {isDarkMode
      ? 'bg-slate-800 text-white'
      : 'bg-slate-300'} shadow-md font-bold w-full"
    onclick={() => {
      if (username) window.location.href = `/user/${username}`;
    }}
  >
    <img
      src="/images/person.png"
      alt="Profile"
      class="h-6 w-6 inline-block {isDarkMode ? 'image-white' : 'brightness-0'}"
    />
    {displayName}
  </button>
{:else}
  <button
    class="py-2 px-4 {isDarkMode
      ? 'bg-slate-800 text-white'
      : 'bg-slate-300'} shadow-md font-bold hover:shadow-lg transition w-full"
    onclick={() => (window.location.href = "/login")}
  >
    Log in / Sign up
  </button>
{/if}

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  .image-white {
    filter: invert(100%) sepia(0%) saturate(0%) hue-rotate(0deg);
  }
</style>
