
using Pkg
# activate the environment
Pkg.activate(".")

# Adding packages
Pkg.add("DataFrames")
Pkg.add("Query")

# Importing packages
using DataFrames, Query

# Creating DataFrames
df = DataFrame(Name=["Alice", "Bob", "Charlie"], Age=[25, 30, 35], Score=[85.5, 90.0, 88.0])
println(df)

# add a column
df.Country = ["USA", "UK", "Canada"]  # Add a column

# remove a column
select!(df, Not(:Score))

# View the first 2 rows
first(df, 2)

# Rows where Age > 28
filtered_df = filter(row -> row.Age > 28, df)

# Summarizing the data
describe(df)

# Joins
df1 = DataFrame(ID=[1, 2, 3], Name=["Alice", "Bob", "Charlie"])
df2 = DataFrame(ID=[2, 3, 4], Score=[90, 85, 88])
inner = innerjoin(df1, df2, on=:ID)    # Inner join
outer = outerjoin(df1, df2, on=:ID)    # Outer join
left = leftjoin(df1, df2, on=:ID)      # Left join
right = rightjoin(df1, df2, on=:ID)    # Right join
println("Inner Join:\n", inner)
println("Outer Join:\n", outer)

# Grouping
df = DataFrame(Category=["A", "B", "A", "B"], Value=[10, 20, 15, 25])
# Group by 'Category' and calculate the sum
grouped = combine(groupby(df, :Category), :Value => sum => :Total)
println(grouped)

# Sorting
df = DataFrame(Name=["Alice", "Bob", "Charlie"], Score=[85.5, 90.0, 88.0])
# Sort by Score in descending order
sorted_df = sort(df, :Score, rev=true)
println(sorted_df)


# Query.jl
# selecting specific column
df = DataFrame(ID=[1, 2, 3], Name=["Alice", "Bob", "Charlie"], Score=[85, 90, 88])
# Select specific columns
selected = @from r in df begin
    @select {r.ID, r.Name}
    @collect DataFrame
end
println(selected)

#Sorting and Limiting Rows

df = DataFrame(a=[3,1,3,2,1,3],b=[1,2,1,1,3,2])

x = @from i in df begin
    @orderby descending(i.a), i.b
    @select i
    @collect DataFrame
end 
x = x |> @take(3) |> DataFrame

println(x)


# Joins with Query.jl
df1 = DataFrame(ID=[1, 2, 3], Name=["Alice", "Bob", "Charlie"])
df2 = DataFrame(ID=[2, 3, 4], Score=[90, 85, 88])
joined = @from i in df1 begin
    @join j in df2 on i.ID equals j.ID
    @select {i.ID, i.Name, j.Score}
    @collect DataFrame
end
println(joined)


df = DataFrame(ID=[1, 2, 3, 4], Name=["Alice", "Bob", "Charlie", "David"], Score=[85, 90, 88, 75])
# Filter, sort, and select
result = @from r in df begin
    @where r.Score > 80
    @orderby descending(r.Score)
    @select {r.Name, r.Score}
    @collect DataFrame
end
println(result)




# Benchmarking
using DataFrames, Random

# Generate a large DataFrame
n = 10_000_000
df = DataFrame(
    id = 1:n,
    value = rand(n),
    category = rand(["A", "B", "C", "D"], n)
)

# Filter rows where value > 0.5
@time filtered_df = df[df.value .> 0.5, :]
