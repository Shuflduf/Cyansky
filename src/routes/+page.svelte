<script lang="ts">
  import PostsList from "../lib/PostsList.svelte";

  import ProfileButton from "../lib/ProfileButton.svelte";

  import { onMount } from "svelte";
  import { getUserData } from "$lib/getUserData";
  import { getCookie } from "$lib/getCookie";

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
    <div class="flex flex-col">
      <div
        contenteditable="true"
        class="break-all my-4 mx-2 p-4 bg-slate-300 shadow-md"
      ></div>
      <PostsList />
    </div>
  </div>

  <div class="w-full">
    <ProfileButton />
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    background-color: #e2e8f0;
  }
</style>
