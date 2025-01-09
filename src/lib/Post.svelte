<script lang="ts">
  import { getCookie } from "./getCookie";

  let {
    username,
    content,
    likes,
    dislikes,
    postId,
    userLikedPosts,
    userDislikedPosts,
  }: {
    username: string;
    content: string;
    likes: number;
    dislikes: number;
    postId?: string;
    userLikedPosts?: string[];
    userDislikedPosts?: string[];
  } = $props();

  let requestPending = $state(false);

  let liked = $state(postId ? (userLikedPosts ?? []).includes(postId) : false);
  let disliked = $state(
    postId ? (userDislikedPosts ?? []).includes(postId) : false
  );

  console.log("Post:", { content, userLikedPosts, postId });

  function updateAllValues() {
    if (userLikedPosts === undefined || userDislikedPosts === undefined) {
    }
    liked = postId ? (userLikedPosts?.includes(postId) ?? false) : false;
    disliked = postId ? (userDislikedPosts?.includes(postId) ?? false) : false;
    console.log("Updated values:", { liked, disliked });
  }

  async function sendToLikesApi(isLike: boolean) {
    if (requestPending) {
      return;
    }
    requestPending = true;
    const token = getCookie("token");
    const response = await fetch("http://localhost:8000/likes", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        post_id: postId,
        is_like: isLike,
        token: token,
      }),
    });
    const json = await response.json();
    userDislikedPosts = json["disliked_posts"];
    userLikedPosts = json["liked_posts"];
    likes = json["new_likes"];
    dislikes = json["new_dislikes"];
    requestPending = false;
    updateAllValues();
  }

  async function sendLike() {
    await sendToLikesApi(true);
  }

  async function sendDislike() {
    await sendToLikesApi(false);
  }
</script>

<div
  class="p-4 m-2 flex flex-col shadow-md hover:shadow-lg transition break-words bg-gradient-to-t from-[#bac5d1] to-slate-300"
>
  <button
    onclick={() => (window.location.href = `/user/${username}`)}
    class="text-lg font-bold text-left"
  >
    @{username}
  </button>
  <p class="text-lg text-wrap" style="font-family: 'Inter', sans-serif;">
    {content}
  </p>

  <div
    class="flex pt-2 justify-evenly {requestPending
      ? 'animate-pulse opacity-70'
      : ''}"
  >
    <button onclick={sendLike} class={liked ? "text-blue-500 font-bold" : ""}>
      <img
        src="/images/like.png"
        alt="Like"
        class="h-6 mr-2 inline {liked ? 'image-blue' : ''}"
      />
      {likes}
    </button>
    <button
      onclick={sendDislike}
      class={disliked ? "text-blue-500 font-bold" : ""}
    >
      <img
        src="/images/dislike.png"
        alt="Dislike"
        class="h-6 mr-2 inline {disliked ? 'image-blue' : ''}"
      />{dislikes}
    </button>
    <!-- <button>
      <img
        src="/images/comment.png"
        alt="Comment"
        class="h-6 mr-2 brightness-0 inline"
      /> Comments
    </button> -->
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    font-family: "Courier New", Courier, monospace;
  }
  .image-blue {
    filter: invert(41%) sepia(62%) saturate(1486%) hue-rotate(199deg)
      brightness(98%) contrast(97%);
  }
</style>
