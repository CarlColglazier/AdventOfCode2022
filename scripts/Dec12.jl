using DrWatson
@quickactivate

@enum Dir up down left right
move_dict = Dict(up=>(0,-1), down=>(0,1), left=>(-1,0), right=>(1,0))


mutable struct Vertex
	x::Int
	y::Int
	parent::Union{Nothing, Vertex}
end


function can_visit(m::Matrix, pos::Vertex, to_x, to_y)
	if to_x < 1 || to_y < 1 || to_x > size(m, 1) || to_y > size(m, 2)
		return false
	end
	return c[pos.x, pos.y] - c[to_x, to_y] <= 1
end

function search(m, start, wanted)
	queue = [Vertex(start[1], start[2], nothing)]
	visited = Set([(start[1], start[2])])
	while length(queue) > 0
		v = popfirst!(queue)
		pos = (v.x, v.y)
		if pos == wanted
			return v
		end
		for d in [up, down, left, right]
			n = pos .+ move_dict[d]
			if n ∉ visited && can_visit(m, v, n[1], n[2])
				push!(visited, n)
				push!(queue, Vertex(n[1], n[2], v))
			end
		end
	end
	println("Error")
end


function par(v::Vertex)
	println(v.x, ", ", v.y)
	if v.parent == nothing
		return 0
	end
	return par(v.parent) + 1
end


f = readlines(datadir("input", "12.txt"))

c = map(x -> replace(x, 'S'=>'a', 'E'=>'z'), f) |>
	x -> map(z -> [y - 'a' for y in z], x) |>
	x -> hcat(x...) |> Matrix

init_pos = findfirst(x -> x == 'S', reduce(*, f)) |>
	x -> (x % length(f[1]), x ÷ length(f[1])+1)

want_pos = findfirst(x -> x == 'E', reduce(*, f)) |>
	x -> (x % length(f[1]), x ÷ length(f[1])+1)

v = search(Matrix(c), want_pos, init_pos)
println(par(v))

# part 2
function search2(m, start, wanted)
	queue = [Vertex(start[1], start[2], nothing)]
	visited = Set([(start[1], start[2])])
	while length(queue) > 0
		v = popfirst!(queue)
		pos = (v.x, v.y)
		if m[v.x, v.y] == 0
			return v
		end
		for d in [up, down, left, right]
			n = pos .+ move_dict[d]
			if n ∉ visited && can_visit(m, v, n[1], n[2])
				push!(visited, n)
				push!(queue, Vertex(n[1], n[2], v))
			end
		end
	end
	println("Error")
end

v = search2(Matrix(c), want_pos, init_pos)
println(par(v))
