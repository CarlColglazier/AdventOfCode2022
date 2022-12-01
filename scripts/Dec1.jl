using DrWatson
@quickactivate


"""
i/o helper.

returns a list of lists.
"""
function read_count_lines(f)
	all_counts = []
	counts = []
	for line in eachline(f)
		if length(line) == 0
			push!(all_counts, counts)
			counts = []
		else
			push!(counts, parse(Int, line))
		end
	end
	# last line
	push!(all_counts, counts)
	return all_counts
end


# part one
max_cal, index = read_count_lines(datadir("input", "1.txt")) |>
	x -> map(sum, x) |>
	findmax

# part two
top_three_count = read_count_lines(datadir("input", "1.txt")) |>
	x -> map(sum, x) |>
	x -> sort(x, rev=true) |>
	x -> sum(x[1:3])
