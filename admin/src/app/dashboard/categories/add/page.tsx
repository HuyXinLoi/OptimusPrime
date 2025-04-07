/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Textarea } from "@/components/ui/textarea"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { ArrowLeft, Save, Tag } from "lucide-react"
import { addCategory } from "@/lib/api/categories"
import { toast } from "sonner"

export default function AddCategoryPage() {
  const [formData, setFormData] = useState({
    name: "",
    type: "",
    description: "",
  })
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target
    setFormData((prev) => ({ ...prev, [name]: value }))
  }

  const handleTypeChange = (value: string) => {
    setFormData((prev) => ({ ...prev, type: value }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)

    try {
      await addCategory(formData)
      toast.success("Category added successfully")
      router.push("/dashboard/categories")
    } catch (error: any) {
      console.error("Error adding category:", error)
      toast.error("Failed to add category")
    } finally {
      setIsLoading(false)
    }
  }

  // Function to get color for category type
  const getCategoryTypeColor = (type: string) => {
    switch (type) {
      case "loai_xe":
        return "text-blue-600"
      case "hang":
        return "text-purple-600"
      case "loai_nhienlieu":
        return "text-green-600"
      case "loai_dongco":
        return "text-amber-600"
      case "mausac":
        return "text-pink-600"
      default:
        return ""
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight">Add New Category</h1>
          <p className="text-muted-foreground">Create a new category for your products</p>
        </div>
        <Button variant="outline" size="sm" onClick={() => router.push("/dashboard/categories")}>
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Categories
        </Button>
      </div>

      <Tabs defaultValue="general" className="space-y-4">
        <TabsList>
          <TabsTrigger value="general">General Information</TabsTrigger>
        </TabsList>
        <TabsContent value="general" className="space-y-4">
          <form onSubmit={handleSubmit}>
            <Card>
              <CardHeader>
                <CardTitle>Category Details</CardTitle>
                <CardDescription>Fill in the information for your new category</CardDescription>
              </CardHeader>
              <CardContent className="space-y-6">
                <div className="grid gap-6 sm:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="name">Category Name</Label>
                    <Input
                      id="name"
                      name="name"
                      value={formData.name}
                      onChange={handleChange}
                      placeholder="Enter category name"
                      required
                    />
                    <p className="text-sm text-muted-foreground">This name will be displayed to customers</p>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="type" className="flex items-center">
                      <Tag className="mr-1 h-4 w-4" /> Category Type
                    </Label>
                    <Select value={formData.type} onValueChange={handleTypeChange} required>
                      <SelectTrigger
                        id="type"
                        className="bg-white border-gray-300 hover:border-gray-400 focus:border-primary shadow-sm"
                      >
                        <SelectValue placeholder="Select a category type" />
                      </SelectTrigger>
                      <SelectContent className="bg-white border-2 shadow-xl">
                        <SelectItem value="loai_xe" className="text-blue-600 font-medium">
                          Xe
                        </SelectItem>
                        <SelectItem value="hang" className="text-purple-600 font-medium">
                          Hãng
                        </SelectItem>
                        <SelectItem value="loai_nhienlieu" className="text-green-600 font-medium">
                          Nhiên Liệu
                        </SelectItem>
                        <SelectItem value="loai_dongco" className="text-amber-600 font-medium">
                          Động Cơ
                        </SelectItem>
                        <SelectItem value="mausac" className="text-pink-600 font-medium">
                          Màu Sắc
                        </SelectItem>
                      </SelectContent>
                    </Select>
                    <p className="text-sm text-muted-foreground">Used for filtering and organization</p>
                  </div>
                </div>

                <div className="space-y-2">
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    name="description"
                    value={formData.description}
                    onChange={handleChange}
                    placeholder="Enter a detailed description of this category"
                    rows={5}
                    required
                  />
                  <p className="text-sm text-muted-foreground">
                    Provide details about what products belong in this category
                  </p>
                </div>
              </CardContent>
              <CardFooter className="flex justify-between border-t px-6 py-4">
                <Button type="button" variant="outline" onClick={() => router.push("/dashboard/categories")}>
                  Cancel
                </Button>
                <Button type="submit" disabled={isLoading}>
                  {isLoading ? (
                    <>
                      <svg
                        className="mr-2 h-4 w-4 animate-spin"
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                      >
                        <circle
                          className="opacity-25"
                          cx="12"
                          cy="12"
                          r="10"
                          stroke="currentColor"
                          strokeWidth="4"
                        ></circle>
                        <path
                          className="opacity-75"
                          fill="currentColor"
                          d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                        ></path>
                      </svg>
                      Adding...
                    </>
                  ) : (
                    <>
                      <Save className="mr-2 h-4 w-4" />
                      Add Category
                    </>
                  )}
                </Button>
              </CardFooter>
            </Card>
          </form>
        </TabsContent>
      </Tabs>
    </div>
  )
}

