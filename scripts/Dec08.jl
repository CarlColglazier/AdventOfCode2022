using DrWatson
@quickactivate


function visible(m, i, j, n)
	if any([
		all(m[i,j] .> m[i,j+1:n]),
		all(m[i,j] .> m[i,1:j-1]),
		all(m[i,j] .> m[i+1:n,j]),
		all(m[i,j] .> m[1:i-1,j])
	])
		return true
	end
	return false
end

f = datadir("input", "8.txt")
m = [parse.(Int, collect(l)) for l in eachline(f)] |>
	x -> hvcat(size(x, 1), x...)
count = 2 * size(m, 1) + 2 * (size(m, 2) - 2)
for i in 2:size(m, 1)-1
	for j in 2:size(m, 2)-1
		count += Int(visible(m, i, j, size(m, 1)))
	end
end
println(count)

# Part 2
function sees(a, v)
	c = 0
	for g in a
		c += 1
		if g >= v
			break
		end
	end
	return c
end

function scenic(m, i, j, n)
	v = m[i,j]
	return reduce(*, [
		sees(m[i,j+1:n], v),
		sees(reverse(m[i,1:j-1]), v),
		sees(m[i+1:n,j], v),
		sees(reverse(m[1:i-1,j]), v)
	])
end

top = 0
for i in 1:size(m, 1)
	for j in 1:size(m, 2)
		top = maximum([top, scenic(m, i, j, size(m, 1))])
	end
end
println(top)
