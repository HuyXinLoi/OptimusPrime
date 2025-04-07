"use client"

import { useState, useEffect } from "react"
import Link from "next/link"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Skeleton } from "@/components/ui/skeleton"
import { ShoppingBag, Users, Tag, ShoppingCart, ArrowUpRight, BarChart3, Clock, Activity } from "lucide-react"
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
      color: "bg-blue-500/10 text-blue-500",
      trend: "+12.5%",
      trendUp: true,
    },
    {
      title: "Total Categories",
      value: stats.categories,
      icon: Tag,
      color: "bg-green-500/10 text-green-500",
      trend: "+5.2%",
      trendUp: true,
    },
    {
      title: "Total Users",
      value: stats.users,
      icon: Users,
      color: "bg-purple-500/10 text-purple-500",
      trend: "+18.7%",
      trendUp: true,
    },
    {
      title: "Total Orders",
      value: stats.orders,
      icon: ShoppingCart,
      color: "bg-orange-500/10 text-orange-500",
      trend: "+7.4%",
      trendUp: true,
    },
  ]

  const recentActivities = [
    { title: "New order received", time: "5 minutes ago", icon: ShoppingCart },
    { title: "New user registered", time: "1 hour ago", icon: Users },
    { title: "Product stock updated", time: "3 hours ago", icon: ShoppingBag },
    { title: "New category added", time: "Yesterday", icon: Tag },
  ]

  return (
    <div className="space-y-6">
      <div className="flex flex-col space-y-2">
        <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
        <p className="text-muted-foreground">
          Welcome to your MotoMarket admin dashboard. Here's what's happening with your store today.
        </p>
      </div>

      {isLoading ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {[1, 2, 3, 4].map((i) => (
            <Card key={i} className="overflow-hidden">
              <CardHeader className="pb-2">
                <Skeleton className="h-4 w-24 mb-1" />
              </CardHeader>
              <CardContent>
                <Skeleton className="h-8 w-16 mb-2" />
                <Skeleton className="h-4 w-32" />
              </CardContent>
            </Card>
          ))}
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {statCards.map((card, index) => (
            <Card key={index} className="overflow-hidden">
              <CardHeader className="flex flex-row items-center justify-between pb-2 space-y-0">
                <CardTitle className="text-sm font-medium">{card.title}</CardTitle>
                <div className={`rounded-full p-2 ${card.color}`}>
                  <card.icon className="h-4 w-4" />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold">{card.value}</div>
                <div className="flex items-center pt-1 text-xs">
                  <span className={`flex items-center ${card.trendUp ? "text-green-500" : "text-red-500"}`}>
                    {card.trendUp ? (
                      <ArrowUpRight className="h-3 w-3 mr-1" />
                    ) : (
                      <ArrowUpRight className="h-3 w-3 mr-1 rotate-180" />
                    )}
                    {card.trend}
                  </span>
                  <span className="text-muted-foreground ml-1">from last month</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <Card className="col-span-1">
          <CardHeader>
            <CardTitle className="flex items-center">
              <Activity className="mr-2 h-5 w-5 text-muted-foreground" />
              Recent Activity
            </CardTitle>
            <CardDescription>Latest updates from your store</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {recentActivities.map((activity, index) => (
                <div key={index} className="flex items-start">
                  <div className={`rounded-full p-2 mr-3 ${statCards[index % 4].color}`}>
                    <activity.icon className="h-4 w-4" />
                  </div>
                  <div>
                    <p className="font-medium">{activity.title}</p>
                    <p className="text-sm text-muted-foreground flex items-center">
                      <Clock className="h-3 w-3 mr-1" />
                      {activity.time}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
          <CardFooter className="border-t px-6 py-4">
            <Button variant="outline" className="w-full">
              View All Activity
            </Button>
          </CardFooter>
        </Card>

        <Card className="col-span-1">
          <CardHeader>
            <CardTitle className="flex items-center">
              <BarChart3 className="mr-2 h-5 w-5 text-muted-foreground" />
              Quick Actions
            </CardTitle>
            <CardDescription>Shortcuts to common tasks</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 gap-4">
              <Link href="/dashboard/products/add" className="group">
                <div className="flex flex-col items-center justify-center p-4 bg-blue-50 rounded-lg border border-blue-100 transition-all hover:bg-blue-100 hover:shadow-sm">
                  <div className="p-2 rounded-full bg-blue-500/10 text-blue-500 mb-2 group-hover:bg-blue-500/20">
                    <ShoppingBag className="h-5 w-5" />
                  </div>
                  <div className="text-sm font-medium">Add Product</div>
                </div>
              </Link>
              <Link href="/dashboard/categories/add" className="group">
                <div className="flex flex-col items-center justify-center p-4 bg-green-50 rounded-lg border border-green-100 transition-all hover:bg-green-100 hover:shadow-sm">
                  <div className="p-2 rounded-full bg-green-500/10 text-green-500 mb-2 group-hover:bg-green-500/20">
                    <Tag className="h-5 w-5" />
                  </div>
                  <div className="text-sm font-medium">Add Category</div>
                </div>
              </Link>
              <Link href="/dashboard/users" className="group">
                <div className="flex flex-col items-center justify-center p-4 bg-purple-50 rounded-lg border border-purple-100 transition-all hover:bg-purple-100 hover:shadow-sm">
                  <div className="p-2 rounded-full bg-purple-500/10 text-purple-500 mb-2 group-hover:bg-purple-500/20">
                    <Users className="h-5 w-5" />
                  </div>
                  <div className="text-sm font-medium">Manage Users</div>
                </div>
              </Link>
              <Link href="/dashboard/orders" className="group">
                <div className="flex flex-col items-center justify-center p-4 bg-orange-50 rounded-lg border border-orange-100 transition-all hover:bg-orange-100 hover:shadow-sm">
                  <div className="p-2 rounded-full bg-orange-500/10 text-orange-500 mb-2 group-hover:bg-orange-500/20">
                    <ShoppingCart className="h-5 w-5" />
                  </div>
                  <div className="text-sm font-medium">View Orders</div>
                </div>
              </Link>
            </div>
          </CardContent>
          <CardFooter className="border-t px-6 py-4">
            <Button variant="outline" className="w-full">
              View All Features
            </Button>
          </CardFooter>
        </Card>
      </div>
    </div>
  )
}

