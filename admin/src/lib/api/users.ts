/* eslint-disable @typescript-eslint/no-explicit-any */
import axios from "axios"

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:9000/api"

// Get all users (admin only)
export const getUsers = async () => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.get(`${API_URL}/users`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch users")
  }
}

// Get user by ID (admin only)
export const getUserById = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.get(`${API_URL}/users/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch user")
  }
}

