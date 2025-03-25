import axios from "axios"

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:9000/api"

// Get all orders (admin only)
export const getOrders = async () => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.get(`${API_URL}/cart`, { // change from orders to cart
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch orders")
  }
}

// Get order by ID
export const getOrderById = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.get(`${API_URL}/orders/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch order")
  }
}

// Update order status
export const updateOrderStatus = async (id: string, status: string) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.put(
      `${API_URL}/orders/${id}/status`,
      { status },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    )
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to update order status")
  }
}

