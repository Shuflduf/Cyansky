<script lang="ts">
  import { onMount } from "svelte";
  import LogoutButton from "./LogoutButton.svelte";
  import ProfileButton from "./ProfileButton.svelte";
  import ThemeButton from "./ThemeButton.svelte";

  let isOpen = false;

  function toggleSidebar() {
    isOpen = !isOpen;
  }

  onMount(() => {
    const mediaQuery = window.matchMedia("(min-width: 1024px)");
    isOpen = mediaQuery.matches;
    mediaQuery.addEventListener("change", (e) => {
      isOpen = e.matches;
    });
  });
</script>

<div
  class="fixed right-0 top-0 m-4 lg:hidden transform transition-all duration-300"
  class:translate-x-full={isOpen}
  class:opacity-0={isOpen}
>
  <button class="p-2 bg-blue-500 text-white" onclick={toggleSidebar}>
    <img
      src="/images/menu.png"
      alt="Menu"
      class="inline-block h-6 w-6 image-white"
    />
  </button>
</div>

<div
  class="flex flex-col items-end fixed right-0 top-0 transform transition-transform duration-300 lg:translate-x-0 h-screen overflow-hidden"
  class:translate-x-[110%]={!isOpen}
>
  <div class="flex flex-col w-full gap-2 m-4">
    <button
      class="w-full p-2 bg-red-500 text-white lg:hidden shadow-md hover:shadow-lg transition"
      onclick={toggleSidebar}
    >
      <img
        src="/images/close.png"
        alt="Close"
        class="inline-block h-6 w-6 mx-2 image-white"
      />Close
    </button>
    <ProfileButton />
    <LogoutButton />
    <ThemeButton />
  </div>
</div>

<style lang="postcss">
  .image-white {
    filter: invert(100%) sepia(0%) saturate(0%) hue-rotate(0deg);
  }
</style>
