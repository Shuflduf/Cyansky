<script lang="ts">
  import { onMount } from "svelte";
  import { getUserData } from "./getUserData";
  import { getCookie } from "./getCookie";

  let username: string | undefined = $state(undefined);
  let displayName: string | undefined = $state(undefined);

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
    class="m-4 py-2 px-4 fixed bg-slate-300 right-0 shadow-md font-bold"
    onclick={() => {
      if (username) window.location.href = `/user/${username}`;
    }}
  >
    <img
      src="/images/person.png"
      alt="Profile"
      class="h-6 w-6 inline-block brightness-0"
    />
    {displayName}
  </button>
{:else}
  <button
    class="m-4 py-2 px-4 fixed bg-slate-300 right-0 shadow-md font-bold hover:shadow-lg transition"
    onclick={() => (window.location.href = "/login")}
  >
    Log in / Sign up
  </button>
{/if}

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
  }
</style>
