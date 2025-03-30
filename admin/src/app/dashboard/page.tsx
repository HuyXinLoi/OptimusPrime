"use client"

import { useState, useEffect } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { ShoppingBag, Users, Tag, ShoppingCart } from "lucide-react"
import { getProducts } from "@/lib/api/products"
import { getCategories } from "@/lib/api/categories"
import { getUsers } from "@/lib/api/users"
import { getOrders } from "@/lib/api/orders"

export default function DashboardPage() {
  const [stats, setStats] = useState({
    products: 0,
    categories: 0,
    users: 0,
    orders: 0,
  })
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const [productsData, categoriesData, usersData, ordersData] = await Promise.all([
          getProducts(),
          getCategories(),
          getUsers(),
          getOrders(),
        ])

        setStats({
          products: productsData.data?.length || productsData?.length || 0,
          categories: categoriesData.data?.length || categoriesData?.length || 0,
          users: usersData.data?.length || usersData?.length || 0,
          orders: ordersData.data?.length || ordersData?.length || 0,
        })
      } catch (error) {
        console.error("Error fetching dashboard stats:", error)
      } finally {
        setIsLoading(false)
      }
    }

    fetchStats()
  }, [])

  const statCards = [
    {
      title: "Total Products",
      value: stats.products,
      icon: ShoppingBag,
      color: "bg-blue-500",
    },
    {
      title: "Total Categories",
      value: stats.categories,
      icon: Tag,
      color: "bg-green-500",
    },
    {
      title: "Total Users",
      value: stats.users,
      icon: Users,
      color: "bg-purple-500",
    },
    {
      title: "Total Orders",
      value: stats.orders,
      icon: ShoppingCart,
      color: "bg-orange-500",
    },
  ]

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Dashboard Overview</h1>

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[1, 2, 3, 4].map((i) => (
            <Card key={i} className="animate-pulse">
              <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium">
                  <div className="h-4 bg-gray-200 rounded w-24"></div>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-8 bg-gray-200 rounded w-16"></div>
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {statCards.map((card, index) => (
            <Card key={index}>
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <CardTitle className="text-sm font-medium">{card.title}</CardTitle>
                <card.icon className={`h-5 w-5 text-white p-1 rounded-md ${card.color}`} />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{card.value}</div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <div className="mt-8 grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-gray-500">
              Welcome to the MotoMarket Admin Dashboard. Here you can manage your products, categories, users, and
              orders.
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Quick Actions</CardTitle>
          </CardHeader>
          <CardContent className="grid grid-cols-2 gap-4">
            <a href="/dashboard/products/add" className="p-3 bg-blue-50 rounded-lg hover:bg-blue-100 transition-colors">
              <ShoppingBag className="h-5 w-5 text-blue-500 mb-2" />
              <div className="text-sm font-medium">Add Product</div>
            </a>
            <a
              href="/dashboard/categories/add"
              className="p-3 bg-green-50 rounded-lg hover:bg-green-100 transition-colors"
            >
              <Tag className="h-5 w-5 text-green-500 mb-2" />
              <div className="text-sm font-medium">Add Category</div>
            </a>
            <a href="/dashboard/users" className="p-3 bg-purple-50 rounded-lg hover:bg-purple-100 transition-colors">
              <Users className="h-5 w-5 text-purple-500 mb-2" />
              <div className="text-sm font-medium">Manage Users</div>
            </a>
            <a href="/dashboard/orders" className="p-3 bg-orange-50 rounded-lg hover:bg-orange-100 transition-colors">
              <ShoppingCart className="h-5 w-5 text-orange-500 mb-2" />
              <div className="text-sm font-medium">View Orders</div>
            </a>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

