using DrWatson
@quickactivate

function compare(left::Int, right::Int)
	#println(left, " ", right)
	if left != right
		return left < right, true
	end
	return true, false
end

function compare(left::Int, right::Vector)
	#println(left, " ", right)
	return compare([left], right)
end

function compare(left::Vector, right::Int)
	#println(left, " ", right)
	return compare(left, [right])
end

function compare(left::Vector, right::Vector)
	#println(left, " ", right)
	if length(left) == 0 && length(right) > 0 # left out only
		return true, true
	elseif length(left) > 0 && length(right) == 0 # right out only
		return false, true
	elseif length(left) == 0 && length(right) == 0 # both empty
		return true, false
	end
	l = popfirst!(left)
	r = popfirst!(right)
	v, c = compare(l, r)
	#println("Compared! ", v, " ", c)
	if c
		return v, c
	end
	return compare(left, right)
end

function vv(v)
	if length(v) == 1
		return v
	end
	return vv(v[1])
end

f = readlines(datadir("input", "13.txt"))
left = f[1:3:length(f)] .|> Meta.parse .|> Meta.eval
right = f[2:3:length(f)] .|> Meta.parse .|> Meta.eval

function p1()
	count = 0
	for i in eachindex(left)
		v, c = compare(deepcopy(left[i]), deepcopy(right[i]))
		if vv(v)
			count += i
		end
	end
	return count
end
println(p1())

# part 2
f = readlines(datadir("input", "13.txt"))
left = f[1:3:length(f)] .|> Meta.parse .|> Meta.eval
right = f[2:3:length(f)] .|> Meta.parse .|> Meta.eval
x = vcat([[2]], [[6]], left, right)
function comp_sort(x, y)
	v = vv(compare(deepcopy(x), deepcopy(y)))
	return !v
end
function bubblesort!(arr::AbstractVector)
	for _ in 2:length(arr), j in 1:length(arr)-1
		if comp_sort(arr[j], arr[j+1])
			arr[j], arr[j+1] = arr[j+1], arr[j]
		end
	end
	return arr
end

bubblesort!(x)
println(findfirst(x -> x == [2], x) * findfirst(x -> x == [6], x))
