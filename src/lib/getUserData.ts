export async function getUserData(id: string) {
  try {
    const response = await fetch("http://localhost:8000/getuserdata", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ user_id: id }),
    });

    if (response.ok) {
      const data = await response.json();
      return data;
    } else {
      console.error("Failed to fetch user data, status:", response.status);
      throw new Error("Failed to fetch user data");
    }
  } catch (error) {
    console.error("Error fetching user data:", error);
    throw error;
  }
}
