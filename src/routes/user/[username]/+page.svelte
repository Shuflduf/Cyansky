<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { getUserData } from "$lib/getUserData";
  import ProfileButton from "$lib/ProfileButton.svelte";
  import PostsList from "$lib/PostsList.svelte";

  let error: string | null = $state(null);
  let username: string | undefined = $state($page.params.username);
  let displayName: string | undefined = $state(undefined);
  let description: string | undefined = $state(undefined);
  let userId: string | undefined = $state(undefined);

  onMount(async () => {
    const username = $page.params.username;
    try {
      const userData = await getUserData(username, false);
      displayName = userData["display-name"];
      description = userData["description"];
      userId = userData["$id"];
    } catch (err) {
      if (err instanceof Error) {
        error = err.message;
      } else {
        error = "An unknown error occurred";
      }
    }
  });
</script>

<div class="flex">
  <div class="w-full"></div>
  <div class="w-full">
    {#if error}
      <h1 class="text-3xl text-center font-bold">Error: {error}</h1>
    {:else}
      <div class="flex flex-col">
        <div
          class="m-2 p-4 flex bg-gradient-to-t from-slate-400 to-slate-300 shadow-md hover:shadow-lg transition"
        >
          <img
            src="/images/person.png"
            alt="Profile"
            class="h-24 w-24 brightness-0"
          />
          <div class="flex flex-col">
            <h1 class="text-3xl font-bold">
              {displayName}
            </h1>
            <p>@{username}</p>
            <p style="font-family: 'Inter', sans-serif;" class="mt-auto">
              {description}
            </p>
          </div>
        </div>
        {#if userId}
          <PostsList targetUserId={userId} />
        {:else}
          <h1 class="text-3xl text-center font-bold">Loading...</h1>
        {/if}
      </div>
    {/if}
  </div>
  <div class="w-full">
    <ProfileButton />
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
    font-family: "Courier New", Courier, monospace;
  }
</style>
