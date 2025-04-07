"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { use } from "react"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Skeleton } from "@/components/ui/skeleton"
import { Separator } from "@/components/ui/separator"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { ArrowLeft, CreditCard, FileText, MapPin, Package, Printer, ShoppingBag, Truck, User } from "lucide-react"
import { getOrderById, updateOrderStatus } from "@/lib/api/orders"
import { toast } from "sonner"

export default function OrderDetailPage({ params }: { params: Promise<{ id: string }> }) {
  // Unwrap the params Promise using React.use()
  const resolvedParams = use(params)
  const id = resolvedParams.id

  const [order, setOrder] = useState<any>(null)
  const [isLoading, setIsLoading] = useState(true)
  const [isUpdating, setIsUpdating] = useState(false)
  const router = useRouter()

  useEffect(() => {
    const fetchOrder = async () => {
      setIsLoading(true)
      try {
        const data = await getOrderById(id)
        setOrder(data)
      } catch (error) {
        console.error("Error fetching order:", error)
        toast.error("Failed to fetch order details")
      } finally {
        setIsLoading(false)
      }
    }

    fetchOrder()
  }, [id])

  const handleStatusChange = async (status: string) => {
    setIsUpdating(true)
    try {
      await updateOrderStatus(id, status)
      setOrder((prev: any) => ({ ...prev, status }))
      toast.success("Order status updated successfully")
    } catch (error) {
      console.error("Error updating order status:", error)
      toast.error("Failed to update order status")
    } finally {
      setIsUpdating(false)
    }
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return new Intl.DateTimeFormat("vi-VN", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date)
  }

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(amount)
  }

  const getStatusBadgeColor = (status: string) => {
    switch (status?.toLowerCase()) {
      case "pending":
        return "bg-yellow-100 text-yellow-800"
      case "processing":
        return "bg-blue-100 text-blue-800"
      case "shipped":
        return "bg-purple-100 text-purple-800"
      case "delivered":
        return "bg-green-100 text-green-800"
      case "cancelled":
        return "bg-red-100 text-red-800"
      default:
        return "bg-gray-100 text-gray-800"
    }
  }

  if (isLoading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <Skeleton className="h-8 w-48" />
          <Skeleton className="h-10 w-24" />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 space-y-6">
            <Card>
              <CardHeader>
                <Skeleton className="h-6 w-32 mb-2" />
                <Skeleton className="h-4 w-48" />
              </CardHeader>
              <CardContent className="space-y-4">
                {Array.from({ length: 3 }).map((_, index) => (
                  <div key={index} className="flex justify-between items-center">
                    <Skeleton className="h-16 w-16 rounded" />
                    <div className="flex-1 mx-4">
                      <Skeleton className="h-4 w-48 mb-2" />
                      <Skeleton className="h-4 w-24" />
                    </div>
                    <Skeleton className="h-6 w-24" />
                  </div>
                ))}
              </CardContent>
            </Card>
          </div>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <Skeleton className="h-6 w-32 mb-2" />
              </CardHeader>
              <CardContent className="space-y-4">
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-full" />
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <Skeleton className="h-6 w-32 mb-2" />
              </CardHeader>
              <CardContent className="space-y-4">
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-full" />
                <Skeleton className="h-4 w-full" />
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight">Order #{order?.orderNumber || id.substring(0, 8)}</h1>
            <Badge variant="outline" className={getStatusBadgeColor(order?.status || "pending")}>
              {order?.status || "Pending"}
            </Badge>
          </div>
          <p className="text-muted-foreground">Placed on {order?.createdAt ? formatDate(order.createdAt) : "N/A"}</p>
        </div>
        <Button variant="outline" size="sm" onClick={() => router.push("/dashboard/orders")}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Orders
        </Button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <ShoppingBag className="mr-2 h-5 w-5 text-muted-foreground" />
                Order Items
              </CardTitle>
              <CardDescription>Products included in this order</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {order?.items?.map((item: any, index: number) => (
                  <div key={index} className="flex items-start border-b pb-4 last:border-0 last:pb-0">
                    <div className="h-16 w-16 rounded bg-gray-100 overflow-hidden flex-shrink-0">
                      <img
                        src={item.product?.image || "/placeholder.svg"}
                        alt={item.product?.name || "Product"}
                        className="h-full w-full object-cover"
                      />
                    </div>
                    <div className="ml-4 flex-1">
                      <h4 className="font-medium">{item.product?.name || "Product"}</h4>
                      <p className="text-sm text-muted-foreground">
                        Quantity: {item.quantity} × {formatCurrency(item.price)}
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="font-medium">{formatCurrency(item.quantity * item.price)}</p>
                    </div>
                  </div>
                ))}
              </div>

              <div className="mt-6 space-y-2">
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Subtotal</span>
                  <span>{formatCurrency(order?.subtotal || 0)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Shipping</span>
                  <span>{formatCurrency(order?.shippingCost || 0)}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Tax</span>
                  <span>{formatCurrency(order?.tax || 0)}</span>
                </div>
                <Separator className="my-2" />
                <div className="flex justify-between font-medium">
                  <span>Total</span>
                  <span>{formatCurrency(order?.totalAmount || 0)}</span>
                </div>
              </div>
            </CardContent>
            <CardFooter className="flex justify-between border-t px-6 py-4">
              <Button variant="outline">
                <Printer className="mr-2 h-4 w-4" />
                Print Order
              </Button>
              <Button>
                <FileText className="mr-2 h-4 w-4" />
                Download Invoice
              </Button>
            </CardFooter>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <User className="mr-2 h-5 w-5 text-muted-foreground" />
                Customer Information
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Name</h4>
                <p>{order?.user?.name || "Guest"}</p>
              </div>
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Email</h4>
                <p>{order?.user?.email || "N/A"}</p>
              </div>
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Phone</h4>
                <p>{order?.user?.phone || "N/A"}</p>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <MapPin className="mr-2 h-5 w-5 text-muted-foreground" />
                Shipping Address
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="whitespace-pre-line">
                {order?.shippingAddress?.street || "N/A"}
                {order?.shippingAddress?.city && `, ${order.shippingAddress.city}`}
                {order?.shippingAddress?.state && `, ${order.shippingAddress.state}`}
                {order?.shippingAddress?.postalCode && ` ${order.shippingAddress.postalCode}`}
                {order?.shippingAddress?.country && `, ${order.shippingAddress.country}`}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <CreditCard className="mr-2 h-5 w-5 text-muted-foreground" />
                Payment Information
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Method</h4>
                <p>{order?.paymentMethod || "N/A"}</p>
              </div>
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Status</h4>
                <Badge
                  variant="outline"
                  className={order?.isPaid ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800"}
                >
                  {order?.isPaid ? "Paid" : "Pending"}
                </Badge>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center">
                <Truck className="mr-2 h-5 w-5 text-muted-foreground" />
                Order Status
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Current Status</h4>
                <Badge variant="outline" className={getStatusBadgeColor(order?.status || "pending")}>
                  {order?.status || "Pending"}
                </Badge>
              </div>
              <div>
                <h4 className="text-sm font-medium text-muted-foreground mb-1">Update Status</h4>
                <Select
                  defaultValue={order?.status || "pending"}
                  onValueChange={handleStatusChange}
                  disabled={isUpdating}
                >
                  <SelectTrigger className="bg-white border-gray-300 hover:border-gray-400 focus:border-primary shadow-sm">
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                  <SelectContent className="bg-white border-2 shadow-xl z-[9999]">
                    <SelectItem value="pending" className="text-yellow-600 font-medium">
                      Pending
                    </SelectItem>
                    <SelectItem value="processing" className="text-blue-600 font-medium">
                      Processing
                    </SelectItem>
                    <SelectItem value="shipped" className="text-purple-600 font-medium">
                      Shipped
                    </SelectItem>
                    <SelectItem value="delivered" className="text-green-600 font-medium">
                      Delivered
                    </SelectItem>
                    <SelectItem value="cancelled" className="text-red-600 font-medium">
                      Cancelled
                    </SelectItem>
                  </SelectContent>
                </Select>
              </div>
              {order?.trackingNumber && (
                <div>
                  <h4 className="text-sm font-medium text-muted-foreground mb-1">Tracking Number</h4>
                  <p>{order.trackingNumber}</p>
                </div>
              )}
            </CardContent>
            <CardFooter className="border-t px-6 py-4">
              <Button className="w-full" disabled={isUpdating}>
                <Package className="mr-2 h-4 w-4" />
                {isUpdating ? "Updating..." : "Save Changes"}
              </Button>
            </CardFooter>
          </Card>
        </div>
      </div>
    </div>
  )
}

