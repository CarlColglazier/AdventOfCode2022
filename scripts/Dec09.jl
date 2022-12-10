using DrWatson
@quickactivate

f = datadir("input", "9.txt")

s = Set{Array{Int}}()
h = [1, 1]
t = [1, 1]
push!(s, t)

function move!(p, dir)
	if dir == "U"
		p[2] += 1
	elseif dir == "D"
		p[2] -= 1
	elseif dir == "L"
		p[1] -= 1
	elseif dir == "R"
		p[1] += 1
	end
end

function follow!(t, h)
	dist = sum([abs(t[1] - h[1]), abs(t[2] - h[2])])
	diag = (minimum([abs(t[1] - h[1]), abs(t[2] - h[2])]) == 1)
	if dist == 1 || (diag && dist == 2)
		return
	end
	if h[1] > t[1]
		t[1] += 1
	elseif h[1] < t[1]
		t[1] -= 1
	end
	if h[2] > t[2]
		t[2] += 1
	elseif h[2] < t[2]
		t[2] -= 1
	end
end

for l in eachline(f)
	command = split(l)
	dir = command[1]
	amount = parse(Int, command[2])
	for i in 1:amount
		move!(h, dir)
		follow!(t, h)
		#println(h, t)
		push!(s, deepcopy(t))
	end
end
println(length(s))

# Part 2
ropes = [[1,1] for _ in 1:10]
s = Set{Array{Int}}()
for l in eachline(f)
	command = split(l)
	dir = command[1]
	amount = parse(Int, command[2])
	for i in 1:amount
		move!(ropes[1], dir)
		for j in 2:10
			follow!(ropes[j], ropes[j-1])
			#println(h, t)
		end
		push!(s, deepcopy(ropes[10]))
	end
end
println(length(s))

