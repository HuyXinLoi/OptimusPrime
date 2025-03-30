import axios from "axios"

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:9000/api"

// Get all products with pagination and search
export const getProducts = async (page = 1, limit = 10, query = "") => {
  try {
    const token = localStorage.getItem("token")
    const response = await axios.get(`${API_URL}/products`, {
      params: { page, limit, q: query },
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch products")
  }
}

// Get product by ID
export const getProductById = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    const response = await axios.get(`${API_URL}/products/${id}`, {
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch product")
  }
}

// Add new product
export const addProduct = async (productData: FormData) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.post(`${API_URL}/products/add`, productData, {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "multipart/form-data",
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to add product")
  }
}

// Update product
export const updateProduct = async (id: string, productData: FormData) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.put(`${API_URL}/products/update/${id}`, productData, {
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "multipart/form-data",
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to update product")
  }
}

// Delete product
export const deleteProduct = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.delete(`${API_URL}/products/delete/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to delete product")
  }
}

