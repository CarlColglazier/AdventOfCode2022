using DrWatson
@quickactivate

function process(s)
	if s[1:4] == "addx"
		return [0, parse(Int, split(s)[2])]
	elseif s[1:4] == "noop"
		return [0]
	end
end

f = datadir("input", "10.txt")
history = cumsum(reduce(vcat, vcat([[1]], process.(eachline(f)))))
ind = [20, 60, 100, 140, 180, 220]
history |> x -> [x[i]*i for i in ind] |> sum |> println

pixels = (history[2:length(history)] .∈ [[0,1,2].+(i%40) for i in 0:length(history)-2]) |>
	x -> [Dict(1 => "#", 0 => ".")[y] for y in x]

for i in 0:5
	println(reduce(*, pixels[i*40+1:(i+1)*40]))
end
