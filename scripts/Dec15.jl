using DrWatson
@quickactivate

struct Sensor
	x::Int
	y::Int
	bx::Int
	by::Int
end

function distance(s::Sensor, x::Int, y::Int)
	return abs(s.x - x) + abs(s.y - y)
end

function distance(s::Sensor)
	return distance(s, s.bx, s.by)
end

function in_range(s::Sensor, x::Int, y::Int)
	return distance(s, x, y) <= distance(s)
end

function in_range(s::Vector, x::Int, y::Int)
	return any([in_range(z, x, y) for z in s])
end

function points(s::Sensor, y::Int)
	d = distance(s)
	points = CartesianIndex(minimum([s.x,s.bx])-d,y):CartesianIndex(maximum([s.x,s.bx])+d,y)
	return filter(t -> in_range(s, t[1], t[2]), Tuple.(points))
end


f = datadir("input", "15.txt")
lines = readlines(f)

r = 2000000

data = lines |>
	x -> map(y -> map(x -> parse(Int, x.match), eachmatch(r"(-?\d+)", y)), x)
sensors = [Sensor(x...) for x in data]
pts = reduce(union, Set.(points.(sensors, r)))
println(length(setdiff(filter(x -> x[2] == r, pts), Set((s.bx, s.by) for s in sensors))))
# part 2
m = 4000000
for s in sensors
	d = distance(s) + 1
	for i in 1:d
		ps = [(s.x+i, s.y+d-i)]
		for p in ps
			if any([p[1] < 0, p[1] > m, p[2] < 0, p[2] > m])
				continue
			end
			if !in_range(sensors, p[1], p[2])
				println(i, " ", p)
				println(p[1]*4000000+p[2])
				break
			end
		end
	end
end

