import axios from "axios"

const API_URL = process.env.NEXT_PUBLIC_API_URL || "http://localhost:9000/api"

// Get all categories
export const getCategories = async () => {
  try {
    const token = localStorage.getItem("token")
    const response = await axios.get(`${API_URL}/categories`, {
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch categories")
  }
}

// Get category by ID
export const getCategoryById = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    const response = await axios.get(`${API_URL}/categories/${id}`, {
      headers: token ? { Authorization: `Bearer ${token}` } : {},
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to fetch category")
  }
}

// Add new category
export const addCategory = async (categoryData: { name: string; type: string; description: string }) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.post(`${API_URL}/categories/add-category`, categoryData, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to add category")
  }
}

// Update category
export const updateCategory = async (id: string, categoryData: { name: string; type: string; description: string }) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.put(`${API_URL}/categories/update/${id}`, categoryData, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to update category")
  }
}

// Delete category
export const deleteCategory = async (id: string) => {
  try {
    const token = localStorage.getItem("token")
    if (!token) throw new Error("Authentication required")

    const response = await axios.delete(`${API_URL}/categories/delete/${id}`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
    return response.data
  } catch (error: any) {
    throw new Error(error.response?.data?.message || "Failed to delete category")
  }
}

