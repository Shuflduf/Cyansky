<script lang="ts">
  let email = "";
  let name = "";
  let password = "";
  let isSignup = true;

  function setCookie(name: string, value: string, days: number) {
    const date = new Date();
    date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
    const expires = "expires=" + date.toUTCString();
    document.cookie = `${name}=${value};${expires};path=/;SameSite=Lax`;
  }

  async function handleSubmit(event: SubmitEvent) {
    event.preventDefault();
    const data = {
      email,
      password,
      ...(isSignup && { name }),
    };

    const url = isSignup
      ? "http://localhost:8000/createaccount"
      : "http://localhost:8000/login";

    try {
      const response = await fetch(url, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
      });

      if (response.ok) {
        const responseData = await response.json();
        console.log(
          isSignup ? "Account created successfully" : "Logged in successfully"
        );
        if (responseData.token) {
          setCookie("token", responseData.token, 7); // Save token in cookie for 7 days
        }
        // Handle successful response (e.g., redirect to another page)
      } else {
        console.error("Failed to submit, status:", response.status);
      }
    } catch (error) {
      console.error("Error submitting form:", error);
    }
  }
</script>

<main
  class="max-w-md mx-auto p-4 font-mono font-bold shadow-md flex items-center min-h-screen flex-col bg-slate-300 pt-56"
>
  <div class="flex justify-around mb-4">
    <button
      class="p-2"
      onclick={() => (isSignup = true)}
      class:selected={isSignup === true}
      class:not-selected={isSignup === false}>Sign up</button
    >
    <button
      class="p-2"
      onclick={() => (isSignup = false)}
      class:selected={isSignup === false}
      class:not-selected={isSignup === true}>Log in</button
    >
  </div>
  <form onsubmit={handleSubmit} class="w-full">
    {#if isSignup}
      <div class="mb-4">
        <label for="username" class="block mb-2">Username:</label>
        <input
          type="text"
          id="username"
          bind:value={name}
          required
          class="w-full p-2 border border-gray-300"
        />
      </div>
    {/if}
    <div class="mb-4">
      <label for="email" class="block mb-2">Email:</label>
      <input
        type="email"
        id="email"
        bind:value={email}
        required
        class="w-full p-2 border border-gray-300"
      />
    </div>
    <div class="mb-4">
      <label for="password" class="block mb-2">Password:</label>
      <input
        type="password"
        id="password"
        bind:value={password}
        required
        class="w-full p-2 border border-gray-300"
      />
    </div>
    <button
      type="submit"
      class="p-2 px-4 border-none bg-blue-500 text-white cursor-pointer shadow-md hover:shadow-lg hover:bg-blue-700 transition"
      >Submit</button
    >
  </form>
</main>

<style>
  main {
    font-family: "Courier New", Courier, monospace;
  }
  .selected {
    background-color: #007bff;
    color: white;
    padding: 0.5rem 1rem;
    transition: background-color 0.3s ease;
  }
  .not-selected {
    background-color: #f0f0f0;
    color: black;
    padding: 0.5rem 1rem;
    transition: background-color 0.3s ease;
  }
</style>
