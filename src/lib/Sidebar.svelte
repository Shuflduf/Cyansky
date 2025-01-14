<script lang="ts">
  import LogoutButton from "./LogoutButton.svelte";
  import ProfileButton from "./ProfileButton.svelte";
</script>

<div class="flex flex-col items-end fixed right-0 top-0">
  <div class="flex flex-col w-full gap-4 m-4">
    <ProfileButton />
    <LogoutButton />
  </div>
</div>
