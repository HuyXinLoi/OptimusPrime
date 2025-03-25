import axios from "axios"

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:9000/api"

// Login user
export const loginUser = async (email: string, password: string) => {
  try {
    const response = await axios.post(`${API_URL}/users/login`, {
      email,
      password,
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.msg || "Login failed")
  }
}

// Get authenticated user
export const getAuthUser = async () => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("No token found")

    const response = await axios.get(`${API_URL}/users/profile`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to get user")
  }
}

