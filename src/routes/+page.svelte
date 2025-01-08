<script lang="ts">
  import PostsList from "../lib/PostsList.svelte";

  import ProfileButton from "../lib/ProfileButton.svelte";

  import { onMount } from "svelte";
  import { getUserData } from "$lib/getUserData";

  // Define the types for the response data
  interface Author {
    username: string;
  }

  interface PostData {
    author: Author;
    content: string;
    replies: string[];
    $id: string;
  }

  interface PostsResponse {
    posts: PostData[];
  }

  let token: string | undefined = $state(undefined);
  let id: string | undefined = $state(undefined);
  let username: string | undefined = $state(undefined);
  let displayName: string | undefined = $state(undefined);

  function getCookie(name: string): string | undefined {
    const nameEQ = name + "=";
    const ca = document.cookie.split(";");
    for (let i = 0; i < ca.length; i++) {
      let c = ca[i];
      while (c.charAt(0) == " ") c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return undefined;
  }

  onMount(async () => {
    token = getCookie("token");
    id = getCookie("user_id");

    if (id) {
      const userData = await getUserData(id, true);
      console.log("User data:", userData);
      username = userData["username"];
      displayName = userData["display-name"];
    }
  });
</script>

<div class="flex justify-between flex-grow">
  <div class="w-full"></div>

  <div class="w-full">
    <PostsList />
  </div>

  <div class="w-full">
    <ProfileButton {displayName} {username} />
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
  }
</style>
