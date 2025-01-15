<script lang="ts">
  import { slide } from "svelte/transition";

  import PostsList from "../lib/PostsList.svelte";

  import { onMount } from "svelte";
  import { getUserData } from "$lib/getUserData";
  import { getCookie } from "$lib/cookieUtil";
  import { ENDPOINT } from "$lib/constants";
  import Sidebar from "$lib/Sidebar.svelte";
  import { darkMode } from "$lib/stores/theme";

  let token: string | undefined = $state(undefined);
  let id: string | undefined = $state(undefined);

  let submitContent = $state("");
  let showPlaceholder = $derived(submitContent?.trim().length > 0);
  let canSubmit = $derived(submitContent?.trim().length <= 300);
  let submitting = $state(false);
  let isDarkMode = $derived($darkMode);

  onMount(async () => {
    token = getCookie("token");
    id = getCookie("user_id");

    if (id) {
      const userData = await getUserData(id, true);
      console.log("User data:", userData);
    }
  });

  async function onSubmit() {
    if (!canSubmit || submitting) {
      return;
    }
    submitting = true;
    await fetch(`${ENDPOINT}/createpost`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        content: submitContent.trim(),
        token: token,
      }),
    });
    location.reload();
  }
</script>

<div class="flex justify-between flex-grow">
  <div class="lg:w-full"></div>

  <div class="w-full">
    <div class="flex flex-col">
      {#if token && token.length > 0}
        <div
          class="break-all my-4 mx-2 p-4 {isDarkMode
            ? 'bg-slate-800 text-white'
            : 'bg-slate-300'} shadow-md cursor-text {submitting
            ? 'animate-pulse'
            : ''}"
        >
          <div
            contenteditable="true"
            data-placeholder="> Leave your mark"
            class="{!showPlaceholder
              ? 'before:content-[attr(data-placeholder)]'
              : ''} before:text-slate-500 min-h-[1.5em] outline-none {isDarkMode
              ? 'text-white'
              : 'text-black'}"
            bind:innerText={submitContent}
          ></div>
          {#if showPlaceholder}
            <div transition:slide>
              <button
                onclick={onSubmit}
                class="p-2 px-4 mt-2 w-full border-none {canSubmit
                  ? 'bg-blue-500 hover:bg-blue-700 cursor-pointer'
                  : 'bg-red-500 hover:bg-red-700 cursor-not-allowed'} text-white transition"
              >
                Submit ({submitContent.trim().length} / 300)
              </button>
            </div>
          {/if}
        </div>
      {/if}
      <PostsList />
    </div>
  </div>

  <div class="lg:w-full">
    <Sidebar />
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
  }
  :global(.dark-mode) {
    background-color: #334155;
  }
</style>
