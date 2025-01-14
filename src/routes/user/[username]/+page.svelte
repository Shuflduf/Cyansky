<script lang="ts">
  import { slide } from "svelte/transition";

  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { getUserData } from "$lib/getUserData";
  import ProfileButton from "$lib/ProfileButton.svelte";
  import PostsList from "$lib/PostsList.svelte";
  import { getCookie } from "$lib/getCookie";
  import { ENDPOINT } from "$lib/constants";

  let error: string | null = $state(null);
  let username: string | undefined = $state($page.params.username);
  let displayName: string | undefined = $state(undefined);
  let description: string | undefined = $state(undefined);
  let userId: string | undefined = $state(undefined);

  let newDisplayName: string | undefined = $state(undefined);
  let newDescription: string | undefined = $state(undefined);

  let ownProfile = $state(false);
  let changed = $derived(
    (newDescription ?? "").trim() !== (description ?? "").trim() ||
      (newDisplayName ?? "").trim() !== (displayName ?? "").trim()
  );
  let canSubmit = $derived(
    (newDescription ?? "").trim().length <= 300 &&
      (newDisplayName ?? "").trim().length <= 36
  );

  let submitting = $state(false);

  onMount(async () => {
    const username = $page.params.username;
    try {
      const userData = await getUserData(username, false);
      displayName = userData["display-name"];
      description = userData["description"];
      newDescription = description;
      newDisplayName = displayName;
      userId = userData["$id"];
      ownProfile = userId === getCookie("user_id");
    } catch (err) {
      if (err instanceof Error) {
        error = err.message;
      } else {
        error = "An unknown error occurred";
      }
    }
  });

  async function submitChanges() {
    if (!canSubmit || submitting) return;
    submitting = true;
    const response = await fetch(`${ENDPOINT}/setuserdata`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        token: getCookie("token"),
        description: newDescription?.trim(),
        display_name: newDisplayName?.trim(),
      }),
    });
    location.reload();
  }
</script>

<div class="flex">
  <div class="w-full"></div>
  <div class="w-full">
    {#if error}
      <h1 class="text-3xl text-center font-bold">Error: {error}</h1>
    {:else}
      <div class="flex flex-col">
        <div
          class="m-2 p-4 flex bg-gradient-to-t {submitting
            ? 'animate-pulse'
            : ''} from-slate-400 to-slate-300 shadow-md hover:shadow-lg transition"
        >
          <img
            src="/images/person.png"
            alt="Profile"
            class="h-24 w-24 brightness-0"
          />
          <div class="flex flex-col w-full">
            {#if ownProfile}
              <h1
                class="text-3xl font-bold outline-none border-b-blue-500 border-opacity-50 border-b-2 break-all w-fit"
                contenteditable
                bind:innerText={newDisplayName}
                spellcheck="false"
              >
                {displayName}
              </h1>
            {:else}
              <h1 class="text-3xl font-bold">
                {displayName}
              </h1>
            {/if}
            <p
              title={ownProfile
                ? "Changing usernames is currently not supported"
                : ""}
            >
              @{username}
            </p>
            {#if ownProfile}
              <p
                style="font-family: 'Inter', sans-serif;"
                data-placeholder="> Add description"
                class="mt-auto break-all border-b-blue-500 border-opacity-50 border-b-2 w-fit {newDescription &&
                newDescription?.trim().length > 0
                  ? ''
                  : 'before:content-[attr(data-placeholder)]'} before:text-slate-500 min-h-[1.5em] outline-none"
                contenteditable
                bind:innerText={newDescription}
              >
                {newDescription}
              </p>
            {:else}
              <p
                style="font-family: 'Inter', sans-serif;"
                data-placeholder="No description"
                class="mt-auto break-all {description
                  ? ''
                  : 'before:content-[attr(data-placeholder)]'} before:text-slate-500 min-h-[1.5em] outline-none"
              >
                {description}
              </p>
            {/if}
            {#if changed}
              <div transition:slide>
                <button
                  onclick={submitChanges}
                  class="p-2 px-4 mt-2 w-full border-none {canSubmit
                    ? 'bg-blue-500 hover:bg-blue-700 cursor-pointer'
                    : 'bg-red-500 hover:bg-red-700 cursor-not-allowed'} text-white transition"
                >
                  Description: ({(newDescription ?? "").trim().length} / 300) Display
                  Name: ({(newDisplayName ?? "").trim().length} / 36)
                </button>
              </div>
            {/if}
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
