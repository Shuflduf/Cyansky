<script lang="ts">
  import { onMount } from "svelte";
  import { getCookie } from "./getCookie";

  let render = $state(false);

  onMount(async () => {
    const id = getCookie("user_id");
    if (id) {
      render = true;
    }
  });
</script>

{#if render}
  <button
    class="py-2 px-4 bg-slate-300 right-0 shadow-md font-bold w-full"
    onclick={() => {
      window.location.href = "/login";
    }}
  >
    <img
      src="/images/logout.png"
      alt="Profile"
      class="h-6 w-6 inline-block brightness-0"
    />
    Logout
  </button>
{/if}

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
  }
</style>
