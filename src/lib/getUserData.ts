import { ENDPOINT } from "./constants";

export async function getUserData(identification: string, id: boolean) {
  try {
    const response = await fetch(ENDPOINT + "/getuserdata", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: id
        ? JSON.stringify({ user_id: identification })
        : JSON.stringify({ username: identification }),
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
