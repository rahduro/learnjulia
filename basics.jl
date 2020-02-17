println("hello world")

printstyled(typeof(43.2), "\n\n", bold=true, color=:light_red)

# some builtin math constants
@show float(π), typeof(π), π == pi
a = √3
# b = Irrational(a)

@show typeof(a) #a == b
@show typeof(Float64)


# concatenate strings
println("hello"*" world"*"!")

# functions can take different types of typed, dynamic, named, optional and variable number of arguments

function typehierarchy(x)
    types = [typeof(x)]

    function recsuptypes(y, chain)
        st = supertype(y)
        push!(chain, st)
        if st != Any
            recsuptypes(st, chain)
        end
    end

    recsuptypes(types[1], types)
    return types
end

@show typehierarchy(4) typehierarchy(MathConstants.e)

# composite objects by default are subtypes of Any
struct Foo
    whatever
    index::Int
    name::String
end

# construct structures
a = Foo(Foo(nothing, -1, "last element"), 1, "first element")
@show supertype(typeof(a))

# can see inner elements by field*
@show fieldcount(Foo), fieldnames(Foo), fieldtypes(Foo), fieldoffset(Foo, 2)

# avoid global access whenever possible, functions operating on local variables are usually faster
function sum_xs(x::Vector{Float64})
    sum = 0.0
    for i in x
        sum += i
    end
    sum
end

function sum_gxs()
    sum = 0.0
    global x, x1
    for i in x
        sum += i
    end
    x1 = 5
    @show sum # it will also return the expression not just print
end

x = rand(10000)
x1 = -10
@time sum_gxs()
@time sum_xs(rand(10000))
@show x1
ret = sum_gxs()
@show ret


# julia stores arrays in column major format
function hugematsum(M::Array{Float64}, major='c')
    @assert ndims(M) == 2 "It should be a 2-dim array/matrix"
    r, c = size(M)
    sum = 0.0
    if major == 'c'
        for c = 1:c, r = 1:r
            @inbounds sum += M[r,c] # no array bounds checking
        end
    elseif major == 'r'
        for r = 1:r, c = 1:c
            @inbounds sum += M[r,c]
        end
    end
    sum
end

randmat = randn(10^4, 10^4)
@time @show hugematsum(randmat)
@time @show hugematsum(randmat, 'r')

# BitArray can be used to save a lot of space for storing 0,1s
bools = BitArray(undef, 3, 3)

# creates BitArray of 1 and zeros respectively
@show ones(3, 4)
@show zeros(5, 5)


# As unicode strings using UTF-8 encoding (multibyte characters upto 4) is supported, therefore not all indices in a string return valid characters
name = "π, γ, α are all greek letters"

# @show name[2] # does not work because first character is not single byte

# one way to parse such strings by character
for i in eachindex(name)
    println(tuple(i, name[i]))
end

# another way
l = length(name)
cur = 1
while l != 0 # access the variable l from outer scope
    print(name[cur])
    global cur = nextind(name, cur)
    global l -= 1
end
