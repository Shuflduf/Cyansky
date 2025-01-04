<script lang="ts">
  let { username, content }: { username: string, content: string } = $props();
</script>

<div class="bg-slate-400 p-4 m-2 flex flex-col">
  <p class="text-lg font-bold">@{username}</p>
  <p class="text-lg" style="font-family: 'Inter', sans-serif;">
    {content}
  </p>

  <div class="flex pt-2 justify-evenly">
    <button class="text-white ">
      <div class="flex items-center">
        <img src="/images/like.png" alt="Like" class="h-5 mr-2" /> 42,023
      </div>
    </button>
    <button class="text-white">
      <div class="flex items-center">
        <img src="/images/dislike.png" alt="Dislike" class="h-5 mr-2 font-black" /> 42,023
      </div>
    </button>
    <button class="text-white">
      <div class="flex items-center">
        <img src="/images/comment.png" alt="Comment" class="h-5 mr-2 font-bold" /> 42,023
      </div>
    </button>
  </div>
</div>

<style lang="postcss">
  @import url("https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap");
  :global(html) {
    font-family: "Courier New", Courier, monospace;
  }
</style>
