<script lang="ts">
  import Post from "$lib/Post.svelte";
  import { onMount, onDestroy } from "svelte";

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

  let postsPromise = $state<Promise<PostsResponse>>(
    Promise.resolve({ posts: [] })
  );
  let lastPostId: string = "";
  let data: PostsResponse = $state({ posts: [] });
  let loading = $state(true);
  let atEnd = $state(false);

  onMount(async () => {
    postsPromise = fetchPosts();
    if (typeof window !== "undefined") {
      window.addEventListener("scroll", handleScroll);
    }
  });

  onDestroy(() => {
    if (typeof window !== "undefined") {
      window.removeEventListener("scroll", handleScroll);
    }
  });

  async function fetchPosts(): Promise<PostsResponse> {
    try {
      const response = await fetch("http://localhost:8000/getposts", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ last_post_id: lastPostId }),
      });
      if (response.ok) {
        let newData = await response.json();
        if (newData == null) {
          console.log("No more posts available");
          atEnd = true;
          return data;
        }
        data.posts = data.posts.concat(newData.posts);
        lastPostId = data.posts[data.posts.length - 1].$id;
        console.log("Last post ID:", lastPostId);
        loading = false;
        return data;
      } else {
        console.error("Failed to fetch posts, status:", response.status);
        throw new Error("Failed to fetch posts");
      }
    } catch (error) {
      console.error("Error fetching posts:", error);
      throw error;
    }
  }

  function handleScroll() {
    if (
      window.innerHeight + window.scrollY >=
      document.body.offsetHeight - 800
    ) {
      if (!loading && !atEnd) {
        console.log("Reached the bottom of the page");
        fetchPosts();
        loading = true;
      }
    }
  }
</script>

<div class="flex flex-col mx-auto w-full">
  {#await postsPromise}
    <h1 class="text-3xl text-center font-bold">Loading...</h1>
  {:then data}
    {#if data && data.posts}
      <div>
        {#each data.posts as post}
          <Post username={post.author.username} content={post.content} />
        {/each}
      </div>
      {#if atEnd}
        <h1 class="text-3xl text-center font-bold">You're at the end...</h1>
      {:else if loading}
        <h1 class="text-3xl text-center font-bold">Loading more posts...</h1>
      {/if}
    {:else}
      <h1 class="text-3xl text-center font-bold">No posts available.</h1>
    {/if}
  {:catch error}
    <h1 class="text-3xl text-center font-bold">
      Error loading posts: {error.message}
    </h1>
  {/await}
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
</style>
