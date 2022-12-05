using DrWatson
@quickactivate

function to_range(s)
	n = parse.(Int, split(s, "-"))
	return Set(n[1]:n[2])
end

function has_overlap(line)
	l1, l2 = to_range.(split(line, ","))
	return minimum(length.([setdiff(l1, l2), setdiff(l2, l1)])) == 0
end

count = 0
for l in eachline(datadir("input", "4.txt"))
	if has_overlap(l)
		count += 1
	end
end
println(count)

# part 2

function has_intersect(line)
	l1, l2 = to_range.(split(line, ","))
	return minimum(length.([intersect(l1, l2), intersect(l2, l1)])) > 0
end

count = 0
for l in eachline(datadir("input", "4.txt"))
	if has_intersect(l)
		count += 1
	end
end
println(count)
