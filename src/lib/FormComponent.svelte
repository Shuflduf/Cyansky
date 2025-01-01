<script>
    let email = '';
    let username = '';
    let password = '';

    function handleSubmit(event) {
        event.preventDefault();
        console.log('Email:', email);
        console.log('Username:', username);
        console.log('Password:', password);
    }
</script>

<main>
    <form onsubmit={handleSubmit}>
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" bind:value={email} required />
        </div>
        <div>
            <label for="username">Username:</label>
            <input type="text" id="username" bind:value={username} required />
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" bind:value={password} required />
        </div>
        <button type="submit">Submit</button>
    </form>
</main>

<style>
    main {
        max-width: 400px;
        margin: 0 auto;
        padding: 1rem;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-family: 'Courier New', Courier, monospace;
        font-weight: bold;
    }

    div {
        margin-bottom: 1rem;
    }

    label {
        display: block;
        margin-bottom: 0.5rem;
    }

    input {
        width: 100%;
        padding: 0.5rem;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    button {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        background-color: #007BFF;
        color: white;
        cursor: pointer;
    }

    button:hover {
        background-color: #0056b3;
    }
</style>