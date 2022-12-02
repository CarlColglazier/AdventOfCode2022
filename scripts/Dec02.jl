using DrWatson
@quickactivate

@enum RPS rock paper scissors

function compare(x::RPS, y::RPS)
	if x == y
		return 0
	end
	if x == rock
		if y == scissors
			return 1
		end
		return -1
	end
	if x == paper
		if y == rock
			return 1
		end
		return -1
	end
	if x == scissors
		if y == paper
			return 1
		end
		return -1
	end
end

function convert_string(s)
	d = Dict(
		"X" => rock,
		"A" => rock,
		"Y" => paper,
		"B" => paper,
		"Z" => scissors,
		"C" => scissors
	)
	return d[s]
end

f = datadir("input", "2.txt")
score = 0
for line in eachline(f)
	m = split(line) .|> convert_string
	outcome = compare(m[2], m[1])
	score += 1 + Int(m[2]) + (outcome+1)*3
end
println(score)

# part two
# the easiest way to solve this is just hard coding the proper strategy
# X=lose, Y=draw, Z=win
strat = Dict(
	rock => Dict("X"=>scissors, "Y"=>rock, "Z"=>paper),
	paper => Dict("X"=>rock, "Y"=>paper, "Z"=>scissors),
	scissors => Dict("X"=>paper, "Y"=>scissors, "Z"=>rock),
)
score = 0
for line in eachline(f)
	opp = split(line)[1] .|> convert_string
	select = strat[opp][split(line)[2]]
	outcome = compare(select, opp)
	score += 1 + Int(select) + (outcome+1)*3
end
println(score)

