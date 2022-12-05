using DrWatson
@quickactivate

init_re = r"\[(\w)\]|(    )"
move_re = r"move (\d*) from (\d*) to (\d*)"

f = datadir("input", "5.txt")

x = filter(!isnothing, collect.(eachmatch.(init_re, readlines(f)))) |>
	y -> filter(z -> length(z) > 0, y) .|>
	y -> map(z -> first(z.captures), y)

moves = filter(!isnothing, collect.(eachmatch.(move_re, readlines(f)))) |>
	y -> filter(z -> length(z) > 0, y) .|> first .|>
	y -> y.captures .|>
	y -> parse.(Int, y)


offset = 100
current = Array{Union{Nothing, String}}(nothing, 8+offset, 9)
for i in eachindex(x)
	for j in eachindex(x[1])
		current[i + offset, j] = x[i][j]
	end
end

function first_not_nothing(x)
	for i in eachindex(x)
		if !isnothing(x[i])
			return i
		end
	end
	return length(x) + 1
end

function move!(current, from, to)
	from_index = first_not_nothing(current[:,from])
	to_index = first_not_nothing(current[:,to])
	current[to_index - 1, to] = current[from_index, from]
	current[from_index, from] = nothing
end

for m in moves
	for i in 1:m[1]
		move!(current, m[2], m[3])
	end
end

answer = collect(eachcol(current)) .|>
	x -> x[first_not_nothing(x)]
println(reduce(*, answer))


# part 2
offset = 100
current = Array{Union{Nothing, String}}(nothing, 8+offset, 9)
for i in eachindex(x)
	for j in eachindex(x[1])
		current[i + offset, j] = x[i][j]
	end
end

function move_ordered!(current, from, to, remaining)
	from_index = first_not_nothing(current[:,from]) + remaining - 1
	to_index = first_not_nothing(current[:,to])
	current[to_index - 1, to] = current[from_index, from]
	current[from_index, from] = nothing
end

for m in moves
	for i in reverse(1:m[1])
		move_ordered!(current, m[2], m[3], i)
	end
end
answer = collect(eachcol(current)) .|>
	x -> x[first_not_nothing(x)]
println(reduce(*, answer))
